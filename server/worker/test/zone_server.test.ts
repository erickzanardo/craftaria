import { create, fromBinary, type MessageInitShape, toBinary } from "@bufbuild/protobuf";
import {
  ClientMessageSchema,
  ErrorCode,
  NoticeCode,
  PROTOCOL_VERSION,
  type ServerMessage,
  ServerMessageSchema,
} from "@craftaria/protocol";
import {
  CHUNK_VIEW_RADIUS,
  ITEMS,
  PALETTE,
  PLAYER_SPEED,
  SKIN_COLORS,
  SPAWN,
  TICK_RATE,
  TileId,
  World,
  xpForLevel,
  ZoneSimulation,
} from "@craftaria/world";
import { beforeEach, describe, expect, it } from "vitest";
import { issueGuestToken, MIN_SECRET_LENGTH } from "../src/auth.ts";
import {
  MAX_DEBUG_GRANT,
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
      palette: PALETTE,
      skinColors: SKIN_COLORS,
    });
    expect(welcome?.payload.value).not.toHaveProperty("appearance.skin");
  });

  it("creates characters, shows them in snapshots and remembers them", async () => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello("alice"));
    await server.handleMessage(connection, encode({ case: "setAppearance", value: {} }));
    server.tick();
    expect(connection.payloads("snapshot").at(-1)?.payload.value).not.toHaveProperty(
      "entities.0.appearance.skin",
    );

    const appearance = { skin: 12, shirt: 0, pants: 1 };
    await server.handleMessage(
      connection,
      encode({ case: "setAppearance", value: { appearance } }),
    );
    server.tick();
    expect(connection.payloads("snapshot").at(-1)?.payload.value).toMatchObject({
      entities: [{ id: "alice", appearance }],
    });

    server.handleClose(connection);
    const again = host.connect();
    await server.handleMessage(again, await hello("alice"));
    expect(again.payloads("welcome")[0]?.payload.value).toMatchObject({ appearance });
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

