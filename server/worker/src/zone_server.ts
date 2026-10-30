import { create, fromBinary, type MessageInitShape, toBinary } from "@bufbuild/protobuf";
import {
  ActionStateSchema,
  ChunkDataSchema,
  type ClientMessage,
  ClientMessageSchema,
  type DebugCommand,
  ErrorCode,
  InventoryUpdateSchema,
  NoticeCode,
  PROTOCOL_VERSION,
  ServerMessageSchema,
  SkillUpdateSchema,
  SnapshotSchema,
  TileUpdateSchema,
  Vec2Schema,
} from "@craftaria/protocol";
import {
  ALL_SKILLS,
  isSkillId,
  ITEMS,
  PALETTE,
  SKIN_COLORS,
  Notice,
  type PlayerState,
  progressFor,
  type SkillId,
  TICK_RATE,
  type TileChange,
  type World,
  type ZoneSimulation,
} from "@craftaria/world";
import { verifyToken } from "./auth.ts";

// WebSocket close codes.
export const CLOSE_UNSUPPORTED_DATA = 1003;
export const CLOSE_POLICY_VIOLATION = 1008;
export const CLOSE_REPLACED = 4000;

const NOTICE_CODES: Record<Notice, NoticeCode> = {
  [Notice.nothingToGather]: NoticeCode.NOTHING_TO_GATHER,
  [Notice.outOfReach]: NoticeCode.OUT_OF_REACH,
  [Notice.noTool]: NoticeCode.NO_TOOL,
  [Notice.toolTooWeak]: NoticeCode.TOOL_TOO_WEAK,
  [Notice.levelTooLow]: NoticeCode.LEVEL_TOO_LOW,
  [Notice.inventoryFull]: NoticeCode.INVENTORY_FULL,
  [Notice.depleted]: NoticeCode.DEPLETED,
};

/** Most of one item a debug command can grant at once. */
export const MAX_DEBUG_GRANT = 1000;

export interface ZoneServerOptions {
  /** Accept DebugCommand messages. Development only. */
  readonly debugCommands?: boolean;
}

type ServerPayload = MessageInitShape<typeof ServerMessageSchema>["payload"];

/** One client socket, as seen by the zone. */
export interface Connection {
  /** Set once the client has authenticated with a Hello. */
  playerId: string | undefined;
  send(data: Uint8Array): void;
  close(code: number, reason: string): void;
}

/** What the zone needs from whatever hosts it (a Durable Object in prod). */
export interface ZoneHost {
  connections(): Iterable<Connection>;
  startTicking(): void;
  stopTicking(): void;
  now(): number;
}

/** Protocol handling for a zone, independent of the Workers runtime. */
export class ZoneServer {
  constructor(
    private readonly host: ZoneHost,
    private readonly sim: ZoneSimulation,
    private readonly world: World,
    private readonly secret: string,
    private readonly options: ZoneServerOptions = {},
  ) {}

  /** Re-registers players whose sockets survived a hibernation. */
  restore(): void {
    for (const connection of this.host.connections()) {
      if (connection.playerId !== undefined) {
        this.sim.addPlayer(connection.playerId);
      }
    }
    if (this.sim.playerCount > 0) this.host.startTicking();
  }

