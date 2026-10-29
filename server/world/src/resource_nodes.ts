import { chunkKey } from "./chunk.ts";
import type { ResourceNodeDef } from "./skills/gathering.ts";

export interface Regrowth {
  readonly tileX: number;
  readonly tileY: number;
  readonly node: ResourceNodeDef;
}

interface ScheduledRegrowth extends Regrowth {
  readonly atTick: number;
}

/**
 * Yields left in each node of a zone and when depleted nodes regrow. A node
 * rolls its yield count on its first harvest. In memory only.
 */
export class ResourceNodes {
  readonly #remaining = new Map<string, number>();
  #regrowths: ScheduledRegrowth[] = [];

  /** [random] returns numbers in [0, 1), like Math.random. */
  constructor(private readonly random: () => number = Math.random) {}

  /**
   * Takes one yield from the node at a tile. Returns true when that was the
   * last one, scheduling its regrowth.
   */
  harvest(
    tileX: number,
    tileY: number,
    node: ResourceNodeDef,
    tick: number,
  ): boolean {
    const key = chunkKey(tileX, tileY);
    const remaining = (this.#remaining.get(key) ?? this.#roll(node)) - 1;
    if (remaining > 0) {
      this.#remaining.set(key, remaining);
      return false;
    }
    this.#remaining.delete(key);
    this.#regrowths.push({ tileX, tileY, node, atTick: tick + node.regrowTicks });
    return true;
  }

  /** Removes and returns the regrowths due at or before [tick]. */
  takeDue(tick: number): Regrowth[] {
    const due = this.#regrowths.filter((r) => r.atTick <= tick);
    this.#regrowths = this.#regrowths.filter((r) => r.atTick > tick);
    return due.map(({ tileX, tileY, node }) => ({ tileX, tileY, node }));
  }

  #roll(node: ResourceNodeDef): number {
    const span = node.maxYield - node.minYield + 1;
    return node.minYield + Math.floor(this.random() * span);
  }
}
