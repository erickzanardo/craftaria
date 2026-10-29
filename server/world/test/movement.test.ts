import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";
import { floorDiv, type Position, step } from "../src/index.ts";

interface Fixture {
  blocked: Array<[number, number]>;
  cases: Array<{
    name: string;
    start: Position;
    inputs: Array<[number, number]>;
    expected: Array<[number, number]>;
  }>;
}

const fixture: Fixture = JSON.parse(
  readFileSync(
    new URL("../../../fixtures/movement_cases.json", import.meta.url),
    "utf8",
  ),
);
const blocked = new Set(fixture.blocked.map(([x, y]) => `${x},${y}`));
const isBlocked = (x: number, y: number) => blocked.has(`${x},${y}`);

describe("floorDiv", () => {
  it("rounds towards negative infinity", () => {
    expect(floorDiv(7, 2)).toBe(3);
    expect(floorDiv(-7, 2)).toBe(-4);
  });
});

describe("step", () => {
  for (const testCase of fixture.cases) {
    it(`matches fixture: ${testCase.name}`, () => {
      let position = testCase.start;
      const actual = testCase.inputs.map(([dx, dy]) => {
        position = step(position, { dx, dy }, isBlocked);
        return [position.x, position.y];
      });
      expect(actual).toEqual(testCase.expected);
    });
  }
});
