import 'package:craftaria_map/src/chunk_coord.dart';
import 'package:craftaria_map/src/constants.dart';
import 'package:craftaria_map/src/map_chunk.dart';
import 'package:craftaria_map/src/tile_id.dart';

/// The set of chunks currently known, indexed by coordinate.
class ChunkMap {
  final _chunks = <ChunkCoord, MapChunk>{};

  /// Every loaded chunk.
  Iterable<MapChunk> get chunks => _chunks.values;

  /// Adds or replaces a chunk.
  void put(MapChunk chunk) => _chunks[chunk.coord] = chunk;

  /// The chunk at [coord], if loaded.
  MapChunk? operator [](ChunkCoord coord) => _chunks[coord];

  /// Applies a single tile change to a loaded chunk, returning the updated
  /// chunk, or null when [coord] is not loaded.
  MapChunk? setTile(
    ChunkCoord coord, {
    required String layer,
    required int index,
    required int tileId,
    required bool blocked,
  }) {
    final chunk = _chunks[coord];
    if (chunk == null) return null;
    final updated = chunk.withTile(
      layer: layer,
      index: index,
      tileId: tileId,
      blocked: blocked,
    );
    _chunks[coord] = updated;
    return updated;
  }

  /// Tile id of the world tile in the layer named [layer], or
  /// [TileId.empty] when the chunk or layer is not loaded.
  int tileAt(int tileX, int tileY, {required String layer}) {
    final coord = ChunkCoord.ofTile(tileX, tileY);
    final chunk = _chunks[coord];
    if (chunk == null) return TileId.empty;
    for (final candidate in chunk.layers) {
      if (candidate.name != layer) continue;
      return candidate.tileAt(
        tileX - coord.cx * chunkSize,
        tileY - coord.cy * chunkSize,
      );
    }
    return TileId.empty;
  }

  /// Whether the world tile blocks movement. Unloaded tiles do not block:
  /// the server is authoritative and corrects any misprediction.
  bool isBlocked(int tileX, int tileY) {
    final coord = ChunkCoord.ofTile(tileX, tileY);
    final chunk = _chunks[coord];
    if (chunk == null) return false;
    return chunk.isBlocked(
      tileX - coord.cx * chunkSize,
      tileY - coord.cy * chunkSize,
    );
  }
}
