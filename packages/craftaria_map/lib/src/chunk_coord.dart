import 'package:craftaria_map/src/constants.dart';
import 'package:equatable/equatable.dart';

/// Position of a chunk in the world grid.
class ChunkCoord extends Equatable {
  /// Creates a [ChunkCoord].
  const ChunkCoord(this.cx, this.cy);

  /// The chunk containing the world tile ([tileX], [tileY]).
  factory ChunkCoord.ofTile(int tileX, int tileY) =>
      ChunkCoord(floorDiv(tileX, chunkSize), floorDiv(tileY, chunkSize));

  /// Chunk column.
  final int cx;

  /// Chunk row.
  final int cy;

  @override
  List<Object> get props => [cx, cy];
}
