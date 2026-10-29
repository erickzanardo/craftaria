// This is a generated file - do not edit.
//
// Generated from craftaria/v1/map.proto.

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

@$core.Deprecated('Use chunkDescriptor instead')
const Chunk$json = {
  '1': 'Chunk',
  '2': [
    {'1': 'cx', '3': 1, '4': 1, '5': 5, '10': 'cx'},
    {'1': 'cy', '3': 2, '4': 1, '5': 5, '10': 'cy'},
    {
      '1': 'layers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.TileLayer',
      '10': 'layers'
    },
    {'1': 'collision', '3': 4, '4': 1, '5': 12, '10': 'collision'},
    {
      '1': 'entities',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.PlacedEntity',
      '10': 'entities'
    },
    {
      '1': 'tile_states',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.TileState',
      '10': 'tileStates'
    },
  ],
};

/// Descriptor for `Chunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDescriptor = $convert.base64Decode(
    'CgVDaHVuaxIOCgJjeBgBIAEoBVICY3gSDgoCY3kYAiABKAVSAmN5Ei8KBmxheWVycxgDIAMoCz'
    'IXLmNyYWZ0YXJpYS52MS5UaWxlTGF5ZXJSBmxheWVycxIcCgljb2xsaXNpb24YBCABKAxSCWNv'
    'bGxpc2lvbhI2CghlbnRpdGllcxgFIAMoCzIaLmNyYWZ0YXJpYS52MS5QbGFjZWRFbnRpdHlSCG'
    'VudGl0aWVzEjgKC3RpbGVfc3RhdGVzGAYgAygLMhcuY3JhZnRhcmlhLnYxLlRpbGVTdGF0ZVIK'
    'dGlsZVN0YXRlcw==');

@$core.Deprecated('Use tileLayerDescriptor instead')
const TileLayer$json = {
  '1': 'TileLayer',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'tiles', '3': 2, '4': 3, '5': 13, '10': 'tiles'},
    {'1': 'above_entities', '3': 3, '4': 1, '5': 8, '10': 'aboveEntities'},
  ],
};

/// Descriptor for `TileLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tileLayerDescriptor = $convert.base64Decode(
    'CglUaWxlTGF5ZXISEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgV0aWxlcxgCIAMoDVIFdGlsZXMSJQ'
    'oOYWJvdmVfZW50aXRpZXMYAyABKAhSDWFib3ZlRW50aXRpZXM=');

@$core.Deprecated('Use placedEntityDescriptor instead')
const PlacedEntity$json = {
  '1': 'PlacedEntity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'x', '3': 3, '4': 1, '5': 5, '10': 'x'},
    {'1': 'y', '3': 4, '4': 1, '5': 5, '10': 'y'},
    {
      '1': 'properties',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.PlacedEntity.PropertiesEntry',
      '10': 'properties'
    },
  ],
  '3': [PlacedEntity_PropertiesEntry$json],
};

@$core.Deprecated('Use placedEntityDescriptor instead')
const PlacedEntity_PropertiesEntry$json = {
  '1': 'PropertiesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PlacedEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placedEntityDescriptor = $convert.base64Decode(
    'CgxQbGFjZWRFbnRpdHkSDgoCaWQYASABKAlSAmlkEhIKBGtpbmQYAiABKAlSBGtpbmQSDAoBeB'
    'gDIAEoBVIBeBIMCgF5GAQgASgFUgF5EkoKCnByb3BlcnRpZXMYBSADKAsyKi5jcmFmdGFyaWEu'
    'djEuUGxhY2VkRW50aXR5LlByb3BlcnRpZXNFbnRyeVIKcHJvcGVydGllcxo9Cg9Qcm9wZXJ0aW'
    'VzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use tileStateDescriptor instead')
const TileState$json = {
  '1': 'TileState',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    {'1': 'layer', '3': 2, '4': 1, '5': 9, '10': 'layer'},
    {
      '1': 'properties',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.craftaria.v1.TileState.PropertiesEntry',
      '10': 'properties'
    },
  ],
  '3': [TileState_PropertiesEntry$json],
};

@$core.Deprecated('Use tileStateDescriptor instead')
const TileState_PropertiesEntry$json = {
  '1': 'PropertiesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TileState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tileStateDescriptor = $convert.base64Decode(
    'CglUaWxlU3RhdGUSFAoFaW5kZXgYASABKA1SBWluZGV4EhQKBWxheWVyGAIgASgJUgVsYXllch'
    'JHCgpwcm9wZXJ0aWVzGAMgAygLMicuY3JhZnRhcmlhLnYxLlRpbGVTdGF0ZS5Qcm9wZXJ0aWVz'
    'RW50cnlSCnByb3BlcnRpZXMaPQoPUHJvcGVydGllc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5Eh'
    'QKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
