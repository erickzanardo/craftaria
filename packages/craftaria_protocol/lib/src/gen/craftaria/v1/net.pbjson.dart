// This is a generated file - do not edit.
//
// Generated from craftaria/v1/net.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use noticeCodeDescriptor instead')
const NoticeCode$json = {
  '1': 'NoticeCode',
  '2': [
    {'1': 'NOTICE_CODE_UNSPECIFIED', '2': 0},
    {'1': 'NOTICE_CODE_NOTHING_TO_GATHER', '2': 1},
    {'1': 'NOTICE_CODE_OUT_OF_REACH', '2': 2},
    {'1': 'NOTICE_CODE_NO_TOOL', '2': 3},
    {'1': 'NOTICE_CODE_TOOL_TOO_WEAK', '2': 4},
    {'1': 'NOTICE_CODE_LEVEL_TOO_LOW', '2': 5},
    {'1': 'NOTICE_CODE_INVENTORY_FULL', '2': 6},
    {'1': 'NOTICE_CODE_DEPLETED', '2': 7},
  ],
};

/// Descriptor for `NoticeCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List noticeCodeDescriptor = $convert.base64Decode(
    'CgpOb3RpY2VDb2RlEhsKF05PVElDRV9DT0RFX1VOU1BFQ0lGSUVEEAASIQodTk9USUNFX0NPRE'
    'VfTk9USElOR19UT19HQVRIRVIQARIcChhOT1RJQ0VfQ09ERV9PVVRfT0ZfUkVBQ0gQAhIXChNO'
    'T1RJQ0VfQ09ERV9OT19UT09MEAMSHQoZTk9USUNFX0NPREVfVE9PTF9UT09fV0VBSxAEEh0KGU'
    '5PVElDRV9DT0RFX0xFVkVMX1RPT19MT1cQBRIeChpOT1RJQ0VfQ09ERV9JTlZFTlRPUllfRlVM'
    'TBAGEhgKFE5PVElDRV9DT0RFX0RFUExFVEVEEAc=');

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'ERROR_CODE_UNAUTHORIZED', '2': 1},
    {'1': 'ERROR_CODE_PROTOCOL_MISMATCH', '2': 2},
    {'1': 'ERROR_CODE_REPLACED', '2': 3},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEhsKF0VSUk9SX0NPREVfVU'
    '5BVVRIT1JJWkVEEAESIAocRVJST1JfQ09ERV9QUk9UT0NPTF9NSVNNQVRDSBACEhcKE0VSUk9S'
    'X0NPREVfUkVQTEFDRUQQAw==');

@$core.Deprecated('Use vec2Descriptor instead')
const Vec2$json = {
  '1': 'Vec2',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 17, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 17, '10': 'y'},
  ],
};

/// Descriptor for `Vec2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vec2Descriptor =
    $convert.base64Decode('CgRWZWMyEgwKAXgYASABKBFSAXgSDAoBeRgCIAEoEVIBeQ==');

@$core.Deprecated('Use clientMessageDescriptor instead')
const ClientMessage$json = {
  '1': 'ClientMessage',
  '2': [
    {
      '1': 'hello',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Hello',
      '9': 0,
      '10': 'hello'
    },
    {
      '1': 'move',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.MoveInput',
      '9': 0,
      '10': 'move'
    },
    {
      '1': 'ping',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Ping',
      '9': 0,
      '10': 'ping'
    },
    {
      '1': 'gather',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Gather',
      '9': 0,
      '10': 'gather'
    },
    {
      '1': 'cancel_action',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.CancelAction',
      '9': 0,
      '10': 'cancelAction'
    },
    {
      '1': 'equip',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.EquipItem',
      '9': 0,
      '10': 'equip'
    },
    {
      '1': 'debug',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.DebugCommand',
      '9': 0,
      '10': 'debug'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientMessageDescriptor = $convert.base64Decode(
    'Cg1DbGllbnRNZXNzYWdlEisKBWhlbGxvGAEgASgLMhMuY3JhZnRhcmlhLnYxLkhlbGxvSABSBW'
    'hlbGxvEi0KBG1vdmUYAiABKAsyFy5jcmFmdGFyaWEudjEuTW92ZUlucHV0SABSBG1vdmUSKAoE'
    'cGluZxgDIAEoCzISLmNyYWZ0YXJpYS52MS5QaW5nSABSBHBpbmcSLgoGZ2F0aGVyGAQgASgLMh'
    'QuY3JhZnRhcmlhLnYxLkdhdGhlckgAUgZnYXRoZXISQQoNY2FuY2VsX2FjdGlvbhgFIAEoCzIa'
    'LmNyYWZ0YXJpYS52MS5DYW5jZWxBY3Rpb25IAFIMY2FuY2VsQWN0aW9uEi8KBWVxdWlwGAYgAS'
    'gLMhcuY3JhZnRhcmlhLnYxLkVxdWlwSXRlbUgAUgVlcXVpcBIyCgVkZWJ1ZxgHIAEoCzIaLmNy'
    'YWZ0YXJpYS52MS5EZWJ1Z0NvbW1hbmRIAFIFZGVidWdCCQoHcGF5bG9hZA==');

@$core.Deprecated('Use helloDescriptor instead')
const Hello$json = {
  '1': 'Hello',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'protocol_version', '3': 2, '4': 1, '5': 13, '10': 'protocolVersion'},
  ],
};

/// Descriptor for `Hello`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloDescriptor = $convert.base64Decode(
    'CgVIZWxsbxIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SKQoQcHJvdG9jb2xfdmVyc2lvbhgCIAEoDV'
    'IPcHJvdG9jb2xWZXJzaW9u');

