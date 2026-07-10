// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel<T> _$BaseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseModel<T>(
  result: _$nullableGenericFromJson(json['data'], fromJsonT),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] == null
      ? null
      : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
  status: json['status'] as String?,
  meta: json['meta'] == null
      ? null
      : MetaList.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BaseModelToJson<T>(
  BaseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': _$nullableGenericToJson(instance.result, toJsonT),
  'meta': instance.meta?.toJson(),
  'status': instance.status,
  'message': instance.message,
  'totalCount': instance.totalCount,
  'error': instance.error?.toJson(),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
