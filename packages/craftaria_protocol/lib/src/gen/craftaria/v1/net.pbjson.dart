// This is a generated file - do not edit.
//
// Generated from craftaria/v1/net.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientMessageDescriptor = $convert.base64Decode(
    'Cg1DbGllbnRNZXNzYWdlEisKBWhlbGxvGAEgASgLMhMuY3JhZnRhcmlhLnYxLkhlbGxvSABSBW'
    'hlbGxvEi0KBG1vdmUYAiABKAsyFy5jcmFmdGFyaWEudjEuTW92ZUlucHV0SABSBG1vdmUSKAoE'
    'cGluZxgDIAEoCzISLmNyYWZ0YXJpYS52MS5QaW5nSABSBHBpbmdCCQoHcGF5bG9hZA==');

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
    'IAEoCzIZLmNyYWZ0YXJpYS52MS5TZXJ2ZXJFcnJvckgAUgVlcnJvckIJCgdwYXlsb2Fk');

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
  ],
};

/// Descriptor for `Welcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List welcomeDescriptor = $convert.base64Decode(
    'CgdXZWxjb21lEhsKCXBsYXllcl9pZBgBIAEoCVIIcGxheWVySWQSGwoJdGlja19yYXRlGAIgAS'
    'gNUgh0aWNrUmF0ZRIoCgVzcGF3bhgDIAEoCzISLmNyYWZ0YXJpYS52MS5WZWMyUgVzcGF3bg==');

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