@$core.Deprecated('Use moveInputDescriptor instead')
const MoveInput$json = {
  '1': 'MoveInput',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'dx', '3': 2, '4': 1, '5': 17, '10': 'dx'},
    {'1': 'dy', '3': 3, '4': 1, '5': 17, '10': 'dy'},
  ],
};

/// Descriptor for `MoveInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveInputDescriptor = $convert.base64Decode(
    'CglNb3ZlSW5wdXQSEAoDc2VxGAEgASgNUgNzZXESDgoCZHgYAiABKBFSAmR4Eg4KAmR5GAMgAS'
    'gRUgJkeQ==');

@$core.Deprecated('Use pingDescriptor instead')
const Ping$json = {
  '1': 'Ping',
  '2': [
    {'1': 'client_time_ms', '3': 1, '4': 1, '5': 4, '10': 'clientTimeMs'},
  ],
};

/// Descriptor for `Ping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingDescriptor = $convert.base64Decode(
    'CgRQaW5nEiQKDmNsaWVudF90aW1lX21zGAEgASgEUgxjbGllbnRUaW1lTXM=');

@$core.Deprecated('Use gatherDescriptor instead')
const Gather$json = {
  '1': 'Gather',
  '2': [
    {'1': 'seq', '3': 1, '4': 1, '5': 13, '10': 'seq'},
    {'1': 'tile_x', '3': 2, '4': 1, '5': 17, '10': 'tileX'},
    {'1': 'tile_y', '3': 3, '4': 1, '5': 17, '10': 'tileY'},
  ],
};

/// Descriptor for `Gather`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gatherDescriptor = $convert.base64Decode(
    'CgZHYXRoZXISEAoDc2VxGAEgASgNUgNzZXESFQoGdGlsZV94GAIgASgRUgV0aWxlWBIVCgZ0aW'
    'xlX3kYAyABKBFSBXRpbGVZ');

@$core.Deprecated('Use cancelActionDescriptor instead')
const CancelAction$json = {
  '1': 'CancelAction',
};

/// Descriptor for `CancelAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelActionDescriptor =
    $convert.base64Decode('CgxDYW5jZWxBY3Rpb24=');

@$core.Deprecated('Use equipItemDescriptor instead')
const EquipItem$json = {
  '1': 'EquipItem',
  '2': [
    {'1': 'slot', '3': 1, '4': 1, '5': 13, '10': 'slot'},
  ],
};

/// Descriptor for `EquipItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List equipItemDescriptor =
    $convert.base64Decode('CglFcXVpcEl0ZW0SEgoEc2xvdBgBIAEoDVIEc2xvdA==');

@$core.Deprecated('Use debugCommandDescriptor instead')
const DebugCommand$json = {
  '1': 'DebugCommand',
  '2': [
    {
      '1': 'grant_item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.GrantItem',
      '9': 0,
      '10': 'grantItem'
    },
    {
      '1': 'grant_xp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.GrantXp',
      '9': 0,
      '10': 'grantXp'
    },
  ],
  '8': [
    {'1': 'command'},
  ],
};

/// Descriptor for `DebugCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List debugCommandDescriptor = $convert.base64Decode(
    'CgxEZWJ1Z0NvbW1hbmQSOAoKZ3JhbnRfaXRlbRgBIAEoCzIXLmNyYWZ0YXJpYS52MS5HcmFudE'
    'l0ZW1IAFIJZ3JhbnRJdGVtEjIKCGdyYW50X3hwGAIgASgLMhUuY3JhZnRhcmlhLnYxLkdyYW50'
    'WHBIAFIHZ3JhbnRYcEIJCgdjb21tYW5k');

