import { chunkKey, type ChunkCoord } from "./chunk.ts";
import { itemDef, resourceNodeForTile } from "./content.ts";
import { CHUNK_SIZE, TILE_SUBPIXELS } from "./constants.ts";
import { Inventory } from "./items/inventory.ts";
import { type BlockedFn, floorDiv, type Position, step } from "./movement.ts";
import { ResourceNodes } from "./resource_nodes.ts";
import {
  actionTicks,
  checkGather,
  NODE_LAYER,
  Notice,
  type ResourceNodeDef,
} from "./skills/gathering.ts";
import { PlayerSkills, type SkillId } from "./skills/skills.ts";
import { STARTER_TOOL } from "./skills/woodcutting.ts";
import type { TileChange } from "./world.ts";

/** Chunks streamed to a player in every direction around their chunk. */
export const CHUNK_VIEW_RADIUS = 2;

/** Inputs buffered per player before new ones are dropped. */
export const MAX_QUEUED_INPUTS = 10;

/**
 * Inputs a player can bank to absorb network jitter. A client gets one input
 * per tick on average, so sending inputs faster than the tick rate does not
 * make anyone faster.
 */
export const MAX_INPUT_BUDGET = 3;

/** Center of the spawn tile (0, 0). */
export const SPAWN: Position = { x: TILE_SUBPIXELS / 2, y: TILE_SUBPIXELS / 2 };

/**
 * One step of player intent. Gathers share the sequence numbers of moves so
 * a gather sent after a walk is applied after it.
 */
export type PlayerInput =
  | { readonly kind: "move"; readonly seq: number; readonly dx: number; readonly dy: number }
  | { readonly kind: "gather"; readonly seq: number; readonly tileX: number; readonly tileY: number };

export interface GatherAction {
  readonly kind: "gather";
  readonly tileX: number;
  readonly tileY: number;
  readonly node: ResourceNodeDef;
  startTick: number;
  durationTicks: number;
}

/** What a player keeps across reconnects. */
export interface PlayerProgress {
  readonly skills: PlayerSkills;
  readonly inventory: Inventory;
}

/** Changes to a player's own state since they were last taken. */
export interface PlayerUpdates {
  readonly inventory: boolean;
  readonly skills: readonly SkillId[];
  readonly action: boolean;
  readonly notices: readonly Notice[];
}

export interface PlayerState extends PlayerProgress {
  readonly id: string;
  position: Position;
  lastInputSeq: number;
  readonly pendingInputs: PlayerInput[];
  inputBudget: number;
  readonly sentChunks: Set<string>;
  action: GatherAction | undefined;
  inventoryDirty: boolean;
  actionDirty: boolean;
  readonly dirtySkills: Set<SkillId>;
  readonly notices: Notice[];
}

/** The part of a world the simulation needs. */
export interface ZoneWorld {
  readonly isBlocked: BlockedFn;
  tileAt(tileX: number, tileY: number, layer: string): number;
  setTile(
    tileX: number,
    tileY: number,
    layer: string,
    tileId: number,
  ): TileChange | undefined;
}

export interface EntityView {
  readonly id: string;
  readonly position: Position;
}

export interface ZoneSimulationOptions {
  /** Source of randomness in [0, 1), like Math.random. */
  readonly random?: () => number;
}

/** Authoritative simulation of one zone, independent of any transport. */
export class ZoneSimulation {
  readonly #players = new Map<string, PlayerState>();
  readonly #progress = new Map<string, PlayerProgress>();
  readonly #nodes: ResourceNodes;
  #tileChanges: TileChange[] = [];
  #tick = 0;

  constructor(
    readonly world: ZoneWorld,
    options: ZoneSimulationOptions = {},
  ) {
    this.#nodes = new ResourceNodes(options.random);
  }

  get tick(): number {
    return this.#tick;
  }

  get playerCount(): number {
    return this.#players.size;
  }

  player(id: string): PlayerState | undefined {
    return this.#players.get(id);
  }

