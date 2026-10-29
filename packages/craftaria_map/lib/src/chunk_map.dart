import 'package:craftaria_map/src/chunk_coord.dart';
import 'package:craftaria_map/src/constants.dart';
import 'package:craftaria_map/src/map_chunk.dart';

/// The set of chunks currently known, indexed by coordinate.
class ChunkMap {
  final _chunks = <ChunkCoord, MapChunk>{};

  /// Every loaded chunk.
  Iterable<MapChunk> get chunks => _chunks.values;

  /// Adds or replaces a chunk.
  void put(MapChunk chunk) => _chunks[chunk.coord] = chunk;

  /// The chunk at [coord], if loaded.
  MapChunk? operator [](ChunkCoord coord) => _chunks[coord];

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
