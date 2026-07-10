import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_entity.g.dart';

@JsonSerializable()
class ErrorEntity {

  String? message;
  String? details;
  dynamic validationErrors;
  int? code;

  ErrorEntity({required this.message
    ,this.code
    ,this.details
    ,this.validationErrors
  });

  factory ErrorEntity.fromJson(json) =>
      _$ErrorEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorEntityToJson(this);
}