  /** Adds a player, restoring their progress if they were here before. */
  addPlayer(id: string, position: Position = SPAWN): PlayerState {
    const player: PlayerState = {
      id,
      position,
      lastInputSeq: 0,
      pendingInputs: [],
      inputBudget: MAX_INPUT_BUDGET,
      sentChunks: new Set(),
      ...this.#progressOf(id),
      action: undefined,
      inventoryDirty: false,
      actionDirty: false,
      dirtySkills: new Set(),
      notices: [],
    };
    this.#players.set(id, player);
    return player;
  }

  /** Removes a player. Their progress is kept for when they come back. */
  removePlayer(id: string): void {
    this.#players.delete(id);
  }

  /** Queues an input; stale, duplicate or excess inputs are ignored. */
  queueInput(id: string, input: PlayerInput): void {
    const player = this.#players.get(id);
    if (player === undefined) return;

    const newestSeq =
      player.pendingInputs.at(-1)?.seq ?? player.lastInputSeq;
    if (input.seq <= newestSeq) return;
    if (player.pendingInputs.length >= MAX_QUEUED_INPUTS) return;

    player.pendingInputs.push(input);
  }

  /** Stops the player's action, if any. */
  cancelAction(id: string): void {
    const player = this.#players.get(id);
    if (player !== undefined) this.#stop(player);
  }

  /**
   * Equips the tool in an inventory slot if the player meets its level
   * requirement.
   */
  equip(id: string, slot: number): void {
    const player = this.#players.get(id);
    const tool = player?.inventory.toolAt(slot)?.tool;
    if (player === undefined || tool === undefined) return;
    if (player.skills.level(tool.skill) < tool.levelRequirement) {
      player.notices.push(Notice.levelTooLow);
      return;
    }
    player.inventory.equip(slot);
    player.inventoryDirty = true;
  }

  /** Debug: gives a player items. */
  grantItem(id: string, itemId: string, count: number): void {
    const player = this.#players.get(id);
    if (player === undefined) return;
    if (player.inventory.add(itemId, count) > 0) player.inventoryDirty = true;
  }

  /** Debug: gives a player XP. */
  grantXp(id: string, skill: SkillId, amount: number): void {
    const player = this.#players.get(id);
    if (player === undefined) return;
    player.skills.addXp(skill, amount);
    player.dirtySkills.add(skill);
  }

  /** Advances the zone by one tick. */
  step(): void {
    for (const { tileX, tileY, node } of this.#nodes.takeDue(this.#tick)) {
      this.#setTile(tileX, tileY, node.tileId);
    }
    for (const player of this.#players.values()) {
      player.inputBudget = Math.min(player.inputBudget + 1, MAX_INPUT_BUDGET);
      while (player.inputBudget > 0 && player.pendingInputs.length > 0) {
        const input = player.pendingInputs.shift()!;
        if (input.kind === "move") {
          if (input.dx !== 0 || input.dy !== 0) this.#stop(player);
          player.position = step(player.position, input, this.world.isBlocked);
        } else {
          this.#startGather(player, input.tileX, input.tileY);
        }
        player.lastInputSeq = input.seq;
        player.inputBudget--;
      }
      this.#progressAction(player);
    }
    this.#tick++;
  }

  /** Tiles edited since the last call. */
  takeTileChanges(): TileChange[] {
    const changes = this.#tileChanges;
    this.#tileChanges = [];
    return changes;
  }

  /** Changes to a player's own state since the last call. */
  takePlayerUpdates(id: string): PlayerUpdates | undefined {
    const player = this.#players.get(id);
    if (player === undefined) return undefined;
    const updates: PlayerUpdates = {
      inventory: player.inventoryDirty,
      skills: [...player.dirtySkills],
      action: player.actionDirty,
      notices: player.notices.splice(0),
    };
    player.inventoryDirty = false;
    player.actionDirty = false;
    player.dirtySkills.clear();
    return updates;
  }

  /** Whether the player has received the chunk holding a change. */
  hasChunk(id: string, cx: number, cy: number): boolean {
    return this.#players.get(id)?.sentChunks.has(chunkKey(cx, cy)) ?? false;
  }

