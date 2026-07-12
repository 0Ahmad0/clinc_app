import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'base_model.g.dart';

@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BaseModel<T> {
  BaseModel({
    required this.result,
    this.totalCount,
    this.message,
    this.error,
    this.status,
    this.meta,
  });

  @JsonKey(name: "data")
  final T? result;
  final MetaList? meta;
  final String? status;
  final String? message;
  final int? totalCount;
  final ErrorModel? error;

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic itemJson) fromJsonT,
  ) {
    Map<String, dynamic> finalizedJson = Map<String, dynamic>.from(json);

    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      var innerData = json['data'];

      if (innerData.containsKey('data')) {
        finalizedJson['data'] = innerData['data'];
        finalizedJson['meta'] = innerData['meta'] ?? json['meta'];
      }
    }

    if (finalizedJson['data'] == null ||
        (finalizedJson['data'] is! List && finalizedJson['data'] is! Map)) {
      finalizedJson['message'] =
          finalizedJson['message'] ?? finalizedJson['error']?['message'];
    }


    return _$BaseModelFromJson(finalizedJson, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return _$BaseModelToJson(this, toJsonT);
  }
}

class BaseModels<T> {
  List<T> list;

  BaseModels({required this.list});

  factory BaseModels.fromJson(
    dynamic json,
    T Function(dynamic itemJson) fromJsonT,
  ) {



    if (json is List) {
      return BaseModels<T>(list: json.map((e) => fromJsonT(e)).toList());
    }
    else if(json is Map && json.containsKey('items') && json['items'] is List) {


      return BaseModels<T>(list:[... json['items'].map((e) => fromJsonT(e)).toList()]);
    }
    else {
      return BaseModels<T>(list: []);
    }
  }

  Map<String, dynamic> toJson() => {
    'list': list.map((e) {
      if (e is Map) return e;
      try {
        return (e as dynamic).toJson();
      } catch (_) {
        return e;
      }
    }).toList(),
  };
}

extension BaseModelX<T> on BaseModel<T> {
  bool get isSuccess => status == 'success';
}
