// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorEntity _$ErrorEntityFromJson(Map<String, dynamic> json) => ErrorEntity(
      message: json['message'] as String?,
      code: (json['code'] as num?)?.toInt(),
      details: json['details'] as String?,
      validationErrors: json['validationErrors'],
    );

Map<String, dynamic> _$ErrorEntityToJson(ErrorEntity instance) =>
    <String, dynamic>{
      'message': instance.message,
      'details': instance.details,
      'validationErrors': instance.validationErrors,
      'code': instance.code,
    };
