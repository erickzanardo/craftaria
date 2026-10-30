import { describe, expect, it } from "vitest";
import {
  CHUNK_VIEW_RADIUS,
  MAX_INPUT_BUDGET,
  MAX_QUEUED_INPUTS,
  PLAYER_SPEED,
  SPAWN,
  ZoneSimulation,
} from "../src/index.ts";

const chunksInView = (2 * CHUNK_VIEW_RADIUS + 1) ** 2;
const openWorld = () => ({
  isBlocked: () => false,
  tileAt: () => 0,
  setTile: () => undefined,
});

describe("ZoneSimulation", () => {
  it("adds and removes players", () => {
    const sim = new ZoneSimulation(openWorld());
    const player = sim.addPlayer("a");
    expect(player.position).toEqual(SPAWN);
    expect(sim.player("a")).toBe(player);
    expect(sim.playerCount).toBe(1);

    sim.removePlayer("a");
    expect(sim.player("a")).toBeUndefined();
    expect(sim.playerCount).toBe(0);
  });

  it("keeps valid appearances across reconnects and shows them to everyone", () => {
    const sim = new ZoneSimulation(openWorld());
    sim.addPlayer("a");
    sim.addPlayer("b");
    expect(sim.appearance("a")).toBeUndefined();
    expect(sim.entitiesVisibleTo("b")[0]?.appearance).toBeUndefined();

    sim.setAppearance("a", { skin: 12, shirt: 0, pants: 1 });
    sim.setAppearance("a", { skin: 0, shirt: 0, pants: 1 });
    sim.setAppearance("ghost", { skin: 12, shirt: 0, pants: 1 });
    expect(sim.appearance("ghost")).toBeUndefined();
    expect(sim.entitiesVisibleTo("b")[0]?.appearance).toEqual({ skin: 12, shirt: 0, pants: 1 });

    sim.removePlayer("a");
    sim.addPlayer("a");
    expect(sim.appearance("a")).toEqual({ skin: 12, shirt: 0, pants: 1 });
  });

  it("applies one queued input per tick and tracks the last seq", () => {
    const sim = new ZoneSimulation(openWorld());
    sim.addPlayer("a", { x: 0, y: 0 });
    sim.queueInput("a", { kind: "move", seq: 1, dx: 1, dy: 0 });

    sim.step();

    expect(sim.tick).toBe(1);
    expect(sim.player("a")!.position).toEqual({ x: PLAYER_SPEED, y: 0 });
    expect(sim.player("a")!.lastInputSeq).toBe(1);
  });

  it("ignores stale inputs, excess inputs and unknown players", () => {
    const sim = new ZoneSimulation(openWorld());
    sim.addPlayer("a", { x: 0, y: 0 });
    sim.queueInput("ghost", { kind: "move", seq: 1, dx: 1, dy: 0 });
    sim.queueInput("a", { kind: "move", seq: 2, dx: 1, dy: 0 });
    sim.queueInput("a", { kind: "move", seq: 2, dx: 1, dy: 0 });
    sim.queueInput("a", { kind: "move", seq: 1, dx: 1, dy: 0 });
    for (let seq = 3; seq < 3 + MAX_QUEUED_INPUTS * 2; seq++) {
      sim.queueInput("a", { kind: "move", seq, dx: 1, dy: 0 });
    }
    expect(sim.player("a")!.pendingInputs).toHaveLength(MAX_QUEUED_INPUTS);
  });

  it("limits inputs to the budget so flooding does not speed players up", () => {
    const sim = new ZoneSimulation(openWorld());
    sim.addPlayer("a", { x: 0, y: 0 });
    for (let seq = 1; seq <= MAX_QUEUED_INPUTS; seq++) {
      sim.queueInput("a", { kind: "move", seq, dx: 1, dy: 0 });
    }

    sim.step();
    expect(sim.player("a")!.position.x).toBe(PLAYER_SPEED * MAX_INPUT_BUDGET);

    sim.step();
    expect(sim.player("a")!.position.x).toBe(
      PLAYER_SPEED * (MAX_INPUT_BUDGET + 1),
    );
  });

  it("lists every player as visible", () => {
    const sim = new ZoneSimulation(openWorld());
    sim.addPlayer("a", { x: 1, y: 2 });
    sim.addPlayer("b", { x: 3, y: 4 });
    expect(sim.entitiesVisibleTo("a")).toEqual([
      { id: "a", position: { x: 1, y: 2 } },
      { id: "b", position: { x: 3, y: 4 } },
    ]);
  });

  it("streams each chunk around a player once", () => {
    const sim = new ZoneSimulation(openWorld());
    expect(sim.takeUnsentChunks("ghost")).toEqual([]);

    sim.addPlayer("a", { x: 0, y: 0 });
    const first = sim.takeUnsentChunks("a");
    expect(first).toHaveLength(chunksInView);
    expect(first).toContainEqual({ cx: -CHUNK_VIEW_RADIUS, cy: -CHUNK_VIEW_RADIUS });
    expect(sim.takeUnsentChunks("a")).toEqual([]);

    sim.player("a")!.position = { x: 32 * 128, y: 0 };
    expect(sim.takeUnsentChunks("a")).toHaveLength(2 * CHUNK_VIEW_RADIUS + 1);
  });
});
