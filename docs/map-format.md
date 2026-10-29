# Map format

One format for every source of map data: the procedural generator, the map
editor (planned) and stored player edits. The encoding is the protobuf
message `craftaria.v1.Chunk` in [`proto/craftaria/v1/map.proto`](../proto/craftaria/v1/map.proto).

## Units

| Constant | Value | Notes |
| --- | --- | --- |
| Tile size | 8 px | |
| Chunk size | 32 × 32 tiles | 256 × 256 px |
| Sub-pixels per pixel | 16 | simulation and wire positions |

World tile `(tx, ty)` lives in chunk `(floor(tx / 32), floor(ty / 32))`.
Always use floor division: chunk `-1` holds tiles `-32..-1`.

## Chunk

| Field | Meaning |
| --- | --- |
| `cx`, `cy` | chunk coordinates |
| `layers` | tile layers, bottom to top |
| `collision` | 128-byte bitset, row-major, bit `i` of byte `i / 8`, LSB first; `1` blocks |
| `entities` | objects not bound to the grid (chests, spawners, NPCs), positioned in pixels from the chunk origin |
| `tile_states` | sparse per-tile state (growth stage, durability, owner...), keyed by tile index and layer name |

### Layers

Each layer has a `name`, 1024 row-major tile ids (`0` = empty) and
`above_entities`, which draws it above players (tree canopies, roofs).
Conventional names: `ground`, `decoration`, `overlay`.

### Collision

Collision is stored rather than derived on the client, so a chunk is
self-describing and the editor can paint collision independently of tiles.
The generator derives it from solid tile ids.

## Tile ids

Tile ids are part of the format: never renumber an existing id. Defined in
`packages/craftaria_map/lib/src/tile_id.dart` and
`server/world/src/tiles.ts`, which must match.

| Id | Tile | Solid |
| --- | --- | --- |
| 0 | empty | no |
| 1 | grass | no |
| 2 | sand | no |
| 3 | water | yes |
| 4 | stone | yes |
| 16 | tree | yes |

## Sources

- **Procedural**: `server/world/src/worldgen.ts`, seeded value noise.
  Server-side only; clients receive finished chunks. Tiles within 8 tiles
  of the origin are kept as open grass so spawning is always safe (a stand-in
  for handcrafted hubs).
- **Handcrafted** (planned): the map editor will save the same `Chunk`
  messages, and zones will prefer stored chunks over generated ones.