describe("ZoneServer woodcutting", () => {
  let host: FakeHost;
  let world: World;
  let sim: ZoneSimulation;

  // A pine right of the spawn tile, in a world with nothing else around.
  const pineX = 1;
  const pineY = 0;

  const join = async (server: ZoneServer, sub = "alice") => {
    const connection = host.connect();
    await server.handleMessage(connection, await hello(sub));
    return connection;
  };

  beforeEach(() => {
    host = new FakeHost();
    world = new World(1);
    world.setTile(pineX, pineY, "decoration", TileId.pine);
    sim = new ZoneSimulation(world, { random: () => 0 });
  });

  it("sends item definitions, the inventory and skills on welcome", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    const connection = await join(server);
    const welcome = connection.payloads("welcome")[0]?.payload.value;
    expect(welcome).toMatchObject({
      items: ITEMS.map(({ id, name, maxStack }) => ({ id, name, maxStack })),
    });
    expect(connection.payloads("inventory")[0]?.payload.value).toMatchObject({
      equipped: "stone_axe",
    });
    expect(connection.payloads("skill")[0]?.payload.value).toMatchObject({
      skillId: "woodcutting",
      level: 1,
      xp: 0n,
      levelXp: 0n,
      nextLevelXp: 80n,
    });

    // Nothing pending afterwards: the first tick sends no duplicates.
    server.tick();
    expect(connection.payloads("inventory")).toHaveLength(1);
    expect(connection.payloads("skill")).toHaveLength(1);
  });

  it("requires a hello before any action", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    for (const frame of [
      encode({ case: "gather", value: { seq: 1, tileX: 1, tileY: 0 } }),
      encode({ case: "cancelAction", value: {} }),
      encode({ case: "equip", value: { slot: 0 } }),
      encode({ case: "setAppearance", value: {} }),
    ]) {
      const connection = host.connect();
      await server.handleMessage(connection, frame);
      expect(connection.closed?.code).toBe(CLOSE_POLICY_VIOLATION);
    }
  });

  it("chops a tree and streams the results", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    const alice = await join(server);
    const bob = await join(server, "bob");
    server.tick();
    alice.sent.length = 0;

    await server.handleMessage(alice, encode({ case: "gather", value: { seq: 1, tileX: pineX, tileY: pineY } }));
    server.tick();
    expect(alice.payloads("action").at(-1)?.payload.value).toMatchObject({
      kind: "gather",
      tileX: pineX,
      tileY: pineY,
      startTick: 1,
      durationTicks: 80,
    });

    for (let i = 0; i < 80 * 3; i++) server.tick();

    expect(alice.payloads("inventory").at(-1)?.payload.value).toMatchObject({
      slots: expect.arrayContaining([expect.objectContaining({ itemId: "pine_log", count: 3 })]),
    });
    expect(alice.payloads("skill").at(-1)?.payload.value).toMatchObject({ xp: 75n });
    expect(alice.payloads("action").at(-1)?.payload.value).toMatchObject({ kind: "" });
    expect(alice.payloads("notice").at(-1)?.payload.value).toMatchObject({
      code: NoticeCode.DEPLETED,
    });
    for (const connection of [alice, bob]) {
      expect(connection.payloads("tile")[0]?.payload.value).toMatchObject({
        cx: 0,
        cy: 0,
        layer: "decoration",
        index: pineX,
        tileId: TileId.pineStump,
        blocked: true,
      });
    }
  });

  it("does not send tile updates for chunks a player never loaded", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    const alice = await join(server);
    server.tick();
    world.setTile(500, 500, "decoration", TileId.pine);
    sim.addPlayer("far", { x: 500 * 128, y: 499 * 128 });
    sim.queueInput("far", { kind: "gather", seq: 1, tileX: 500, tileY: 500 });
    for (let i = 0; i < 1 + 80 * 3; i++) server.tick();
    expect(alice.payloads("tile")).toEqual([]);
  });

  it("cancels actions and equips tools", async () => {
    const server = new ZoneServer(host, sim, world, secret, { debugCommands: true });
    const alice = await join(server);
    await server.handleMessage(alice, encode({ case: "gather", value: { seq: 1, tileX: pineX, tileY: pineY } }));
    server.tick();
    await server.handleMessage(alice, encode({ case: "cancelAction", value: {} }));
    expect(sim.player("alice")!.action).toBeUndefined();

    await server.handleMessage(alice, encode({ case: "debug", value: { command: { case: "grantItem", value: { itemId: "bronze_axe", count: 1 } } } }));
    await server.handleMessage(alice, encode({ case: "equip", value: { slot: 0 } }));
    server.tick();
    expect(alice.payloads("notice").at(-1)?.payload.value).toMatchObject({
      code: NoticeCode.LEVEL_TOO_LOW,
    });

    await server.handleMessage(alice, encode({ case: "debug", value: { command: { case: "grantXp", value: { skillId: "woodcutting", amount: xpForLevel(20) } } } }));
    await server.handleMessage(alice, encode({ case: "equip", value: { slot: 0 } }));
    server.tick();
    expect(alice.payloads("inventory").at(-1)?.payload.value).toMatchObject({
      equipped: "bronze_axe",
      slots: expect.arrayContaining([expect.objectContaining({ itemId: "stone_axe" })]),
    });
    expect(alice.payloads("skill").at(-1)?.payload.value).toMatchObject({ level: 20 });
  });

  it("caps debug grants and ignores unknown skills and empty commands", async () => {
    const server = new ZoneServer(host, sim, world, secret, { debugCommands: true });
    const alice = await join(server);
    await server.handleMessage(alice, encode({ case: "debug", value: { command: { case: "grantItem", value: { itemId: "pine_log", count: 1e6 } } } }));
    await server.handleMessage(alice, encode({ case: "debug", value: { command: { case: "grantXp", value: { skillId: "juggling", amount: 5 } } } }));
    await server.handleMessage(alice, encode({ case: "debug", value: {} }));
    const logs = sim.player("alice")!.inventory.slots.reduce(
      (total, stack) => total + (stack?.itemId === "pine_log" ? stack.count : 0),
      0,
    );
    expect(logs).toBe(MAX_DEBUG_GRANT);
    expect(sim.player("alice")!.skills.xp("woodcutting")).toBe(0);
  });

  it("sends an empty equipped id when no tool is equipped", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    const alice = await join(server);
    sim.player("alice")!.inventory.equipped = undefined;
    sim.grantItem("alice", "pine_log", 1);
    server.tick();
    expect(alice.payloads("inventory").at(-1)?.payload.value).toMatchObject({ equipped: "" });
  });

  it("ignores debug commands unless enabled", async () => {
    const server = new ZoneServer(host, sim, world, secret);
    const alice = await join(server);
    await server.handleMessage(alice, encode({ case: "debug", value: { command: { case: "grantXp", value: { skillId: "woodcutting", amount: 500 } } } }));
    expect(sim.player("alice")!.skills.xp("woodcutting")).toBe(0);
    expect(alice.closed).toBeUndefined();
  });
});
