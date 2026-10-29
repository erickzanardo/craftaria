import 'dart:typed_data';

import 'package:craftaria_map/craftaria_map.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart' as pb;
import 'package:test/test.dart';

Uint8List _collisionWith(List<int> indices) {
  final bits = Uint8List(tilesPerChunk ~/ 8);
  for (final index in indices) {
    bits[index >> 3] |= 1 << (index & 7);
  }
  return bits;
}

MapChunk _chunk({ChunkCoord coord = const ChunkCoord(0, 0)}) => MapChunk(
  coord: coord,
  layers: [
    ChunkLayer(
      name: 'ground',
      tiles: List.generate(tilesPerChunk, (i) => i.isEven ? 1 : 2),
    ),
    ChunkLayer(
      name: 'overlay',
      tiles: List.filled(tilesPerChunk, 0),
      aboveEntities: true,
    ),
  ],
  collision: _collisionWith([1, chunkSize + 2]),
  entities: const [
    ChunkEntity(
      id: 'chest-1',
      kind: 'chest',
      x: 12,
      y: 40,
      properties: {'loot': 'gold'},
    ),
  ],
  tileStates: const [
    ChunkTileState(index: 3, layer: 'ground', properties: {'growth': '2'}),
  ],
);

void main() {
  group('floorDiv', () {
    test('matches floor division for every sign combination', () {
      expect(floorDiv(7, 2), equals(3));
      expect(floorDiv(-7, 2), equals(-4));
      expect(floorDiv(7, -2), equals(-4));
      expect(floorDiv(-8, 2), equals(-4));
      expect(floorDiv(0, 32), equals(0));
    });
  });

  group('TileId', () {
    test('isSolid', () {
      expect(TileId.isSolid(TileId.grass), isFalse);
      expect(TileId.isSolid(TileId.sand), isFalse);
      expect(TileId.isSolid(TileId.empty), isFalse);
      expect(TileId.isSolid(TileId.water), isTrue);
      expect(TileId.isSolid(TileId.stone), isTrue);
      expect(TileId.isSolid(TileId.tree), isTrue);
    });
  });

  group('ChunkCoord', () {
    test('ofTile floors negative coordinates', () {
      expect(ChunkCoord.ofTile(0, 31), equals(const ChunkCoord(0, 0)));
      expect(ChunkCoord.ofTile(-1, 32), equals(const ChunkCoord(-1, 1)));
    });
  });

  group('MapChunk', () {
    test('reads tiles and collision', () {
      final chunk = _chunk();
      expect(chunk.layers.first.tileAt(1, 0), equals(2));
      expect(chunk.isBlocked(0, 0), isFalse);
      expect(chunk.isBlocked(1, 0), isTrue);
      expect(chunk.isBlocked(2, 1), isTrue);
    });

    test('treats a short collision bitset as walkable', () {
      final chunk = MapChunk(
        coord: const ChunkCoord(0, 0),
        layers: const [],
        collision: Uint8List(0),
      );
      expect(chunk.isBlocked(5, 5), isFalse);
    });

    test('round trips through the binary format', () {
      final chunk = _chunk(coord: const ChunkCoord(-3, 7));
      expect(MapChunk.decode(chunk.encode()), equals(chunk));
    });

    test('converts from protobuf', () {
      final proto = pb.Chunk(cx: 1, cy: 2, collision: _collisionWith([0]));
      final chunk = MapChunk.fromProto(proto);
      expect(chunk.coord, equals(const ChunkCoord(1, 2)));
      expect(chunk.isBlocked(0, 0), isTrue);
      expect(chunk.toProto(), equals(proto));
    });
  });

  group('ChunkMap', () {
    test('answers collision in world tiles across chunks', () {
      final map = ChunkMap()
        ..put(_chunk())
        ..put(_chunk(coord: const ChunkCoord(-1, 0)));

      expect(map.chunks, hasLength(2));
      expect(map[const ChunkCoord(-1, 0)], isNotNull);
      expect(map.isBlocked(1, 0), isTrue);
      expect(map.isBlocked(-chunkSize + 1, 0), isTrue);
      expect(map.isBlocked(0, 0), isFalse);
      expect(map.isBlocked(0, chunkSize), isFalse);
    });
  });
}
