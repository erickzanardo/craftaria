// This is a generated file - do not edit.
//
// Generated from craftaria/v1/net.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'map.pb.dart' as $0;
import 'net.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'net.pbenum.dart';

/// Coordinates on the wire are integer sub-pixels (SUBPIXELS_PER_PIXEL = 16)
/// so the client prediction and the server simulation stay bit-identical.
class Vec2 extends $pb.GeneratedMessage {
  factory Vec2({
    $core.int? x,
    $core.int? y,
  }) {
    final result = Vec2._();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  Vec2._();

  factory Vec2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Vec2()..mergeFromBuffer(data, registry);
  factory Vec2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Vec2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vec2',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Vec2.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OS3)
    ..aI(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OS3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vec2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vec2 copyWith(void Function(Vec2) updates) =>
      super.copyWith((message) => updates(message as Vec2)) as Vec2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Vec2() / Vec2.new instead')
  static Vec2 create() => Vec2._();
  static $pb.GeneratedMessage $_createMessage() => Vec2._();
  @$core.override
  Vec2 createEmptyInstance() => Vec2._();
  @$core.pragma('dart2js:noInline')
  static Vec2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Vec2>(Vec2.$_createMessage);
  static Vec2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get x => $_getIZ(0);
  @$pb.TagNumber(1)
  set x($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get y => $_getIZ(1);
  @$pb.TagNumber(2)
  set y($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

enum ClientMessage_Payload {
  hello,
  move,
  ping,
  gather,
  cancelAction,
  equip,
  debug,
  setAppearance,
  notSet
}

/// Every frame sent by the client.
class ClientMessage extends $pb.GeneratedMessage {
  factory ClientMessage({
    Hello? hello,
    MoveInput? move,
    Ping? ping,
    Gather? gather,
    CancelAction? cancelAction,
    EquipItem? equip,
    DebugCommand? debug,
    SetAppearance? setAppearance,
  }) {
    final result = ClientMessage._();
    if (hello != null) result.hello = hello;
    if (move != null) result.move = move;
    if (ping != null) result.ping = ping;
    if (gather != null) result.gather = gather;
    if (cancelAction != null) result.cancelAction = cancelAction;
    if (equip != null) result.equip = equip;
    if (debug != null) result.debug = debug;
    if (setAppearance != null) result.setAppearance = setAppearance;
    return result;
  }

  ClientMessage._();

  factory ClientMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientMessage()..mergeFromBuffer(data, registry);
  factory ClientMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientMessage_Payload>
      _ClientMessage_PayloadByTag = {
    1: ClientMessage_Payload.hello,
    2: ClientMessage_Payload.move,
    3: ClientMessage_Payload.ping,
    4: ClientMessage_Payload.gather,
    5: ClientMessage_Payload.cancelAction,
    6: ClientMessage_Payload.equip,
    7: ClientMessage_Payload.debug,
    8: ClientMessage_Payload.setAppearance,
    0: ClientMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ClientMessage.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8])
    ..aOM<Hello>(1, _omitFieldNames ? '' : 'hello',
        subBuilder: Hello.$_createMessage)
    ..aOM<MoveInput>(2, _omitFieldNames ? '' : 'move',
        subBuilder: MoveInput.$_createMessage)
    ..aOM<Ping>(3, _omitFieldNames ? '' : 'ping',
        subBuilder: Ping.$_createMessage)
    ..aOM<Gather>(4, _omitFieldNames ? '' : 'gather',
        subBuilder: Gather.$_createMessage)
    ..aOM<CancelAction>(5, _omitFieldNames ? '' : 'cancelAction',
        subBuilder: CancelAction.$_createMessage)
    ..aOM<EquipItem>(6, _omitFieldNames ? '' : 'equip',
        subBuilder: EquipItem.$_createMessage)
    ..aOM<DebugCommand>(7, _omitFieldNames ? '' : 'debug',
        subBuilder: DebugCommand.$_createMessage)
    ..aOM<SetAppearance>(8, _omitFieldNames ? '' : 'setAppearance',
        subBuilder: SetAppearance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage copyWith(void Function(ClientMessage) updates) =>
      super.copyWith((message) => updates(message as ClientMessage))
          as ClientMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClientMessage() / ClientMessage.new instead')
  static ClientMessage create() => ClientMessage._();
  static $pb.GeneratedMessage $_createMessage() => ClientMessage._();
  @$core.override
  ClientMessage createEmptyInstance() => ClientMessage._();
  @$core.pragma('dart2js:noInline')
  static ClientMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientMessage>(
          ClientMessage.$_createMessage);
  static ClientMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  ClientMessage_Payload whichPayload() =>
      _ClientMessage_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Hello get hello => $_getN(0);
  @$pb.TagNumber(1)
  set hello(Hello value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHello() => $_has(0);
  @$pb.TagNumber(1)
  void clearHello() => $_clearField(1);
  @$pb.TagNumber(1)
  Hello ensureHello() => $_ensure(0);

  @$pb.TagNumber(2)
  MoveInput get move => $_getN(1);
  @$pb.TagNumber(2)
  set move(MoveInput value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMove() => $_has(1);
  @$pb.TagNumber(2)
  void clearMove() => $_clearField(2);
  @$pb.TagNumber(2)
  MoveInput ensureMove() => $_ensure(1);

  @$pb.TagNumber(3)
  Ping get ping => $_getN(2);
  @$pb.TagNumber(3)
  set ping(Ping value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPing() => $_has(2);
  @$pb.TagNumber(3)
  void clearPing() => $_clearField(3);
  @$pb.TagNumber(3)
  Ping ensurePing() => $_ensure(2);

  @$pb.TagNumber(4)
  Gather get gather => $_getN(3);
  @$pb.TagNumber(4)
  set gather(Gather value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGather() => $_has(3);
  @$pb.TagNumber(4)
  void clearGather() => $_clearField(4);
  @$pb.TagNumber(4)
  Gather ensureGather() => $_ensure(3);

  @$pb.TagNumber(5)
  CancelAction get cancelAction => $_getN(4);
  @$pb.TagNumber(5)
  set cancelAction(CancelAction value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCancelAction() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancelAction() => $_clearField(5);
  @$pb.TagNumber(5)
  CancelAction ensureCancelAction() => $_ensure(4);

  @$pb.TagNumber(6)
  EquipItem get equip => $_getN(5);
  @$pb.TagNumber(6)
  set equip(EquipItem value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEquip() => $_has(5);
  @$pb.TagNumber(6)
  void clearEquip() => $_clearField(6);
  @$pb.TagNumber(6)
  EquipItem ensureEquip() => $_ensure(5);

  @$pb.TagNumber(7)
  DebugCommand get debug => $_getN(6);
  @$pb.TagNumber(7)
  set debug(DebugCommand value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDebug() => $_has(6);
  @$pb.TagNumber(7)
  void clearDebug() => $_clearField(7);
  @$pb.TagNumber(7)
  DebugCommand ensureDebug() => $_ensure(6);

  @$pb.TagNumber(8)
  SetAppearance get setAppearance => $_getN(7);
  @$pb.TagNumber(8)
  set setAppearance(SetAppearance value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSetAppearance() => $_has(7);
  @$pb.TagNumber(8)
  void clearSetAppearance() => $_clearField(8);
  @$pb.TagNumber(8)
  SetAppearance ensureSetAppearance() => $_ensure(7);
}

/// First message on a socket. The token is sent here instead of in the URL so
/// it never shows up in request logs.
class Hello extends $pb.GeneratedMessage {
  factory Hello({
    $core.String? token,
    $core.int? protocolVersion,
  }) {
    final result = Hello._();
    if (token != null) result.token = token;
    if (protocolVersion != null) result.protocolVersion = protocolVersion;
    return result;
  }

  Hello._();

  factory Hello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hello()..mergeFromBuffer(data, registry);
  factory Hello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hello()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hello',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Hello.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aI(2, _omitFieldNames ? '' : 'protocolVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello copyWith(void Function(Hello) updates) =>
      super.copyWith((message) => updates(message as Hello)) as Hello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Hello() / Hello.new instead')
  static Hello create() => Hello._();
  static $pb.GeneratedMessage $_createMessage() => Hello._();
  @$core.override
  Hello createEmptyInstance() => Hello._();
  @$core.pragma('dart2js:noInline')
  static Hello getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Hello>(Hello.$_createMessage);
  static Hello? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get protocolVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set protocolVersion($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProtocolVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearProtocolVersion() => $_clearField(2);
}

/// One simulation step of movement intent. dx and dy are -1, 0 or 1.
class MoveInput extends $pb.GeneratedMessage {
  factory MoveInput({
    $core.int? seq,
    $core.int? dx,
    $core.int? dy,
  }) {
    final result = MoveInput._();
    if (seq != null) result.seq = seq;
    if (dx != null) result.dx = dx;
    if (dy != null) result.dy = dy;
    return result;
  }

  MoveInput._();

  factory MoveInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoveInput()..mergeFromBuffer(data, registry);
  factory MoveInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MoveInput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: MoveInput.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'dx', fieldType: $pb.PbFieldType.OS3)
    ..aI(3, _omitFieldNames ? '' : 'dy', fieldType: $pb.PbFieldType.OS3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInput copyWith(void Function(MoveInput) updates) =>
      super.copyWith((message) => updates(message as MoveInput)) as MoveInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MoveInput() / MoveInput.new instead')
  static MoveInput create() => MoveInput._();
  static $pb.GeneratedMessage $_createMessage() => MoveInput._();
  @$core.override
  MoveInput createEmptyInstance() => MoveInput._();
  @$core.pragma('dart2js:noInline')
  static MoveInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveInput>(MoveInput.$_createMessage);
  static MoveInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get dx => $_getIZ(1);
  @$pb.TagNumber(2)
  set dx($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDx() => $_has(1);
  @$pb.TagNumber(2)
  void clearDx() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get dy => $_getIZ(2);
  @$pb.TagNumber(3)
  set dy($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDy() => $_has(2);
  @$pb.TagNumber(3)
  void clearDy() => $_clearField(3);
}

class Ping extends $pb.GeneratedMessage {
  factory Ping({
    $fixnum.Int64? clientTimeMs,
  }) {
    final result = Ping._();
    if (clientTimeMs != null) result.clientTimeMs = clientTimeMs;
    return result;
  }

  Ping._();

  factory Ping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Ping()..mergeFromBuffer(data, registry);
  factory Ping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Ping()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ping',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Ping.$_createMessage)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'clientTimeMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping copyWith(void Function(Ping) updates) =>
      super.copyWith((message) => updates(message as Ping)) as Ping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Ping() / Ping.new instead')
  static Ping create() => Ping._();
  static $pb.GeneratedMessage $_createMessage() => Ping._();
  @$core.override
  Ping createEmptyInstance() => Ping._();
  @$core.pragma('dart2js:noInline')
  static Ping getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Ping>(Ping.$_createMessage);
  static Ping? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clientTimeMs => $_getI64(0);
  @$pb.TagNumber(1)
  set clientTimeMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientTimeMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTimeMs() => $_clearField(1);
}

/// Start gathering from the resource node on a world tile. Shares the
/// MoveInput seq space so the server applies it after the moves sent before
/// it.
class Gather extends $pb.GeneratedMessage {
  factory Gather({
    $core.int? seq,
    $core.int? tileX,
    $core.int? tileY,
  }) {
    final result = Gather._();
    if (seq != null) result.seq = seq;
    if (tileX != null) result.tileX = tileX;
    if (tileY != null) result.tileY = tileY;
    return result;
  }

  Gather._();

  factory Gather.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Gather()..mergeFromBuffer(data, registry);
  factory Gather.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Gather()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Gather',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Gather.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'tileX', fieldType: $pb.PbFieldType.OS3)
    ..aI(3, _omitFieldNames ? '' : 'tileY', fieldType: $pb.PbFieldType.OS3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gather clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gather copyWith(void Function(Gather) updates) =>
      super.copyWith((message) => updates(message as Gather)) as Gather;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Gather() / Gather.new instead')
  static Gather create() => Gather._();
  static $pb.GeneratedMessage $_createMessage() => Gather._();
  @$core.override
  Gather createEmptyInstance() => Gather._();
  @$core.pragma('dart2js:noInline')
  static Gather getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Gather>(Gather.$_createMessage);
  static Gather? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tileX => $_getIZ(1);
  @$pb.TagNumber(2)
  set tileX($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTileX() => $_has(1);
  @$pb.TagNumber(2)
  void clearTileX() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get tileY => $_getIZ(2);
  @$pb.TagNumber(3)
  set tileY($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTileY() => $_has(2);
  @$pb.TagNumber(3)
  void clearTileY() => $_clearField(3);
}

/// Stop the current action.
class CancelAction extends $pb.GeneratedMessage {
  factory CancelAction() => CancelAction._();

  CancelAction._();

  factory CancelAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelAction()..mergeFromBuffer(data, registry);
  factory CancelAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelAction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelAction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: CancelAction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAction copyWith(void Function(CancelAction) updates) =>
      super.copyWith((message) => updates(message as CancelAction))
          as CancelAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelAction() / CancelAction.new instead')
  static CancelAction create() => CancelAction._();
  static $pb.GeneratedMessage $_createMessage() => CancelAction._();
  @$core.override
  CancelAction createEmptyInstance() => CancelAction._();
  @$core.pragma('dart2js:noInline')
  static CancelAction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelAction>(
          CancelAction.$_createMessage);
  static CancelAction? _defaultInstance;
}

/// Equip the tool in an inventory slot.
class EquipItem extends $pb.GeneratedMessage {
  factory EquipItem({
    $core.int? slot,
  }) {
    final result = EquipItem._();
    if (slot != null) result.slot = slot;
    return result;
  }

  EquipItem._();

  factory EquipItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EquipItem()..mergeFromBuffer(data, registry);
  factory EquipItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EquipItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EquipItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: EquipItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'slot', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquipItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EquipItem copyWith(void Function(EquipItem) updates) =>
      super.copyWith((message) => updates(message as EquipItem)) as EquipItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EquipItem() / EquipItem.new instead')
  static EquipItem create() => EquipItem._();
  static $pb.GeneratedMessage $_createMessage() => EquipItem._();
  @$core.override
  EquipItem createEmptyInstance() => EquipItem._();
  @$core.pragma('dart2js:noInline')
  static EquipItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EquipItem>(EquipItem.$_createMessage);
  static EquipItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get slot => $_getIZ(0);
  @$pb.TagNumber(1)
  set slot($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlot() => $_clearField(1);
}

/// Creates or changes the player's character. Ignored unless every color is
/// allowed for its part (see Welcome).
class SetAppearance extends $pb.GeneratedMessage {
  factory SetAppearance({
    Appearance? appearance,
  }) {
    final result = SetAppearance._();
    if (appearance != null) result.appearance = appearance;
    return result;
  }

  SetAppearance._();

  factory SetAppearance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAppearance()..mergeFromBuffer(data, registry);
  factory SetAppearance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAppearance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAppearance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: SetAppearance.$_createMessage)
    ..aOM<Appearance>(1, _omitFieldNames ? '' : 'appearance',
        subBuilder: Appearance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppearance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppearance copyWith(void Function(SetAppearance) updates) =>
      super.copyWith((message) => updates(message as SetAppearance))
          as SetAppearance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetAppearance() / SetAppearance.new instead')
  static SetAppearance create() => SetAppearance._();
  static $pb.GeneratedMessage $_createMessage() => SetAppearance._();
  @$core.override
  SetAppearance createEmptyInstance() => SetAppearance._();
  @$core.pragma('dart2js:noInline')
  static SetAppearance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetAppearance>(
          SetAppearance.$_createMessage);
  static SetAppearance? _defaultInstance;

  @$pb.TagNumber(1)
  Appearance get appearance => $_getN(0);
  @$pb.TagNumber(1)
  set appearance(Appearance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppearance() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppearance() => $_clearField(1);
  @$pb.TagNumber(1)
  Appearance ensureAppearance() => $_ensure(0);
}

/// How a character looks: one palette index per tinted part.
class Appearance extends $pb.GeneratedMessage {
  factory Appearance({
    $core.int? skin,
    $core.int? shirt,
    $core.int? pants,
  }) {
    final result = Appearance._();
    if (skin != null) result.skin = skin;
    if (shirt != null) result.shirt = shirt;
    if (pants != null) result.pants = pants;
    return result;
  }

  Appearance._();

  factory Appearance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Appearance()..mergeFromBuffer(data, registry);
  factory Appearance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Appearance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Appearance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Appearance.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'skin', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'shirt', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'pants', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Appearance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Appearance copyWith(void Function(Appearance) updates) =>
      super.copyWith((message) => updates(message as Appearance)) as Appearance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Appearance() / Appearance.new instead')
  static Appearance create() => Appearance._();
  static $pb.GeneratedMessage $_createMessage() => Appearance._();
  @$core.override
  Appearance createEmptyInstance() => Appearance._();
  @$core.pragma('dart2js:noInline')
  static Appearance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Appearance>(Appearance.$_createMessage);
  static Appearance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get skin => $_getIZ(0);
  @$pb.TagNumber(1)
  set skin($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkin() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get shirt => $_getIZ(1);
  @$pb.TagNumber(2)
  set shirt($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShirt() => $_has(1);
  @$pb.TagNumber(2)
  void clearShirt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pants => $_getIZ(2);
  @$pb.TagNumber(3)
  set pants($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPants() => $_has(2);
  @$pb.TagNumber(3)
  void clearPants() => $_clearField(3);
}

enum DebugCommand_Command { grantItem, grantXp, notSet }

/// Development only: ignored unless the server enables debug commands.
class DebugCommand extends $pb.GeneratedMessage {
  factory DebugCommand({
    GrantItem? grantItem,
    GrantXp? grantXp,
  }) {
    final result = DebugCommand._();
    if (grantItem != null) result.grantItem = grantItem;
    if (grantXp != null) result.grantXp = grantXp;
    return result;
  }

  DebugCommand._();

  factory DebugCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DebugCommand()..mergeFromBuffer(data, registry);
  factory DebugCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DebugCommand()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DebugCommand_Command>
      _DebugCommand_CommandByTag = {
    1: DebugCommand_Command.grantItem,
    2: DebugCommand_Command.grantXp,
    0: DebugCommand_Command.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DebugCommand',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: DebugCommand.$_createMessage)
    ..oo(0, [1, 2])
    ..aOM<GrantItem>(1, _omitFieldNames ? '' : 'grantItem',
        subBuilder: GrantItem.$_createMessage)
    ..aOM<GrantXp>(2, _omitFieldNames ? '' : 'grantXp',
        subBuilder: GrantXp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DebugCommand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DebugCommand copyWith(void Function(DebugCommand) updates) =>
      super.copyWith((message) => updates(message as DebugCommand))
          as DebugCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DebugCommand() / DebugCommand.new instead')
  static DebugCommand create() => DebugCommand._();
  static $pb.GeneratedMessage $_createMessage() => DebugCommand._();
  @$core.override
  DebugCommand createEmptyInstance() => DebugCommand._();
  @$core.pragma('dart2js:noInline')
  static DebugCommand getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DebugCommand>(
          DebugCommand.$_createMessage);
  static DebugCommand? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  DebugCommand_Command whichCommand() =>
      _DebugCommand_CommandByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearCommand() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  GrantItem get grantItem => $_getN(0);
  @$pb.TagNumber(1)
  set grantItem(GrantItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGrantItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrantItem() => $_clearField(1);
  @$pb.TagNumber(1)
  GrantItem ensureGrantItem() => $_ensure(0);

  @$pb.TagNumber(2)
  GrantXp get grantXp => $_getN(1);
  @$pb.TagNumber(2)
  set grantXp(GrantXp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGrantXp() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrantXp() => $_clearField(2);
  @$pb.TagNumber(2)
  GrantXp ensureGrantXp() => $_ensure(1);
}

class GrantItem extends $pb.GeneratedMessage {
  factory GrantItem({
    $core.String? itemId,
    $core.int? count,
  }) {
    final result = GrantItem._();
    if (itemId != null) result.itemId = itemId;
    if (count != null) result.count = count;
    return result;
  }

  GrantItem._();

  factory GrantItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrantItem()..mergeFromBuffer(data, registry);
  factory GrantItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrantItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GrantItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: GrantItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aI(2, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrantItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrantItem copyWith(void Function(GrantItem) updates) =>
      super.copyWith((message) => updates(message as GrantItem)) as GrantItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GrantItem() / GrantItem.new instead')
  static GrantItem create() => GrantItem._();
  static $pb.GeneratedMessage $_createMessage() => GrantItem._();
  @$core.override
  GrantItem createEmptyInstance() => GrantItem._();
  @$core.pragma('dart2js:noInline')
  static GrantItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GrantItem>(GrantItem.$_createMessage);
  static GrantItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class GrantXp extends $pb.GeneratedMessage {
  factory GrantXp({
    $core.String? skillId,
    $core.int? amount,
  }) {
    final result = GrantXp._();
    if (skillId != null) result.skillId = skillId;
    if (amount != null) result.amount = amount;
    return result;
  }

  GrantXp._();

  factory GrantXp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrantXp()..mergeFromBuffer(data, registry);
  factory GrantXp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrantXp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GrantXp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: GrantXp.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aI(2, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrantXp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrantXp copyWith(void Function(GrantXp) updates) =>
      super.copyWith((message) => updates(message as GrantXp)) as GrantXp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GrantXp() / GrantXp.new instead')
  static GrantXp create() => GrantXp._();
  static $pb.GeneratedMessage $_createMessage() => GrantXp._();
  @$core.override
  GrantXp createEmptyInstance() => GrantXp._();
  @$core.pragma('dart2js:noInline')
  static GrantXp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GrantXp>(GrantXp.$_createMessage);
  static GrantXp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get amount => $_getIZ(1);
  @$pb.TagNumber(2)
  set amount($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
}

enum ServerMessage_Payload {
  welcome,
  snapshot,
  chunk,
  pong,
  error,
  inventory,
  skill,
  action,
  tile,
  notice,
  notSet
}

/// Every frame sent by the server.
class ServerMessage extends $pb.GeneratedMessage {
  factory ServerMessage({
    Welcome? welcome,
    Snapshot? snapshot,
    ChunkData? chunk,
    Pong? pong,
    ServerError? error,
    InventoryUpdate? inventory,
    SkillUpdate? skill,
    ActionState? action,
    TileUpdate? tile,
    Notice? notice,
  }) {
    final result = ServerMessage._();
    if (welcome != null) result.welcome = welcome;
    if (snapshot != null) result.snapshot = snapshot;
    if (chunk != null) result.chunk = chunk;
    if (pong != null) result.pong = pong;
    if (error != null) result.error = error;
    if (inventory != null) result.inventory = inventory;
    if (skill != null) result.skill = skill;
    if (action != null) result.action = action;
    if (tile != null) result.tile = tile;
    if (notice != null) result.notice = notice;
    return result;
  }

  ServerMessage._();

  factory ServerMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerMessage()..mergeFromBuffer(data, registry);
  factory ServerMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerMessage_Payload>
      _ServerMessage_PayloadByTag = {
    1: ServerMessage_Payload.welcome,
    2: ServerMessage_Payload.snapshot,
    3: ServerMessage_Payload.chunk,
    4: ServerMessage_Payload.pong,
    5: ServerMessage_Payload.error,
    6: ServerMessage_Payload.inventory,
    7: ServerMessage_Payload.skill,
    8: ServerMessage_Payload.action,
    9: ServerMessage_Payload.tile,
    10: ServerMessage_Payload.notice,
    0: ServerMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ServerMessage.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOM<Welcome>(1, _omitFieldNames ? '' : 'welcome',
        subBuilder: Welcome.$_createMessage)
    ..aOM<Snapshot>(2, _omitFieldNames ? '' : 'snapshot',
        subBuilder: Snapshot.$_createMessage)
    ..aOM<ChunkData>(3, _omitFieldNames ? '' : 'chunk',
        subBuilder: ChunkData.$_createMessage)
    ..aOM<Pong>(4, _omitFieldNames ? '' : 'pong',
        subBuilder: Pong.$_createMessage)
    ..aOM<ServerError>(5, _omitFieldNames ? '' : 'error',
        subBuilder: ServerError.$_createMessage)
    ..aOM<InventoryUpdate>(6, _omitFieldNames ? '' : 'inventory',
        subBuilder: InventoryUpdate.$_createMessage)
    ..aOM<SkillUpdate>(7, _omitFieldNames ? '' : 'skill',
        subBuilder: SkillUpdate.$_createMessage)
    ..aOM<ActionState>(8, _omitFieldNames ? '' : 'action',
        subBuilder: ActionState.$_createMessage)
    ..aOM<TileUpdate>(9, _omitFieldNames ? '' : 'tile',
        subBuilder: TileUpdate.$_createMessage)
    ..aOM<Notice>(10, _omitFieldNames ? '' : 'notice',
        subBuilder: Notice.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerMessage copyWith(void Function(ServerMessage) updates) =>
      super.copyWith((message) => updates(message as ServerMessage))
          as ServerMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerMessage() / ServerMessage.new instead')
  static ServerMessage create() => ServerMessage._();
  static $pb.GeneratedMessage $_createMessage() => ServerMessage._();
  @$core.override
  ServerMessage createEmptyInstance() => ServerMessage._();
  @$core.pragma('dart2js:noInline')
  static ServerMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerMessage>(
          ServerMessage.$_createMessage);
  static ServerMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  ServerMessage_Payload whichPayload() =>
      _ServerMessage_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Welcome get welcome => $_getN(0);
  @$pb.TagNumber(1)
  set welcome(Welcome value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWelcome() => $_has(0);
  @$pb.TagNumber(1)
  void clearWelcome() => $_clearField(1);
  @$pb.TagNumber(1)
  Welcome ensureWelcome() => $_ensure(0);

  @$pb.TagNumber(2)
  Snapshot get snapshot => $_getN(1);
  @$pb.TagNumber(2)
  set snapshot(Snapshot value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  Snapshot ensureSnapshot() => $_ensure(1);

  @$pb.TagNumber(3)
  ChunkData get chunk => $_getN(2);
  @$pb.TagNumber(3)
  set chunk(ChunkData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChunk() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunk() => $_clearField(3);
  @$pb.TagNumber(3)
  ChunkData ensureChunk() => $_ensure(2);

  @$pb.TagNumber(4)
  Pong get pong => $_getN(3);
  @$pb.TagNumber(4)
  set pong(Pong value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPong() => $_has(3);
  @$pb.TagNumber(4)
  void clearPong() => $_clearField(4);
  @$pb.TagNumber(4)
  Pong ensurePong() => $_ensure(3);

  @$pb.TagNumber(5)
  ServerError get error => $_getN(4);
  @$pb.TagNumber(5)
  set error(ServerError value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);
  @$pb.TagNumber(5)
  ServerError ensureError() => $_ensure(4);

  @$pb.TagNumber(6)
  InventoryUpdate get inventory => $_getN(5);
  @$pb.TagNumber(6)
  set inventory(InventoryUpdate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasInventory() => $_has(5);
  @$pb.TagNumber(6)
  void clearInventory() => $_clearField(6);
  @$pb.TagNumber(6)
  InventoryUpdate ensureInventory() => $_ensure(5);

  @$pb.TagNumber(7)
  SkillUpdate get skill => $_getN(6);
  @$pb.TagNumber(7)
  set skill(SkillUpdate value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSkill() => $_has(6);
  @$pb.TagNumber(7)
  void clearSkill() => $_clearField(7);
  @$pb.TagNumber(7)
  SkillUpdate ensureSkill() => $_ensure(6);

  @$pb.TagNumber(8)
  ActionState get action => $_getN(7);
  @$pb.TagNumber(8)
  set action(ActionState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAction() => $_has(7);
  @$pb.TagNumber(8)
  void clearAction() => $_clearField(8);
  @$pb.TagNumber(8)
  ActionState ensureAction() => $_ensure(7);

  @$pb.TagNumber(9)
  TileUpdate get tile => $_getN(8);
  @$pb.TagNumber(9)
  set tile(TileUpdate value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTile() => $_has(8);
  @$pb.TagNumber(9)
  void clearTile() => $_clearField(9);
  @$pb.TagNumber(9)
  TileUpdate ensureTile() => $_ensure(8);

  @$pb.TagNumber(10)
  Notice get notice => $_getN(9);
  @$pb.TagNumber(10)
  set notice(Notice value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNotice() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotice() => $_clearField(10);
  @$pb.TagNumber(10)
  Notice ensureNotice() => $_ensure(9);
}

class Welcome extends $pb.GeneratedMessage {
  factory Welcome({
    $core.String? playerId,
    $core.int? tickRate,
    Vec2? spawn,
    $core.Iterable<ItemDefinition>? items,
    $core.Iterable<$core.int>? palette,
    $core.Iterable<$core.int>? skinColors,
    Appearance? appearance,
  }) {
    final result = Welcome._();
    if (playerId != null) result.playerId = playerId;
    if (tickRate != null) result.tickRate = tickRate;
    if (spawn != null) result.spawn = spawn;
    if (items != null) result.items.addAll(items);
    if (palette != null) result.palette.addAll(palette);
    if (skinColors != null) result.skinColors.addAll(skinColors);
    if (appearance != null) result.appearance = appearance;
    return result;
  }

  Welcome._();

  factory Welcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Welcome()..mergeFromBuffer(data, registry);
  factory Welcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Welcome()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Welcome',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Welcome.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'playerId')
    ..aI(2, _omitFieldNames ? '' : 'tickRate', fieldType: $pb.PbFieldType.OU3)
    ..aOM<Vec2>(3, _omitFieldNames ? '' : 'spawn',
        subBuilder: Vec2.$_createMessage)
    ..pPM<ItemDefinition>(4, _omitFieldNames ? '' : 'items',
        subBuilder: ItemDefinition.$_createMessage)
    ..p<$core.int>(5, _omitFieldNames ? '' : 'palette', $pb.PbFieldType.KU3)
    ..p<$core.int>(6, _omitFieldNames ? '' : 'skinColors', $pb.PbFieldType.KU3)
    ..aOM<Appearance>(7, _omitFieldNames ? '' : 'appearance',
        subBuilder: Appearance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Welcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Welcome copyWith(void Function(Welcome) updates) =>
      super.copyWith((message) => updates(message as Welcome)) as Welcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Welcome() / Welcome.new instead')
  static Welcome create() => Welcome._();
  static $pb.GeneratedMessage $_createMessage() => Welcome._();
  @$core.override
  Welcome createEmptyInstance() => Welcome._();
  @$core.pragma('dart2js:noInline')
  static Welcome getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Welcome>(Welcome.$_createMessage);
  static Welcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tickRate => $_getIZ(1);
  @$pb.TagNumber(2)
  set tickRate($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTickRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTickRate() => $_clearField(2);

  @$pb.TagNumber(3)
  Vec2 get spawn => $_getN(2);
  @$pb.TagNumber(3)
  set spawn(Vec2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSpawn() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpawn() => $_clearField(3);
  @$pb.TagNumber(3)
  Vec2 ensureSpawn() => $_ensure(2);

  /// Display data for every item, so the client never hardcodes content.
  @$pb.TagNumber(4)
  $pb.PbList<ItemDefinition> get items => $_getList(3);

  /// The game palette as 0xRRGGBB colors; appearances index into it.
  @$pb.TagNumber(5)
  $pb.PbList<$core.int> get palette => $_getList(4);

  /// Palette indexes allowed for skin. Shirt and pants take any other.
  @$pb.TagNumber(6)
  $pb.PbList<$core.int> get skinColors => $_getList(5);

  /// The player's character; unset until they create one.
  @$pb.TagNumber(7)
  Appearance get appearance => $_getN(6);
  @$pb.TagNumber(7)
  set appearance(Appearance value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAppearance() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppearance() => $_clearField(7);
  @$pb.TagNumber(7)
  Appearance ensureAppearance() => $_ensure(6);
}

class ItemDefinition extends $pb.GeneratedMessage {
  factory ItemDefinition({
    $core.String? id,
    $core.String? name,
    $core.int? maxStack,
  }) {
    final result = ItemDefinition._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (maxStack != null) result.maxStack = maxStack;
    return result;
  }

  ItemDefinition._();

  factory ItemDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemDefinition()..mergeFromBuffer(data, registry);
  factory ItemDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemDefinition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemDefinition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ItemDefinition.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'maxStack', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemDefinition copyWith(void Function(ItemDefinition) updates) =>
      super.copyWith((message) => updates(message as ItemDefinition))
          as ItemDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ItemDefinition() / ItemDefinition.new instead')
  static ItemDefinition create() => ItemDefinition._();
  static $pb.GeneratedMessage $_createMessage() => ItemDefinition._();
  @$core.override
  ItemDefinition createEmptyInstance() => ItemDefinition._();
  @$core.pragma('dart2js:noInline')
  static ItemDefinition getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemDefinition>(
          ItemDefinition.$_createMessage);
  static ItemDefinition? _defaultInstance;

  /// Stable item id, e.g. "pine_log".
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxStack => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxStack($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxStack() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxStack() => $_clearField(3);
}

/// The player's whole inventory, sent when it changes.
class InventoryUpdate extends $pb.GeneratedMessage {
  factory InventoryUpdate({
    $core.Iterable<ItemStack>? slots,
    $core.String? equipped,
  }) {
    final result = InventoryUpdate._();
    if (slots != null) result.slots.addAll(slots);
    if (equipped != null) result.equipped = equipped;
    return result;
  }

  InventoryUpdate._();

  factory InventoryUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryUpdate()..mergeFromBuffer(data, registry);
  factory InventoryUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InventoryUpdate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InventoryUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: InventoryUpdate.$_createMessage)
    ..pPM<ItemStack>(1, _omitFieldNames ? '' : 'slots',
        subBuilder: ItemStack.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'equipped')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InventoryUpdate copyWith(void Function(InventoryUpdate) updates) =>
      super.copyWith((message) => updates(message as InventoryUpdate))
          as InventoryUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InventoryUpdate() / InventoryUpdate.new instead')
  static InventoryUpdate create() => InventoryUpdate._();
  static $pb.GeneratedMessage $_createMessage() => InventoryUpdate._();
  @$core.override
  InventoryUpdate createEmptyInstance() => InventoryUpdate._();
  @$core.pragma('dart2js:noInline')
  static InventoryUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InventoryUpdate>(
          InventoryUpdate.$_createMessage);
  static InventoryUpdate? _defaultInstance;

  /// One entry per slot; empty slots have an empty item_id.
  @$pb.TagNumber(1)
  $pb.PbList<ItemStack> get slots => $_getList(0);

  /// Item id of the equipped tool, empty when none.
  @$pb.TagNumber(2)
  $core.String get equipped => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipped($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipped() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipped() => $_clearField(2);
}

class ItemStack extends $pb.GeneratedMessage {
  factory ItemStack({
    $core.String? itemId,
    $core.int? count,
  }) {
    final result = ItemStack._();
    if (itemId != null) result.itemId = itemId;
    if (count != null) result.count = count;
    return result;
  }

  ItemStack._();

  factory ItemStack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemStack()..mergeFromBuffer(data, registry);
  factory ItemStack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemStack()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemStack',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ItemStack.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aI(2, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemStack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemStack copyWith(void Function(ItemStack) updates) =>
      super.copyWith((message) => updates(message as ItemStack)) as ItemStack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ItemStack() / ItemStack.new instead')
  static ItemStack create() => ItemStack._();
  static $pb.GeneratedMessage $_createMessage() => ItemStack._();
  @$core.override
  ItemStack createEmptyInstance() => ItemStack._();
  @$core.pragma('dart2js:noInline')
  static ItemStack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemStack>(ItemStack.$_createMessage);
  static ItemStack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

/// Progress in one skill, sent when it changes.
class SkillUpdate extends $pb.GeneratedMessage {
  factory SkillUpdate({
    $core.String? skillId,
    $core.int? level,
    $fixnum.Int64? xp,
    $fixnum.Int64? levelXp,
    $fixnum.Int64? nextLevelXp,
  }) {
    final result = SkillUpdate._();
    if (skillId != null) result.skillId = skillId;
    if (level != null) result.level = level;
    if (xp != null) result.xp = xp;
    if (levelXp != null) result.levelXp = levelXp;
    if (nextLevelXp != null) result.nextLevelXp = nextLevelXp;
    return result;
  }

  SkillUpdate._();

  factory SkillUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SkillUpdate()..mergeFromBuffer(data, registry);
  factory SkillUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SkillUpdate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkillUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: SkillUpdate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'skillId')
    ..aI(2, _omitFieldNames ? '' : 'level', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'xp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'levelXp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'nextLevelXp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkillUpdate copyWith(void Function(SkillUpdate) updates) =>
      super.copyWith((message) => updates(message as SkillUpdate))
          as SkillUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SkillUpdate() / SkillUpdate.new instead')
  static SkillUpdate create() => SkillUpdate._();
  static $pb.GeneratedMessage $_createMessage() => SkillUpdate._();
  @$core.override
  SkillUpdate createEmptyInstance() => SkillUpdate._();
  @$core.pragma('dart2js:noInline')
  static SkillUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SkillUpdate>(
          SkillUpdate.$_createMessage);
  static SkillUpdate? _defaultInstance;

  /// Stable skill id, e.g. "woodcutting".
  @$pb.TagNumber(1)
  $core.String get skillId => $_getSZ(0);
  @$pb.TagNumber(1)
  set skillId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSkillId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkillId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get level => $_getIZ(1);
  @$pb.TagNumber(2)
  set level($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get xp => $_getI64(2);
  @$pb.TagNumber(3)
  set xp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasXp() => $_has(2);
  @$pb.TagNumber(3)
  void clearXp() => $_clearField(3);

  /// Total XP at which the current level started and the next one starts.
  @$pb.TagNumber(4)
  $fixnum.Int64 get levelXp => $_getI64(3);
  @$pb.TagNumber(4)
  set levelXp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLevelXp() => $_has(3);
  @$pb.TagNumber(4)
  void clearLevelXp() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get nextLevelXp => $_getI64(4);
  @$pb.TagNumber(5)
  set nextLevelXp($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNextLevelXp() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextLevelXp() => $_clearField(5);
}

/// The player's current action. Idle when kind is empty.
class ActionState extends $pb.GeneratedMessage {
  factory ActionState({
    $core.String? kind,
    $core.int? tileX,
    $core.int? tileY,
    $core.int? startTick,
    $core.int? durationTicks,
  }) {
    final result = ActionState._();
    if (kind != null) result.kind = kind;
    if (tileX != null) result.tileX = tileX;
    if (tileY != null) result.tileY = tileY;
    if (startTick != null) result.startTick = startTick;
    if (durationTicks != null) result.durationTicks = durationTicks;
    return result;
  }

  ActionState._();

  factory ActionState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionState()..mergeFromBuffer(data, registry);
  factory ActionState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ActionState.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aI(2, _omitFieldNames ? '' : 'tileX', fieldType: $pb.PbFieldType.OS3)
    ..aI(3, _omitFieldNames ? '' : 'tileY', fieldType: $pb.PbFieldType.OS3)
    ..aI(4, _omitFieldNames ? '' : 'startTick', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'durationTicks',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionState copyWith(void Function(ActionState) updates) =>
      super.copyWith((message) => updates(message as ActionState))
          as ActionState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActionState() / ActionState.new instead')
  static ActionState create() => ActionState._();
  static $pb.GeneratedMessage $_createMessage() => ActionState._();
  @$core.override
  ActionState createEmptyInstance() => ActionState._();
  @$core.pragma('dart2js:noInline')
  static ActionState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionState>(
          ActionState.$_createMessage);
  static ActionState? _defaultInstance;

  /// e.g. "gather".
  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tileX => $_getIZ(1);
  @$pb.TagNumber(2)
  set tileX($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTileX() => $_has(1);
  @$pb.TagNumber(2)
  void clearTileX() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get tileY => $_getIZ(2);
  @$pb.TagNumber(3)
  set tileY($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTileY() => $_has(2);
  @$pb.TagNumber(3)
  void clearTileY() => $_clearField(3);

  /// Server tick the current cycle started on, and how long it takes.
  @$pb.TagNumber(4)
  $core.int get startTick => $_getIZ(3);
  @$pb.TagNumber(4)
  set startTick($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStartTick() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartTick() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get durationTicks => $_getIZ(4);
  @$pb.TagNumber(5)
  set durationTicks($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDurationTicks() => $_has(4);
  @$pb.TagNumber(5)
  void clearDurationTicks() => $_clearField(5);
}

/// One edited tile in a chunk the player has loaded.
class TileUpdate extends $pb.GeneratedMessage {
  factory TileUpdate({
    $core.int? cx,
    $core.int? cy,
    $core.String? layer,
    $core.int? index,
    $core.int? tileId,
    $core.bool? blocked,
  }) {
    final result = TileUpdate._();
    if (cx != null) result.cx = cx;
    if (cy != null) result.cy = cy;
    if (layer != null) result.layer = layer;
    if (index != null) result.index = index;
    if (tileId != null) result.tileId = tileId;
    if (blocked != null) result.blocked = blocked;
    return result;
  }

  TileUpdate._();

  factory TileUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileUpdate()..mergeFromBuffer(data, registry);
  factory TileUpdate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TileUpdate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TileUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: TileUpdate.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'cx', fieldType: $pb.PbFieldType.OS3)
    ..aI(2, _omitFieldNames ? '' : 'cy', fieldType: $pb.PbFieldType.OS3)
    ..aOS(3, _omitFieldNames ? '' : 'layer')
    ..aI(4, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'tileId', fieldType: $pb.PbFieldType.OU3)
    ..aOB(6, _omitFieldNames ? '' : 'blocked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TileUpdate copyWith(void Function(TileUpdate) updates) =>
      super.copyWith((message) => updates(message as TileUpdate)) as TileUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TileUpdate() / TileUpdate.new instead')
  static TileUpdate create() => TileUpdate._();
  static $pb.GeneratedMessage $_createMessage() => TileUpdate._();
  @$core.override
  TileUpdate createEmptyInstance() => TileUpdate._();
  @$core.pragma('dart2js:noInline')
  static TileUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TileUpdate>(TileUpdate.$_createMessage);
  static TileUpdate? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get layer => $_getSZ(2);
  @$pb.TagNumber(3)
  set layer($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLayer() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayer() => $_clearField(3);

  /// Row-major tile index within the chunk.
  @$pb.TagNumber(4)
  $core.int get index => $_getIZ(3);
  @$pb.TagNumber(4)
  set index($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get tileId => $_getIZ(4);
  @$pb.TagNumber(5)
  set tileId($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTileId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTileId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get blocked => $_getBF(5);
  @$pb.TagNumber(6)
  set blocked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlocked() => $_clearField(6);
}

/// Something the player should be told, e.g. why gathering stopped.
class Notice extends $pb.GeneratedMessage {
  factory Notice({
    NoticeCode? code,
  }) {
    final result = Notice._();
    if (code != null) result.code = code;
    return result;
  }

  Notice._();

  factory Notice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notice()..mergeFromBuffer(data, registry);
  factory Notice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Notice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Notice.$_createMessage)
    ..aE<NoticeCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: NoticeCode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notice copyWith(void Function(Notice) updates) =>
      super.copyWith((message) => updates(message as Notice)) as Notice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Notice() / Notice.new instead')
  static Notice create() => Notice._();
  static $pb.GeneratedMessage $_createMessage() => Notice._();
  @$core.override
  Notice createEmptyInstance() => Notice._();
  @$core.pragma('dart2js:noInline')
  static Notice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notice>(Notice.$_createMessage);
  static Notice? _defaultInstance;

  @$pb.TagNumber(1)
  NoticeCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(NoticeCode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

/// Full state of the entities around the player. Entities missing from a
/// snapshot have left.
class Snapshot extends $pb.GeneratedMessage {
  factory Snapshot({
    $core.int? tick,
    $core.int? lastInputSeq,
    $core.Iterable<EntityState>? entities,
  }) {
    final result = Snapshot._();
    if (tick != null) result.tick = tick;
    if (lastInputSeq != null) result.lastInputSeq = lastInputSeq;
    if (entities != null) result.entities.addAll(entities);
    return result;
  }

  Snapshot._();

  factory Snapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Snapshot()..mergeFromBuffer(data, registry);
  factory Snapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Snapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Snapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Snapshot.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'tick', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'lastInputSeq',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<EntityState>(3, _omitFieldNames ? '' : 'entities',
        subBuilder: EntityState.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Snapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Snapshot copyWith(void Function(Snapshot) updates) =>
      super.copyWith((message) => updates(message as Snapshot)) as Snapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Snapshot() / Snapshot.new instead')
  static Snapshot create() => Snapshot._();
  static $pb.GeneratedMessage $_createMessage() => Snapshot._();
  @$core.override
  Snapshot createEmptyInstance() => Snapshot._();
  @$core.pragma('dart2js:noInline')
  static Snapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Snapshot>(Snapshot.$_createMessage);
  static Snapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tick => $_getIZ(0);
  @$pb.TagNumber(1)
  set tick($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTick() => $_has(0);
  @$pb.TagNumber(1)
  void clearTick() => $_clearField(1);

  /// Last MoveInput.seq the server applied for the receiving player.
  @$pb.TagNumber(2)
  $core.int get lastInputSeq => $_getIZ(1);
  @$pb.TagNumber(2)
  set lastInputSeq($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastInputSeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastInputSeq() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<EntityState> get entities => $_getList(2);
}

class EntityState extends $pb.GeneratedMessage {
  factory EntityState({
    $core.String? id,
    Vec2? position,
    Appearance? appearance,
  }) {
    final result = EntityState._();
    if (id != null) result.id = id;
    if (position != null) result.position = position;
    if (appearance != null) result.appearance = appearance;
    return result;
  }

  EntityState._();

  factory EntityState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityState()..mergeFromBuffer(data, registry);
  factory EntityState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: EntityState.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Vec2>(2, _omitFieldNames ? '' : 'position',
        subBuilder: Vec2.$_createMessage)
    ..aOM<Appearance>(3, _omitFieldNames ? '' : 'appearance',
        subBuilder: Appearance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityState copyWith(void Function(EntityState) updates) =>
      super.copyWith((message) => updates(message as EntityState))
          as EntityState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EntityState() / EntityState.new instead')
  static EntityState create() => EntityState._();
  static $pb.GeneratedMessage $_createMessage() => EntityState._();
  @$core.override
  EntityState createEmptyInstance() => EntityState._();
  @$core.pragma('dart2js:noInline')
  static EntityState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityState>(
          EntityState.$_createMessage);
  static EntityState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Vec2 get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(Vec2 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  Vec2 ensurePosition() => $_ensure(1);

  /// Set for every player who has created their character.
  @$pb.TagNumber(3)
  Appearance get appearance => $_getN(2);
  @$pb.TagNumber(3)
  set appearance(Appearance value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAppearance() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppearance() => $_clearField(3);
  @$pb.TagNumber(3)
  Appearance ensureAppearance() => $_ensure(2);
}

class ChunkData extends $pb.GeneratedMessage {
  factory ChunkData({
    $0.Chunk? chunk,
  }) {
    final result = ChunkData._();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  ChunkData._();

  factory ChunkData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChunkData()..mergeFromBuffer(data, registry);
  factory ChunkData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChunkData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ChunkData.$_createMessage)
    ..aOM<$0.Chunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.Chunk.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkData copyWith(void Function(ChunkData) updates) =>
      super.copyWith((message) => updates(message as ChunkData)) as ChunkData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChunkData() / ChunkData.new instead')
  static ChunkData create() => ChunkData._();
  static $pb.GeneratedMessage $_createMessage() => ChunkData._();
  @$core.override
  ChunkData createEmptyInstance() => ChunkData._();
  @$core.pragma('dart2js:noInline')
  static ChunkData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkData>(ChunkData.$_createMessage);
  static ChunkData? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Chunk get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($0.Chunk value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Chunk ensureChunk() => $_ensure(0);
}

class Pong extends $pb.GeneratedMessage {
  factory Pong({
    $fixnum.Int64? clientTimeMs,
    $fixnum.Int64? serverTimeMs,
  }) {
    final result = Pong._();
    if (clientTimeMs != null) result.clientTimeMs = clientTimeMs;
    if (serverTimeMs != null) result.serverTimeMs = serverTimeMs;
    return result;
  }

  Pong._();

  factory Pong.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pong()..mergeFromBuffer(data, registry);
  factory Pong.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pong()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pong',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: Pong.$_createMessage)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'clientTimeMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'serverTimeMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pong clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pong copyWith(void Function(Pong) updates) =>
      super.copyWith((message) => updates(message as Pong)) as Pong;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Pong() / Pong.new instead')
  static Pong create() => Pong._();
  static $pb.GeneratedMessage $_createMessage() => Pong._();
  @$core.override
  Pong createEmptyInstance() => Pong._();
  @$core.pragma('dart2js:noInline')
  static Pong getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Pong>(Pong.$_createMessage);
  static Pong? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get clientTimeMs => $_getI64(0);
  @$pb.TagNumber(1)
  set clientTimeMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientTimeMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientTimeMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get serverTimeMs => $_getI64(1);
  @$pb.TagNumber(2)
  set serverTimeMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerTimeMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerTimeMs() => $_clearField(2);
}

class ServerError extends $pb.GeneratedMessage {
  factory ServerError({
    ErrorCode? code,
    $core.String? message,
  }) {
    final result = ServerError._();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  ServerError._();

  factory ServerError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerError()..mergeFromBuffer(data, registry);
  factory ServerError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerError()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'craftaria.v1'),
      createEmptyInstance: ServerError.$_createMessage)
    ..aE<ErrorCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: ErrorCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerError copyWith(void Function(ServerError) updates) =>
      super.copyWith((message) => updates(message as ServerError))
          as ServerError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerError() / ServerError.new instead')
  static ServerError create() => ServerError._();
  static $pb.GeneratedMessage $_createMessage() => ServerError._();
  @$core.override
  ServerError createEmptyInstance() => ServerError._();
  @$core.pragma('dart2js:noInline')
  static ServerError getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerError>(
          ServerError.$_createMessage);
  static ServerError? _defaultInstance;

  @$pb.TagNumber(1)
  ErrorCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(ErrorCode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
