import { create, fromBinary, type MessageInitShape, toBinary } from "@bufbuild/protobuf";
import {
  ClientMessageSchema,
  ErrorCode,
  PROTOCOL_VERSION,
  type ServerMessage,
  ServerMessageSchema,
} from "@craftaria/protocol";
import { CHUNK_VIEW_RADIUS, PLAYER_SPEED, SPAWN, TICK_RATE, World, ZoneSimulation } from "@craftaria/world";
import { beforeEach, describe, expect, it } from "vitest";
import { issueGuestToken, MIN_SECRET_LENGTH } from "../src/auth.ts";
import {
  CLOSE_POLICY_VIOLATION,
  CLOSE_REPLACED,
  CLOSE_UNSUPPORTED_DATA,
  type Connection,
  type ZoneHost,
  ZoneServer,
} from "../src/zone_server.ts";

const secret = "s".repeat(MIN_SECRET_LENGTH);

class FakeConnection implements Connection {
  playerId: string | undefined;
  readonly sent: ServerMessage[] = [];
  closed: { code: number; reason: string } | undefined;

  send(data: Uint8Array): void {
    this.sent.push(fromBinary(ServerMessageSchema, data));
  }

  close(code: number, reason: string): void {
    this.closed = { code, reason };
  }

  payloads(kind: ServerMessage["payload"]["case"]) {
    return this.sent.filter((message) => message.payload.case === kind);
  }
}

class FakeHost implements ZoneHost {
  readonly sockets: FakeConnection[] = [];
  ticking = false;

  connections() {
    return this.sockets;
  }
  startTicking() {
    this.ticking = true;
  }
  stopTicking() {
    this.ticking = false;
  }
  now() {
    return 1234;
  }

  connect() {
    const connection = new FakeConnection();
    this.sockets.push(connection);
    return connection;
  }
}

const encode = (payload: MessageInitShape<typeof ClientMessageSchema>["payload"]) =>
  toBinary(ClientMessageSchema, create(ClientMessageSchema, { payload }));

const hello = async (sub: string, protocolVersion = PROTOCOL_VERSION) => {
  const { token } = await issueGuestToken(secret, { sub, iat: 0 });
  return encode({ case: "hello", value: { token, protocolVersion } });
};