@$core.Deprecated('Use grantItemDescriptor instead')
const GrantItem$json = {
  '1': 'GrantItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `GrantItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List grantItemDescriptor = $convert.base64Decode(
    'CglHcmFudEl0ZW0SFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhQKBWNvdW50GAIgASgNUgVjb3'
    'VudA==');

@$core.Deprecated('Use grantXpDescriptor instead')
const GrantXp$json = {
  '1': 'GrantXp',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'amount', '3': 2, '4': 1, '5': 13, '10': 'amount'},
  ],
};

/// Descriptor for `GrantXp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List grantXpDescriptor = $convert.base64Decode(
    'CgdHcmFudFhwEhkKCHNraWxsX2lkGAEgASgJUgdza2lsbElkEhYKBmFtb3VudBgCIAEoDVIGYW'
    '1vdW50');

@$core.Deprecated('Use serverMessageDescriptor instead')
const ServerMessage$json = {
  '1': 'ServerMessage',
  '2': [
    {
      '1': 'welcome',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Welcome',
      '9': 0,
      '10': 'welcome'
    },
    {
      '1': 'snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Snapshot',
      '9': 0,
      '10': 'snapshot'
    },
    {
      '1': 'chunk',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.ChunkData',
      '9': 0,
      '10': 'chunk'
    },
    {
      '1': 'pong',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Pong',
      '9': 0,
      '10': 'pong'
    },
    {
      '1': 'error',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.ServerError',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'inventory',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.InventoryUpdate',
      '9': 0,
      '10': 'inventory'
    },
    {
      '1': 'skill',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.SkillUpdate',
      '9': 0,
      '10': 'skill'
    },
    {
      '1': 'action',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.ActionState',
      '9': 0,
      '10': 'action'
    },
    {
      '1': 'tile',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.TileUpdate',
      '9': 0,
      '10': 'tile'
    },
    {
      '1': 'notice',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Notice',
      '9': 0,
      '10': 'notice'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ServerMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverMessageDescriptor = $convert.base64Decode(
    'Cg1TZXJ2ZXJNZXNzYWdlEjEKB3dlbGNvbWUYASABKAsyFS5jcmFmdGFyaWEudjEuV2VsY29tZU'
    'gAUgd3ZWxjb21lEjQKCHNuYXBzaG90GAIgASgLMhYuY3JhZnRhcmlhLnYxLlNuYXBzaG90SABS'
    'CHNuYXBzaG90Ei8KBWNodW5rGAMgASgLMhcuY3JhZnRhcmlhLnYxLkNodW5rRGF0YUgAUgVjaH'
    'VuaxIoCgRwb25nGAQgASgLMhIuY3JhZnRhcmlhLnYxLlBvbmdIAFIEcG9uZxIxCgVlcnJvchgF'
    'IAEoCzIZLmNyYWZ0YXJpYS52MS5TZXJ2ZXJFcnJvckgAUgVlcnJvchI9CglpbnZlbnRvcnkYBi'
    'ABKAsyHS5jcmFmdGFyaWEudjEuSW52ZW50b3J5VXBkYXRlSABSCWludmVudG9yeRIxCgVza2ls'
    'bBgHIAEoCzIZLmNyYWZ0YXJpYS52MS5Ta2lsbFVwZGF0ZUgAUgVza2lsbBIzCgZhY3Rpb24YCC'
    'ABKAsyGS5jcmFmdGFyaWEudjEuQWN0aW9uU3RhdGVIAFIGYWN0aW9uEi4KBHRpbGUYCSABKAsy'
    'GC5jcmFmdGFyaWEudjEuVGlsZVVwZGF0ZUgAUgR0aWxlEi4KBm5vdGljZRgKIAEoCzIULmNyYW'
    'Z0YXJpYS52MS5Ob3RpY2VIAFIGbm90aWNlQgkKB3BheWxvYWQ=');

@$core.Deprecated('Use welcomeDescriptor instead')
const Welcome$json = {
  '1': 'Welcome',
  '2': [
    {'1': 'player_id', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    {'1': 'tick_rate', '3': 2, '4': 1, '5': 13, '10': 'tickRate'},
    {
      '1': 'spawn',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Vec2',
      '10': 'spawn'
    },
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.ItemDefinition',
      '10': 'items'
    },
  ],
};

/// Descriptor for `Welcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List welcomeDescriptor = $convert.base64Decode(
    'CgdXZWxjb21lEhsKCXBsYXllcl9pZBgBIAEoCVIIcGxheWVySWQSGwoJdGlja19yYXRlGAIgAS'
    'gNUgh0aWNrUmF0ZRIoCgVzcGF3bhgDIAEoCzISLmNyYWZ0YXJpYS52MS5WZWMyUgVzcGF3bhIy'
    'CgVpdGVtcxgEIAMoCzIcLmNyYWZ0YXJpYS52MS5JdGVtRGVmaW5pdGlvblIFaXRlbXM=');

@$core.Deprecated('Use itemDefinitionDescriptor instead')
const ItemDefinition$json = {
  '1': 'ItemDefinition',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'max_stack', '3': 3, '4': 1, '5': 13, '10': 'maxStack'},
  ],
};