  async handleMessage(
    connection: Connection,
    data: string | ArrayBuffer | Uint8Array,
  ): Promise<void> {
    if (typeof data === "string") {
      connection.close(CLOSE_UNSUPPORTED_DATA, "binary frames only");
      return;
    }

    let message: ClientMessage;
    try {
      message = fromBinary(
        ClientMessageSchema,
        data instanceof Uint8Array ? data : new Uint8Array(data),
      );
    } catch {
      connection.close(CLOSE_UNSUPPORTED_DATA, "malformed message");
      return;
    }

    const { payload } = message;
    switch (payload.case) {
      case "hello":
        await this.#hello(connection, payload.value.token, payload.value.protocolVersion);
        return;
      case "ping":
        this.#send(connection, {
          case: "pong",
          value: { clientTimeMs: payload.value.clientTimeMs, serverTimeMs: BigInt(this.host.now()) },
        });
        return;
      case undefined:
        return;
    }

    const playerId = connection.playerId;
    if (playerId === undefined) {
      this.#reject(connection, ErrorCode.UNAUTHORIZED, "say hello first");
      return;
    }
    switch (payload.case) {
      case "move":
        this.sim.queueInput(playerId, {
          kind: "move",
          seq: payload.value.seq,
          dx: payload.value.dx,
          dy: payload.value.dy,
        });
        return;
      case "gather":
        this.sim.queueInput(playerId, {
          kind: "gather",
          seq: payload.value.seq,
          tileX: payload.value.tileX,
          tileY: payload.value.tileY,
        });
        return;
      case "cancelAction":
        this.sim.cancelAction(playerId);
        return;
      case "equip":
        this.sim.equip(playerId, payload.value.slot);
        return;
      case "setAppearance":
        if (payload.value.appearance !== undefined) {
          this.sim.setAppearance(playerId, payload.value.appearance);
        }
        return;
      case "debug":
        if (this.options.debugCommands === true) {
          this.#debug(playerId, payload.value);
        }
        return;
    }
  }

  handleClose(connection: Connection): void {
    if (connection.playerId === undefined) return;
    this.sim.removePlayer(connection.playerId);
    if (this.sim.playerCount === 0) this.host.stopTicking();
  }

  tick(): void {
    this.sim.step();
    const tileChanges = this.sim.takeTileChanges();
    for (const connection of this.host.connections()) {
      const playerId = connection.playerId;
      if (playerId === undefined) continue;
      const player = this.sim.player(playerId);
      if (player === undefined) continue;

      for (const { cx, cy } of this.sim.takeUnsentChunks(playerId)) {
        this.#send(connection, {
          case: "chunk",
          value: create(ChunkDataSchema, { chunk: this.world.chunk(cx, cy) }),
        });
      }
      for (const change of tileChanges) {
        if (this.sim.hasChunk(playerId, change.cx, change.cy)) {
          this.#send(connection, { case: "tile", value: tileUpdate(change) });
        }
      }
      this.#sendPlayerUpdates(connection, player);
      this.#send(connection, {
        case: "snapshot",
        value: create(SnapshotSchema, {
          tick: this.sim.tick,
          lastInputSeq: player.lastInputSeq,
          entities: this.sim.entitiesVisibleTo(playerId).map((entity) => ({
            id: entity.id,
            position: create(Vec2Schema, entity.position),
            appearance: entity.appearance,
          })),
        }),
      });
    }
  }

  async #hello(connection: Connection, token: string, version: number) {
    if (connection.playerId !== undefined) return;
    if (version !== PROTOCOL_VERSION) {
      this.#reject(connection, ErrorCode.PROTOCOL_MISMATCH, `server speaks v${PROTOCOL_VERSION}`);
      return;
    }
    const claims = await verifyToken(this.secret, token);
    if (claims === null) {
      this.#reject(connection, ErrorCode.UNAUTHORIZED, "invalid token");
      return;
    }

    // One session per player: a new login replaces the old one.
    for (const other of this.host.connections()) {
      if (other !== connection && other.playerId === claims.sub) {
        this.#send(other, {
          case: "error",
          value: { code: ErrorCode.REPLACED, message: "logged in elsewhere" },
        });
        other.playerId = undefined;
        other.close(CLOSE_REPLACED, "replaced");
        this.sim.removePlayer(claims.sub);
      }
    }

    connection.playerId = claims.sub;
    const player = this.sim.addPlayer(claims.sub);
    this.#send(connection, {
      case: "welcome",
      value: {
        playerId: claims.sub,
        tickRate: TICK_RATE,
        spawn: create(Vec2Schema, player.position),
        items: ITEMS.map(({ id, name, maxStack }) => ({ id, name, maxStack })),
        palette: [...PALETTE],
        skinColors: [...SKIN_COLORS],
        appearance: this.sim.appearance(claims.sub),
      },
    });
    this.#send(connection, { case: "inventory", value: inventoryUpdate(player) });
    for (const skill of ALL_SKILLS) {
      this.#send(connection, { case: "skill", value: skillUpdate(player, skill) });
    }
    this.sim.takePlayerUpdates(player.id);
    this.host.startTicking();
  }

  #sendPlayerUpdates(connection: Connection, player: PlayerState) {
    const updates = this.sim.takePlayerUpdates(player.id)!;
    if (updates.inventory) {
      this.#send(connection, { case: "inventory", value: inventoryUpdate(player) });
    }
    for (const skill of updates.skills) {
      this.#send(connection, { case: "skill", value: skillUpdate(player, skill) });
    }
    if (updates.action) {
      this.#send(connection, { case: "action", value: actionState(player) });
    }
    for (const notice of updates.notices) {
      this.#send(connection, { case: "notice", value: { code: NOTICE_CODES[notice] } });
    }
  }

  #debug(playerId: string, command: DebugCommand) {
    const { command: payload } = command;
    switch (payload.case) {
      case "grantItem":
        this.sim.grantItem(
          playerId,
          payload.value.itemId,
          Math.min(payload.value.count, MAX_DEBUG_GRANT),
        );
        return;
      case "grantXp":
        if (isSkillId(payload.value.skillId)) {
          this.sim.grantXp(playerId, payload.value.skillId, payload.value.amount);
        }
        return;
      case undefined:
        return;
    }
  }

  #reject(connection: Connection, code: ErrorCode, message: string) {
    this.#send(connection, { case: "error", value: { code, message } });
    connection.close(CLOSE_POLICY_VIOLATION, message);
  }

  #send(connection: Connection, payload: ServerPayload) {
    connection.send(
      toBinary(ServerMessageSchema, create(ServerMessageSchema, { payload })),
    );
  }
}

function inventoryUpdate(player: PlayerState) {
  const { inventory } = player;
  return create(InventoryUpdateSchema, {
    slots: inventory.slots.map((stack) => ({
      itemId: stack?.itemId ?? "",
      count: stack?.count ?? 0,
    })),
    equipped: inventory.equipped ?? "",
  });
}

function skillUpdate(player: PlayerState, skill: SkillId) {
  const progress = progressFor(player.skills.xp(skill));
  return create(SkillUpdateSchema, {
    skillId: skill,
    level: progress.level,
    xp: BigInt(progress.xp),
    levelXp: BigInt(progress.levelXp),
    nextLevelXp: BigInt(progress.nextLevelXp),
  });
}

function actionState(player: PlayerState) {
  const action = player.action;
  if (action === undefined) return create(ActionStateSchema);
  return create(ActionStateSchema, {
    kind: action.kind,
    tileX: action.tileX,
    tileY: action.tileY,
    startTick: action.startTick,
    durationTicks: action.durationTicks,
  });
}

function tileUpdate(change: TileChange) {
  return create(TileUpdateSchema, { ...change });
}
