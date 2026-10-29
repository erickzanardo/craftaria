import { create, fromBinary, type MessageInitShape, toBinary } from "@bufbuild/protobuf";
import {
  ChunkDataSchema,
  type ClientMessage,
  ClientMessageSchema,
  ErrorCode,
  PROTOCOL_VERSION,
  ServerMessageSchema,
  SnapshotSchema,
  Vec2Schema,
} from "@craftaria/protocol";
import { TICK_RATE, type World, type ZoneSimulation } from "@craftaria/world";
import { verifyToken } from "./auth.ts";

// WebSocket close codes.
export const CLOSE_UNSUPPORTED_DATA = 1003;
export const CLOSE_POLICY_VIOLATION = 1008;
export const CLOSE_REPLACED = 4000;

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
      case "move":
        if (connection.playerId === undefined) {
          this.#reject(connection, ErrorCode.UNAUTHORIZED, "say hello first");
          return;
        }
        this.sim.queueInput(connection.playerId, payload.value);
        return;
      case "ping":
        this.#send(connection, {
          case: "pong",
          value: { clientTimeMs: payload.value.clientTimeMs, serverTimeMs: BigInt(this.host.now()) },
        });
        return;
      default:
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
      this.#send(connection, {
        case: "snapshot",
        value: create(SnapshotSchema, {
          tick: this.sim.tick,
          lastInputSeq: player.lastInputSeq,
          entities: this.sim.entitiesVisibleTo(playerId).map((entity) => ({
            id: entity.id,
            position: create(Vec2Schema, entity.position),
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
      },
    });
    this.host.startTicking();
  }

  #reject(connection: Connection, code: ErrorCode, message: string) {
    this.#send(connection, { case: "error", value: { code, message } });
    connection.close(CLOSE_POLICY_VIOLATION, message);
  }

  #send(
    connection: Connection,
    payload: MessageInitShape<typeof ServerMessageSchema>["payload"],
  ) {
    connection.send(
      toBinary(ServerMessageSchema, create(ServerMessageSchema, { payload })),
    );
  }
}