/// Descriptor for `ItemDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDefinitionDescriptor = $convert.base64Decode(
    'Cg5JdGVtRGVmaW5pdGlvbhIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIbCg'
    'ltYXhfc3RhY2sYAyABKA1SCG1heFN0YWNr');

@$core.Deprecated('Use inventoryUpdateDescriptor instead')
const InventoryUpdate$json = {
  '1': 'InventoryUpdate',
  '2': [
    {
      '1': 'slots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.ItemStack',
      '10': 'slots'
    },
    {'1': 'equipped', '3': 2, '4': 1, '5': 9, '10': 'equipped'},
  ],
};

/// Descriptor for `InventoryUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryUpdateDescriptor = $convert.base64Decode(
    'Cg9JbnZlbnRvcnlVcGRhdGUSLQoFc2xvdHMYASADKAsyFy5jcmFmdGFyaWEudjEuSXRlbVN0YW'
    'NrUgVzbG90cxIaCghlcXVpcHBlZBgCIAEoCVIIZXF1aXBwZWQ=');

@$core.Deprecated('Use itemStackDescriptor instead')
const ItemStack$json = {
  '1': 'ItemStack',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `ItemStack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemStackDescriptor = $convert.base64Decode(
    'CglJdGVtU3RhY2sSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEhQKBWNvdW50GAIgASgNUgVjb3'
    'VudA==');

@$core.Deprecated('Use skillUpdateDescriptor instead')
const SkillUpdate$json = {
  '1': 'SkillUpdate',
  '2': [
    {'1': 'skill_id', '3': 1, '4': 1, '5': 9, '10': 'skillId'},
    {'1': 'level', '3': 2, '4': 1, '5': 13, '10': 'level'},
    {'1': 'xp', '3': 3, '4': 1, '5': 4, '10': 'xp'},
    {'1': 'level_xp', '3': 4, '4': 1, '5': 4, '10': 'levelXp'},
    {'1': 'next_level_xp', '3': 5, '4': 1, '5': 4, '10': 'nextLevelXp'},
  ],
};

/// Descriptor for `SkillUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skillUpdateDescriptor = $convert.base64Decode(
    'CgtTa2lsbFVwZGF0ZRIZCghza2lsbF9pZBgBIAEoCVIHc2tpbGxJZBIUCgVsZXZlbBgCIAEoDV'
    'IFbGV2ZWwSDgoCeHAYAyABKARSAnhwEhkKCGxldmVsX3hwGAQgASgEUgdsZXZlbFhwEiIKDW5l'
    'eHRfbGV2ZWxfeHAYBSABKARSC25leHRMZXZlbFhw');

@$core.Deprecated('Use actionStateDescriptor instead')
const ActionState$json = {
  '1': 'ActionState',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'tile_x', '3': 2, '4': 1, '5': 17, '10': 'tileX'},
    {'1': 'tile_y', '3': 3, '4': 1, '5': 17, '10': 'tileY'},
    {'1': 'start_tick', '3': 4, '4': 1, '5': 13, '10': 'startTick'},
    {'1': 'duration_ticks', '3': 5, '4': 1, '5': 13, '10': 'durationTicks'},
  ],
};

/// Descriptor for `ActionState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionStateDescriptor = $convert.base64Decode(
    'CgtBY3Rpb25TdGF0ZRISCgRraW5kGAEgASgJUgRraW5kEhUKBnRpbGVfeBgCIAEoEVIFdGlsZV'
    'gSFQoGdGlsZV95GAMgASgRUgV0aWxlWRIdCgpzdGFydF90aWNrGAQgASgNUglzdGFydFRpY2sS'
    'JQoOZHVyYXRpb25fdGlja3MYBSABKA1SDWR1cmF0aW9uVGlja3M=');

