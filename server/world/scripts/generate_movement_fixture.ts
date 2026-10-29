// Regenerates fixtures/movement_cases.json from the TypeScript simulation.
// The Dart port in packages/craftaria_sim must reproduce these exactly.
//
// Run with: pnpm --filter @craftaria/world fixtures
import { writeFileSync } from "node:fs";
import { step, type Position } from "../src/movement.ts";

const blocked: Array<[number, number]> = [
  [2, 0],
  [-2, 0],
  ...Array.from({ length: 11 }, (_, i): [number, number] => [i - 5, -2]),
  [3, 3],
];
const blockedSet = new Set(blocked.map(([x, y]) => `${x},${y}`));
const isBlocked = (x: number, y: number) => blockedSet.has(`${x},${y}`);

const repeat = (n: number, dx: number, dy: number) =>
  Array.from({ length: n }, (): [number, number] => [dx, dy]);

const cases = [
  { name: "idle", start: { x: 64, y: 64 }, inputs: repeat(3, 0, 0) },
  { name: "free right", start: { x: 64, y: 200 }, inputs: repeat(5, 1, 0) },
  { name: "into wall right", start: { x: 64, y: 64 }, inputs: repeat(6, 1, 0) },
  { name: "into wall left", start: { x: 64, y: 64 }, inputs: repeat(6, -1, 0) },
  { name: "slide along ceiling", start: { x: 64, y: 64 }, inputs: repeat(8, 1, -1) },
  { name: "stopped by tile below", start: { x: 320, y: 300 }, inputs: [...repeat(4, 1, 1), ...repeat(4, 0, 1)] },
  { name: "negative space", start: { x: -1000, y: -1000 }, inputs: repeat(5, -1, -1) },
  { name: "out of range intent", start: { x: 64, y: 64 }, inputs: [[5, -3] as [number, number]] },
];

const fixture = {
  blocked,
  cases: cases.map((c) => {
    let position: Position = c.start;
    const expected = c.inputs.map(([dx, dy]) => {
      position = step(position, { dx, dy }, isBlocked);
      return [position.x, position.y];
    });
    return { ...c, expected };
  }),
};

const out = new URL("../../../fixtures/movement_cases.json", import.meta.url);
writeFileSync(out, JSON.stringify(fixture, null, 2) + "\n");
console.log(`wrote ${out.pathname}`);
