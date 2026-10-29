import { DurableObject } from "cloudflare:workers";
import { TICK_RATE, World, ZoneSimulation } from "@craftaria/world";
import type { Env } from "./router.ts";
import { type Connection, ZoneServer } from "./zone_server.ts";

// Thin adapter between the Workers runtime and ZoneServer. All game logic
// lives in ZoneServer so it can be tested without the runtime.

/** World seed for every zone until zones get their own configuration. */
const WORLD_SEED = 1337;

interface Attachment {
  playerId?: string;
}

class SocketConnection implements Connection {
  constructor(readonly socket: WebSocket) {}

  get playerId(): string | undefined {
    return (this.socket.deserializeAttachment() as Attachment | null)?.playerId;
  }

  set playerId(playerId: string | undefined) {
    this.socket.serializeAttachment({ playerId } satisfies Attachment);
  }

  send(data: Uint8Array): void {
    try {
      this.socket.send(data);
    } catch {
      // Socket already closing; the close handler cleans up.
    }
  }

  close(code: number, reason: string): void {
    this.socket.close(code, reason);
  }
}

export class Zone extends DurableObject<Env> {
  readonly #server: ZoneServer;
  // Stable wrappers so ZoneServer can compare connections by identity.
  readonly #connections = new WeakMap<WebSocket, SocketConnection>();
  #interval: ReturnType<typeof setInterval> | undefined;

  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);
    const world = new World(WORLD_SEED);
    this.#server = new ZoneServer(
      {
        connections: () =>
          this.ctx.getWebSockets().map((socket) => this.#connection(socket)),
        startTicking: () => {
          this.#interval ??= setInterval(() => this.#server.tick(), 1000 / TICK_RATE);
        },
        stopTicking: () => {
          clearInterval(this.#interval);
          this.#interval = undefined;
        },
        now: () => Date.now(),
      },
      new ZoneSimulation(world),
      world,
      env.AUTH_SECRET ?? "",
      { debugCommands: env.DEBUG_COMMANDS === "1" },
    );
    this.#server.restore();
  }

  #connection(socket: WebSocket): SocketConnection {
    let connection = this.#connections.get(socket);
    if (connection === undefined) {
      connection = new SocketConnection(socket);
      this.#connections.set(socket, connection);
    }
    return connection;
  }

  override async fetch(): Promise<Response> {
    const { 0: client, 1: server } = new WebSocketPair();
    this.ctx.acceptWebSocket(server);
    server.serializeAttachment({} satisfies Attachment);
    return new Response(null, { status: 101, webSocket: client });
  }

  override async webSocketMessage(socket: WebSocket, message: string | ArrayBuffer) {
    await this.#server.handleMessage(this.#connection(socket), message);
  }

  override async webSocketClose(socket: WebSocket) {
    this.#server.handleClose(this.#connection(socket));
  }

  override async webSocketError(socket: WebSocket) {
    this.#server.handleClose(this.#connection(socket));
  }
}