@$core.Deprecated('Use tileUpdateDescriptor instead')
const TileUpdate$json = {
  '1': 'TileUpdate',
  '2': [
    {'1': 'cx', '3': 1, '4': 1, '5': 17, '10': 'cx'},
    {'1': 'cy', '3': 2, '4': 1, '5': 17, '10': 'cy'},
    {'1': 'layer', '3': 3, '4': 1, '5': 9, '10': 'layer'},
    {'1': 'index', '3': 4, '4': 1, '5': 13, '10': 'index'},
    {'1': 'tile_id', '3': 5, '4': 1, '5': 13, '10': 'tileId'},
    {'1': 'blocked', '3': 6, '4': 1, '5': 8, '10': 'blocked'},
  ],
};

/// Descriptor for `TileUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tileUpdateDescriptor = $convert.base64Decode(
    'CgpUaWxlVXBkYXRlEg4KAmN4GAEgASgRUgJjeBIOCgJjeRgCIAEoEVICY3kSFAoFbGF5ZXIYAy'
    'ABKAlSBWxheWVyEhQKBWluZGV4GAQgASgNUgVpbmRleBIXCgd0aWxlX2lkGAUgASgNUgZ0aWxl'
    'SWQSGAoHYmxvY2tlZBgGIAEoCFIHYmxvY2tlZA==');

@$core.Deprecated('Use noticeDescriptor instead')
const Notice$json = {
  '1': 'Notice',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.craftaria.v1.NoticeCode',
      '10': 'code'
    },
  ],
};

/// Descriptor for `Notice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noticeDescriptor = $convert.base64Decode(
    'CgZOb3RpY2USLAoEY29kZRgBIAEoDjIYLmNyYWZ0YXJpYS52MS5Ob3RpY2VDb2RlUgRjb2Rl');

@$core.Deprecated('Use snapshotDescriptor instead')
const Snapshot$json = {
  '1': 'Snapshot',
  '2': [
    {'1': 'tick', '3': 1, '4': 1, '5': 13, '10': 'tick'},
    {'1': 'last_input_seq', '3': 2, '4': 1, '5': 13, '10': 'lastInputSeq'},
    {
      '1': 'entities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.EntityState',
      '10': 'entities'
    },
  ],
};

/// Descriptor for `Snapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List snapshotDescriptor = $convert.base64Decode(
    'CghTbmFwc2hvdBISCgR0aWNrGAEgASgNUgR0aWNrEiQKDmxhc3RfaW5wdXRfc2VxGAIgASgNUg'
    'xsYXN0SW5wdXRTZXESNQoIZW50aXRpZXMYAyADKAsyGS5jcmFmdGFyaWEudjEuRW50aXR5U3Rh'
    'dGVSCGVudGl0aWVz');

@$core.Deprecated('Use entityStateDescriptor instead')
const EntityState$json = {
  '1': 'EntityState',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Vec2',
      '10': 'position'
    },
  ],
};

/// Descriptor for `EntityState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityStateDescriptor = $convert.base64Decode(
    'CgtFbnRpdHlTdGF0ZRIOCgJpZBgBIAEoCVICaWQSLgoIcG9zaXRpb24YAiABKAsyEi5jcmFmdG'
    'FyaWEudjEuVmVjMlIIcG9zaXRpb24=');

@$core.Deprecated('Use chunkDataDescriptor instead')
const ChunkData$json = {
  '1': 'ChunkData',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.craftaria.v1.Chunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `ChunkData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDataDescriptor = $convert.base64Decode(
    'CglDaHVua0RhdGESKQoFY2h1bmsYASABKAsyEy5jcmFmdGFyaWEudjEuQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use pongDescriptor instead')
const Pong$json = {
  '1': 'Pong',
  '2': [
    {'1': 'client_time_ms', '3': 1, '4': 1, '5': 4, '10': 'clientTimeMs'},
    {'1': 'server_time_ms', '3': 2, '4': 1, '5': 4, '10': 'serverTimeMs'},
  ],
};

/// Descriptor for `Pong`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pongDescriptor = $convert.base64Decode(
    'CgRQb25nEiQKDmNsaWVudF90aW1lX21zGAEgASgEUgxjbGllbnRUaW1lTXMSJAoOc2VydmVyX3'
    'RpbWVfbXMYAiABKARSDHNlcnZlclRpbWVNcw==');

@$core.Deprecated('Use serverErrorDescriptor instead')
const ServerError$json = {
  '1': 'ServerError',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.craftaria.v1.ErrorCode',
      '10': 'code'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ServerError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverErrorDescriptor = $convert.base64Decode(
    'CgtTZXJ2ZXJFcnJvchIrCgRjb2RlGAEgASgOMhcuY3JhZnRhcmlhLnYxLkVycm9yQ29kZVIEY2'
    '9kZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
