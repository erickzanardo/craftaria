import 'dart:typed_data';

import 'package:craftaria_map/src/chunk_coord.dart';
import 'package:craftaria_map/src/constants.dart';
import 'package:craftaria_protocol/craftaria_protocol.dart' as pb;
import 'package:equatable/equatable.dart';

/// A named grid of tile ids.
class ChunkLayer extends Equatable {
  /// Creates a [ChunkLayer]. [tiles] holds [tilesPerChunk] row-major ids.
  ChunkLayer({
    required this.name,
    required List<int> tiles,
    this.aboveEntities = false,
  }) : tiles = List.unmodifiable(tiles);

  /// Stable layer name, e.g. `ground`.
  final String name;

  /// Row-major tile ids, `0` meaning empty.
  final List<int> tiles;

  /// Whether the layer is drawn above players and entities.
  final bool aboveEntities;

  /// Tile id at local coordinates.
  int tileAt(int localX, int localY) => tiles[localY * chunkSize + localX];

  @override
  List<Object> get props => [name, tiles, aboveEntities];
}

/// An object placed in a chunk, not bound to the tile grid.
class ChunkEntity extends Equatable {
  /// Creates a [ChunkEntity].
  const ChunkEntity({
    required this.id,
    required this.kind,
    required this.x,
    required this.y,
    this.properties = const {},
  });

  /// Unique id within the world.
  final String id;

  /// Entity type, e.g. `chest`.
  final String kind;

  /// Pixels from the chunk's left edge.
  final int x;

  /// Pixels from the chunk's top edge.
  final int y;

  /// Free-form properties.
  final Map<String, String> properties;

  @override
  List<Object> get props => [id, kind, x, y, properties];
}

/// State attached to a single tile of a layer.
class ChunkTileState extends Equatable {
  /// Creates a [ChunkTileState].
  const ChunkTileState({
    required this.index,
    required this.layer,
    this.properties = const {},
  });

  /// Row-major tile index within the chunk.
  final int index;

  /// Name of the layer this state belongs to.
  final String layer;

  /// Free-form properties.
  final Map<String, String> properties;

  @override
  List<Object> get props => [index, layer, properties];
}

/// A [chunkSize] x [chunkSize] region of the world.
class MapChunk extends Equatable {
  /// Creates a [MapChunk]. [collision] is a bitset of [tilesPerChunk] bits.
  MapChunk({
    required this.coord,
    required List<ChunkLayer> layers,
    required Uint8List collision,
    List<ChunkEntity> entities = const [],
    List<ChunkTileState> tileStates = const [],
  }) : layers = List.unmodifiable(layers),
       collision = Uint8List.fromList(collision),
       entities = List.unmodifiable(entities),
       tileStates = List.unmodifiable(tileStates);

  /// Converts from the protobuf representation.
  factory MapChunk.fromProto(pb.Chunk chunk) => MapChunk(
    coord: ChunkCoord(chunk.cx, chunk.cy),
    layers: [
      for (final layer in chunk.layers)
        ChunkLayer(
          name: layer.name,
          tiles: layer.tiles,
          aboveEntities: layer.aboveEntities,
        ),
    ],
    collision: Uint8List.fromList(chunk.collision),
    entities: [
      for (final entity in chunk.entities)
        ChunkEntity(
          id: entity.id,
          kind: entity.kind,
          x: entity.x,
          y: entity.y,
          properties: Map.of(entity.properties),
        ),
    ],
    tileStates: [
      for (final state in chunk.tileStates)
        ChunkTileState(
          index: state.index,
          layer: state.layer,
          properties: Map.of(state.properties),
        ),
    ],
  );

  /// Decodes a binary `craftaria.v1.Chunk`.
  factory MapChunk.decode(List<int> bytes) =>
      MapChunk.fromProto(pb.Chunk.fromBuffer(bytes));

  /// Position of the chunk in the world grid.
  final ChunkCoord coord;

  /// Tile layers, bottom to top.
  final List<ChunkLayer> layers;

  /// Collision bitset, least significant bit first.
  final Uint8List collision;

  /// Objects placed in the chunk.
  final List<ChunkEntity> entities;

  /// Sparse per-tile state.
  final List<ChunkTileState> tileStates;

  /// Whether the tile at local coordinates blocks movement.
  bool isBlocked(int localX, int localY) {
    final index = localY * chunkSize + localX;
    final byte = index >> 3;
    if (byte >= collision.length) return false;
    return collision[byte] & (1 << (index & 7)) != 0;
  }

  /// Converts to the protobuf representation.
  pb.Chunk toProto() => pb.Chunk(
    cx: coord.cx,
    cy: coord.cy,
    collision: collision,
    layers: [
      for (final layer in layers)
        pb.TileLayer(
          name: layer.name,
          tiles: layer.tiles,
          aboveEntities: layer.aboveEntities,
        ),
    ],
    entities: [
      for (final entity in entities)
        pb.PlacedEntity(
          id: entity.id,
          kind: entity.kind,
          x: entity.x,
          y: entity.y,
          properties: entity.properties.entries,
        ),
    ],
    tileStates: [
      for (final state in tileStates)
        pb.TileState(
          index: state.index,
          layer: state.layer,
          properties: state.properties.entries,
        ),
    ],
  );

  /// Encodes as a binary `craftaria.v1.Chunk`.
  Uint8List encode() => toProto().writeToBuffer();

  @override
  List<Object> get props => [coord, layers, collision, entities, tileStates];
}
