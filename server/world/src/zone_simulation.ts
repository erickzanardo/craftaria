import { chunkKey, type ChunkCoord } from "./chunk.ts";
import { CHUNK_SIZE, TILE_SUBPIXELS } from "./constants.ts";
import { type BlockedFn, floorDiv, type Position, step } from "./movement.ts";

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

export interface PlayerInput {
  readonly seq: number;
  readonly dx: number;
  readonly dy: number;
}

export interface PlayerState {
  readonly id: string;
  position: Position;
  lastInputSeq: number;
  readonly pendingInputs: PlayerInput[];
  inputBudget: number;
  readonly sentChunks: Set<string>;
}

/** The part of a world the simulation needs. */
export interface CollisionMap {
  readonly isBlocked: BlockedFn;
}

export interface EntityView {
  readonly id: string;
  readonly position: Position;
}

/** Authoritative simulation of one zone, independent of any transport. */
export class ZoneSimulation {
  readonly #players = new Map<string, PlayerState>();
  #tick = 0;

  constructor(readonly world: CollisionMap) {}

  get tick(): number {
    return this.#tick;
  }

  get playerCount(): number {
    return this.#players.size;
  }

  player(id: string): PlayerState | undefined {
    return this.#players.get(id);
  }

  addPlayer(id: string, position: Position = SPAWN): PlayerState {
    const player: PlayerState = {
      id,
      position,
      lastInputSeq: 0,
      pendingInputs: [],
      inputBudget: MAX_INPUT_BUDGET,
      sentChunks: new Set(),
    };
    this.#players.set(id, player);
    return player;
  }

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

  /** Advances the zone by one tick. */
  step(): void {
    for (const player of this.#players.values()) {
      player.inputBudget = Math.min(player.inputBudget + 1, MAX_INPUT_BUDGET);
      while (player.inputBudget > 0 && player.pendingInputs.length > 0) {
        const input = player.pendingInputs.shift()!;
        player.position = step(player.position, input, this.world.isBlocked);
        player.lastInputSeq = input.seq;
        player.inputBudget--;
      }
    }
    this.#tick++;
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
}
