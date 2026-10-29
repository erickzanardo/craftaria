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

import 'package:protobuf/protobuf.dart' as $pb;

class NoticeCode extends $pb.ProtobufEnum {
  static const NoticeCode NOTICE_CODE_UNSPECIFIED =
      NoticeCode._(0, _omitEnumNames ? '' : 'NOTICE_CODE_UNSPECIFIED');
  static const NoticeCode NOTICE_CODE_NOTHING_TO_GATHER =
      NoticeCode._(1, _omitEnumNames ? '' : 'NOTICE_CODE_NOTHING_TO_GATHER');
  static const NoticeCode NOTICE_CODE_OUT_OF_REACH =
      NoticeCode._(2, _omitEnumNames ? '' : 'NOTICE_CODE_OUT_OF_REACH');
  static const NoticeCode NOTICE_CODE_NO_TOOL =
      NoticeCode._(3, _omitEnumNames ? '' : 'NOTICE_CODE_NO_TOOL');
  static const NoticeCode NOTICE_CODE_TOOL_TOO_WEAK =
      NoticeCode._(4, _omitEnumNames ? '' : 'NOTICE_CODE_TOOL_TOO_WEAK');
  static const NoticeCode NOTICE_CODE_LEVEL_TOO_LOW =
      NoticeCode._(5, _omitEnumNames ? '' : 'NOTICE_CODE_LEVEL_TOO_LOW');
  static const NoticeCode NOTICE_CODE_INVENTORY_FULL =
      NoticeCode._(6, _omitEnumNames ? '' : 'NOTICE_CODE_INVENTORY_FULL');
  static const NoticeCode NOTICE_CODE_DEPLETED =
      NoticeCode._(7, _omitEnumNames ? '' : 'NOTICE_CODE_DEPLETED');

  static const $core.List<NoticeCode> values = <NoticeCode>[
    NOTICE_CODE_UNSPECIFIED,
    NOTICE_CODE_NOTHING_TO_GATHER,
    NOTICE_CODE_OUT_OF_REACH,
    NOTICE_CODE_NO_TOOL,
    NOTICE_CODE_TOOL_TOO_WEAK,
    NOTICE_CODE_LEVEL_TOO_LOW,
    NOTICE_CODE_INVENTORY_FULL,
    NOTICE_CODE_DEPLETED,
  ];

  static final $core.List<NoticeCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static NoticeCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NoticeCode._(super.value, super.name);
}

class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED =
      ErrorCode._(0, _omitEnumNames ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode ERROR_CODE_UNAUTHORIZED =
      ErrorCode._(1, _omitEnumNames ? '' : 'ERROR_CODE_UNAUTHORIZED');
  static const ErrorCode ERROR_CODE_PROTOCOL_MISMATCH =
      ErrorCode._(2, _omitEnumNames ? '' : 'ERROR_CODE_PROTOCOL_MISMATCH');
  static const ErrorCode ERROR_CODE_REPLACED =
      ErrorCode._(3, _omitEnumNames ? '' : 'ERROR_CODE_REPLACED');

  static const $core.List<ErrorCode> values = <ErrorCode>[
    ERROR_CODE_UNSPECIFIED,
    ERROR_CODE_UNAUTHORIZED,
    ERROR_CODE_PROTOCOL_MISMATCH,
    ERROR_CODE_REPLACED,
  ];

  static final $core.List<ErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ErrorCode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
