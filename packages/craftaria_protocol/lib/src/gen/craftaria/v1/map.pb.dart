// This is a generated file - do not edit.
//
// Generated from craftaria/v1/map.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// A square region of the world, CHUNK_SIZE x CHUNK_SIZE tiles (32x32).
///
/// The same message is produced by the procedural generator, by the map
/// editor and by edited-chunk storage, so every source of map data shares one
/// format. See docs/map-format.md.
class Chunk extends $pb.GeneratedMessage {
  factory Chunk({
    $core.int? cx,
    $core.int? cy,
    $core.Iterable<TileLayer>? layers,
    $core.List<$core.int>? collision,
    $core.Iterable<PlacedEntity>? entities,
    $core.Iterable<TileState>? tileStates,
  }) {
    final result = Chunk._();
    if (cx != null) result.cx = cx;
    if (cy != null) result.cy = cy;
    if (layers != null) result.layers.addAll(layers);
    if (collision != null) result.collision = collision;
    if (entities != null) result.entities.addAll(entities);
    if (tileStates != null) result.tileStates.addAll(tileStates);
    return result;
  }

  Chunk._();

  factory Chunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chunk()..mergeFromBuffer(data, registry);
  factory Chunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chunk()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Chunk.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'cx')
    ..aI(2, _omitFieldNames ? '' : 'cy')
    ..pPM<TileLayer>(3, _omitFieldNames ? '' : 'layers',
        subBuilder: TileLayer.$_createMessage)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'collision', $pb.PbFieldType.OY)
    ..pPM<PlacedEntity>(5, _omitFieldNames ? '' : 'entities',
        subBuilder: PlacedEntity.$_createMessage)
    ..pPM<TileState>(6, _omitFieldNames ? '' : 'tileStates',
        subBuilder: TileState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk copyWith(void Function(Chunk) updates) =>
      super.copyWith((message) => updates(message as Chunk)) as Chunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Chunk() / Chunk.new instead')
  static Chunk create() => Chunk._();
  static $pb.GeneratedMessage $_createMessage() => Chunk._();
  @$core.override
  Chunk createEmptyInstance() => Chunk._();
  @$core.pragma('dart2js:noInline')
  static Chunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Chunk>(Chunk.$_createMessage);
  static Chunk? _defaultInstance;

  /// Chunk coordinates (world tile = chunk coordinate * CHUNK_SIZE + local).
  @$pb.TagNumber(1)
  $core.int get cx => $_getIZ(0);
  @$pb.TagNumber(1)
  set cx($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCx() => $_has(0);
  @$pb.TagNumber(1)
  void clearCx() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get cy => $_getIZ(1);
  @$pb.TagNumber(2)
  set cy($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCy() => $_has(1);
  @$pb.TagNumber(2)
  void clearCy() => $_clearField(2);

  /// Tile layers ordered bottom to top.
  @$pb.TagNumber(3)
  $pb.PbList<TileLayer> get layers => $_getList(2);

  /// Collision bitset, one bit per tile in row-major order (bit i of byte
  /// i / 8, least significant bit first). 1 means the tile blocks movement.
  /// Always CHUNK_SIZE * CHUNK_SIZE / 8 bytes long.
  @$pb.TagNumber(4)
  $core.List<$core.int> get collision => $_getN(3);
  @$pb.TagNumber(4)
  set collision($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCollision() => $_has(3);
  @$pb.TagNumber(4)
  void clearCollision() => $_clearField(4);

  /// Objects not bound to the tile grid (trees, chests, spawners, NPCs...).
  @$pb.TagNumber(5)
  $pb.PbList<PlacedEntity> get entities => $_getList(4);

  /// Sparse per-tile state (growth stage, durability, owner...).
  @$pb.TagNumber(6)
  $pb.PbList<TileState> get tileStates => $_getList(5);
}

class TileLayer extends $pb.GeneratedMessage {
  factory TileLayer({
    $core.String? name,
    $core.Iterable<$core.int>? tiles,
    $core.bool? aboveEntities,
  }) {
    final result = TileLayer._();
    if (name != null) result.name = name;
    if (tiles != null) result.tiles.addAll(tiles);
    if (aboveEntities != null) result.aboveEntities = aboveEntities;
    return result;
  }

  TileLayer._();

  factory TileLayer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileLayer()..mergeFromBuffer(data, registry);
  factory TileLayer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileLayer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TileLayer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: TileLayer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..p<$core.int>(2, _omitFieldNames ? '' : 'tiles', $pb.PbFieldType.KU3)
    ..aOB(3, _omitFieldNames ? '' : 'aboveEntities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileLayer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileLayer copyWith(void Function(TileLayer) updates) =>
      super.copyWith((message) => updates(message as TileLayer)) as TileLayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TileLayer() / TileLayer.new instead')
  static TileLayer create() => TileLayer._();
  static $pb.GeneratedMessage $_createMessage() => TileLayer._();
  @$core.override
  TileLayer createEmptyInstance() => TileLayer._();
  @$core.pragma('dart2js:noInline')
  static TileLayer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TileLayer>(TileLayer.$_createMessage);
  static TileLayer? _defaultInstance;

  /// Stable layer name, e.g. "ground", "decoration", "overlay".
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Row-major tile ids, CHUNK_SIZE * CHUNK_SIZE entries. 0 means empty.
  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get tiles => $_getList(1);

  /// When true the layer is drawn above players and entities.
  @$pb.TagNumber(3)
  $core.bool get aboveEntities => $_getBF(2);
  @$pb.TagNumber(3)
  set aboveEntities($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAboveEntities() => $_has(2);
  @$pb.TagNumber(3)
  void clearAboveEntities() => $_clearField(3);
}

class PlacedEntity extends $pb.GeneratedMessage {
  factory PlacedEntity({
    $core.String? id,
    $core.String? kind,
    $core.int? x,
    $core.int? y,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? properties,
  }) {
    final result = PlacedEntity._();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (properties != null) result.properties.addEntries(properties);
    return result;
  }

  PlacedEntity._();

  factory PlacedEntity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlacedEntity()..mergeFromBuffer(data, registry);
  factory PlacedEntity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlacedEntity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlacedEntity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: PlacedEntity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aI(3, _omitFieldNames ? '' : 'x')
    ..aI(4, _omitFieldNames ? '' : 'y')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'properties',
        entryClassName: 'PlacedEntity.PropertiesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('craftaria.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlacedEntity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlacedEntity copyWith(void Function(PlacedEntity) updates) =>
      super.copyWith((message) => updates(message as PlacedEntity))
          as PlacedEntity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlacedEntity() / PlacedEntity.new instead')
  static PlacedEntity create() => PlacedEntity._();
  static $pb.GeneratedMessage $_createMessage() => PlacedEntity._();
  @$core.override
  PlacedEntity createEmptyInstance() => PlacedEntity._();
  @$core.pragma('dart2js:noInline')
  static PlacedEntity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlacedEntity>(
          PlacedEntity.$_createMessage);
  static PlacedEntity? _defaultInstance;

  /// Unique within the world.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Entity type, e.g. "tree", "chest".
  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  /// Position in pixels relative to the chunk's top-left corner.
  @$pb.TagNumber(3)
  $core.int get x => $_getIZ(2);
  @$pb.TagNumber(3)
  set x($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasX() => $_has(2);
  @$pb.TagNumber(3)
  void clearX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get y => $_getIZ(3);
  @$pb.TagNumber(4)
  set y($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasY() => $_has(3);
  @$pb.TagNumber(4)
  void clearY() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get properties => $_getMap(4);
}

class TileState extends $pb.GeneratedMessage {
  factory TileState({
    $core.int? index,
    $core.String? layer,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? properties,
  }) {
    final result = TileState._();
    if (index != null) result.index = index;
    if (layer != null) result.layer = layer;
    if (properties != null) result.properties.addEntries(properties);
    return result;
  }

  TileState._();

  factory TileState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileState()..mergeFromBuffer(data, registry);
  factory TileState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TileState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: TileState.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'layer')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'properties',
        entryClassName: 'TileState.PropertiesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('craftaria.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileState copyWith(void Function(TileState) updates) =>
      super.copyWith((message) => updates(message as TileState)) as TileState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TileState() / TileState.new instead')
  static TileState create() => TileState._();
  static $pb.GeneratedMessage $_createMessage() => TileState._();
  @$core.override
  TileState createEmptyInstance() => TileState._();
  @$core.pragma('dart2js:noInline')
  static TileState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TileState>(TileState.$_createMessage);
  static TileState? _defaultInstance;

  /// Row-major tile index within the chunk.
  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  /// Name of the layer the state belongs to.
  @$pb.TagNumber(2)
  $core.String get layer => $_getSZ(1);
  @$pb.TagNumber(2)
  set layer($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLayer() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayer() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get properties => $_getMap(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