  /** Everything the given player can see. Tiny scale: every player. */
  entitiesVisibleTo(_id: string): EntityView[] {
    return [...this.#players.values()].map(({ id, position }) => ({
      id,
      position,
    }));
  }

  /**
   * Chunks around the player that they have not received yet, marking them
   * as sent.
   */
  takeUnsentChunks(id: string): ChunkCoord[] {
    const player = this.#players.get(id);
    if (player === undefined) return [];

    const centerX = floorDiv(player.position.x, TILE_SUBPIXELS * CHUNK_SIZE);
    const centerY = floorDiv(player.position.y, TILE_SUBPIXELS * CHUNK_SIZE);
    const unsent: ChunkCoord[] = [];
    for (let dy = -CHUNK_VIEW_RADIUS; dy <= CHUNK_VIEW_RADIUS; dy++) {
      for (let dx = -CHUNK_VIEW_RADIUS; dx <= CHUNK_VIEW_RADIUS; dx++) {
        const cx = centerX + dx;
        const cy = centerY + dy;
        const key = chunkKey(cx, cy);
        if (!player.sentChunks.has(key)) {
          player.sentChunks.add(key);
          unsent.push({ cx, cy });
        }
      }
    }
    return unsent;
  }

  #progressOf(id: string): PlayerProgress {
    let progress = this.#progress.get(id);
    if (progress === undefined) {
      const inventory = new Inventory(itemDef);
      inventory.equipped = STARTER_TOOL;
      progress = { skills: new PlayerSkills(), inventory };
      this.#progress.set(id, progress);
    }
    return progress;
  }

  #startGather(player: PlayerState, tileX: number, tileY: number): void {
    this.#stop(player);
    const node = resourceNodeForTile(this.world.tileAt(tileX, tileY, NODE_LAYER));
    if (node === undefined) {
      player.notices.push(Notice.nothingToGather);
      return;
    }
    const playerTileX = floorDiv(player.position.x, TILE_SUBPIXELS);
    const playerTileY = floorDiv(player.position.y, TILE_SUBPIXELS);
    if (Math.abs(tileX - playerTileX) > 1 || Math.abs(tileY - playerTileY) > 1) {
      player.notices.push(Notice.outOfReach);
      return;
    }
    const failure = checkGather(node, player.skills, player.inventory);
    if (failure !== undefined) {
      player.notices.push(failure);
      return;
    }
    player.action = { kind: "gather", tileX, tileY, node, startTick: 0, durationTicks: 0 };
    this.#nextCycle(player, player.action);
  }

  #progressAction(player: PlayerState): void {
    const action = player.action;
    if (action === undefined) return;
    if (this.#tick < action.startTick + action.durationTicks) return;

    const { node, tileX, tileY } = action;
    if (this.world.tileAt(tileX, tileY, NODE_LAYER) !== node.tileId) {
      this.#stop(player, Notice.depleted);
      return;
    }
    const failure = checkGather(node, player.skills, player.inventory);
    if (failure !== undefined) {
      this.#stop(player, failure);
      return;
    }

    player.inventory.add(node.product);
    player.inventoryDirty = true;
    player.skills.addXp(node.skill, node.xp);
    player.dirtySkills.add(node.skill);

    if (this.#nodes.harvest(tileX, tileY, node, this.#tick)) {
      this.#setTile(tileX, tileY, node.depletedTileId);
      this.#stop(player, Notice.depleted);
      return;
    }
    const next = checkGather(node, player.skills, player.inventory);
    if (next !== undefined) {
      this.#stop(player, next);
      return;
    }
    this.#nextCycle(player, action);
  }

  #nextCycle(player: PlayerState, action: GatherAction): void {
    const tool = player.inventory.equippedTool!.tool!;
    action.startTick = this.#tick;
    action.durationTicks = actionTicks(
      action.node.baseTicks,
      player.skills.level(action.node.skill),
      tool.speed,
    );
    player.actionDirty = true;
  }

  #stop(player: PlayerState, notice?: Notice): void {
    if (notice !== undefined) player.notices.push(notice);
    if (player.action === undefined) return;
    player.action = undefined;
    player.actionDirty = true;
  }

  #setTile(tileX: number, tileY: number, tileId: number): void {
    const change = this.world.setTile(tileX, tileY, NODE_LAYER, tileId);
    if (change !== undefined) this.#tileChanges.push(change);
  }
}