describe("ZoneServer", () => {
  let host: FakeHost;
  let sim: ZoneSimulation;
  let server: ZoneServer;

  beforeEach(() => {
    host = new FakeHost();
    const world = new World(1);
    sim = new ZoneSimulation({ isBlocked: () => false, tileAt: () => 0, setTile: () => undefined });
    server = new ZoneServer(host, sim, world, secret);
  });

  it("welcomes authenticated players and starts ticking", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice"));

    expect(connection.playerId).toBe("alice");
    expect(sim.player("alice")).toBeDefined();
    expect(host.ticking).toBe(true);
    const [welcome] = connection.payloads("welcome");
    expect(welcome?.payload.value).toMatchObject({
      playerId: "alice",
      tickRate: TICK_RATE,
      spawn: { x: SPAWN.x, y: SPAWN.y },
    });
  });

  it("accepts ArrayBuffer frames", async () => {
    const connection = host.connect();
    const bytes = await hello("alice");
    await server.handleMessage(connection, bytes.slice().buffer);
    expect(connection.playerId).toBe("alice");
  });

  it("ignores a second hello on the same socket", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice"));
    await server.handleMessage(connection, await hello("bob"));
    expect(connection.playerId).toBe("alice");
    expect(connection.payloads("welcome")).toHaveLength(1);
  });

  it("rejects invalid tokens", async () => {
    const connection = host.connect();
    await server.handleMessage(
      connection,
      encode({ case: "hello", value: { token: "forged", protocolVersion: PROTOCOL_VERSION } }),
    );
    expect(connection.payloads("error")[0]?.payload.value).toMatchObject({
      code: ErrorCode.UNAUTHORIZED,
    });
    expect(connection.closed?.code).toBe(CLOSE_POLICY_VIOLATION);
    expect(connection.playerId).toBeUndefined();
  });

  it("rejects mismatched protocol versions", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice", PROTOCOL_VERSION + 1));
    expect(connection.payloads("error")[0]?.payload.value).toMatchObject({
      code: ErrorCode.PROTOCOL_MISMATCH,
    });
    expect(connection.closed?.code).toBe(CLOSE_POLICY_VIOLATION);
  });

  it("rejects text and malformed frames", async () => {
    const text = host.connect();
    await server.handleMessage(text, "hi");
    expect(text.closed?.code).toBe(CLOSE_UNSUPPORTED_DATA);

    const garbage = host.connect();
    await server.handleMessage(garbage, new Uint8Array([0xff, 0xff, 0xff]));
    expect(garbage.closed?.code).toBe(CLOSE_UNSUPPORTED_DATA);
  });

  it("ignores empty frames", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, new Uint8Array());
    expect(connection.sent).toEqual([]);
    expect(connection.closed).toBeUndefined();
  });

  it("requires a hello before movement", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, encode({ case: "move", value: { seq: 1, dx: 1, dy: 0 } }));
    expect(connection.closed?.code).toBe(CLOSE_POLICY_VIOLATION);
  });

  it("applies movement on tick and reports it in snapshots", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice"));
    await server.handleMessage(connection, encode({ case: "move", value: { seq: 1, dx: 1, dy: 0 } }));

    server.tick();

    const snapshot = connection.payloads("snapshot").at(-1)?.payload.value;
    expect(snapshot).toMatchObject({
      tick: 1,
      lastInputSeq: 1,
      entities: [{ id: "alice", position: { x: SPAWN.x + PLAYER_SPEED, y: SPAWN.y } }],
    });
  });

  it("streams surrounding chunks once", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice"));

    server.tick();
    server.tick();

    expect(connection.payloads("chunk")).toHaveLength((CHUNK_VIEW_RADIUS * 2 + 1) ** 2);
  });

  it("only sends ticks to authenticated players that are simulated", async () => {
    const anonymous = host.connect();
    const stale = host.connect();
    stale.playerId = "gone";

    server.tick();

    expect(anonymous.sent).toEqual([]);
    expect(stale.sent).toEqual([]);
  });

  it("answers pings", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, encode({ case: "ping", value: { clientTimeMs: 5n } }));
    expect(connection.payloads("pong")[0]?.payload.value).toMatchObject({
      clientTimeMs: 5n,
      serverTimeMs: 1234n,
    });
  });

  it("replaces an older session for the same player", async () => {
    const first = host.connect();
    const bystander = host.connect();
    await server.handleMessage(first, await hello("alice"));
    await server.handleMessage(bystander, await hello("bob"));
    const second = host.connect();
    await server.handleMessage(second, await hello("alice"));

    expect(first.closed?.code).toBe(CLOSE_REPLACED);
    expect(first.playerId).toBeUndefined();
    expect(first.payloads("error")[0]?.payload.value).toMatchObject({ code: ErrorCode.REPLACED });
    expect(bystander.closed).toBeUndefined();
    expect(second.playerId).toBe("alice");
    expect(sim.playerCount).toBe(2);
  });

  it("removes players on close and stops ticking when empty", async () => {
    const alice = host.connect();
    const bob = host.connect();
    await server.handleMessage(alice, await hello("alice"));
    await server.handleMessage(bob, await hello("bob"));

    server.handleClose(alice);
    expect(sim.player("alice")).toBeUndefined();
    expect(host.ticking).toBe(true);

    server.handleClose(bob);
    expect(host.ticking).toBe(false);

    server.handleClose(host.connect());
    expect(host.ticking).toBe(false);
  });

  it("restores players from surviving connections", () => {
    host.connect().playerId = "alice";
    host.connect();

    server.restore();

    expect(sim.player("alice")).toBeDefined();
    expect(sim.playerCount).toBe(1);
    expect(host.ticking).toBe(true);
  });

  it("does not tick after restoring an empty zone", () => {
    server.restore();
    expect(host.ticking).toBe(false);
  });
});
