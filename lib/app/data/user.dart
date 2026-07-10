import 'package:freezed_annotation/freezed_annotation.dart';
// import 'user.dart';


part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class UserModel with _$UserModel {
  const UserModel._();
  // @JsonSerializable(explicitToJson: true)
  const factory UserModel({
    int? id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'is_verified') bool? isVerified,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    @JsonKey(name: 'birth_day') DateTime? birthDay,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'account_status') String? accountStatus,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
    @JsonKey(name: 'personal_photo') String? personalPhoto,
    @JsonKey(name: 'is_online') bool? isOnline,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'google_id') String? googleId,
    @JsonKey(name: 'otp') int? otp,





  }) = _UserModel;

  factory UserModel.fromJson( Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  String get completeName => "${firstName ?? ''} ${lastName ?? ''}".trim();

  @override
  // TODO: implement accountStatus
  String? get accountStatus => throw UnimplementedError();

  @override
  // TODO: implement birthDay
  DateTime? get birthDay => throw UnimplementedError();

  @override
  // TODO: implement deletedAt
  DateTime? get deletedAt => throw UnimplementedError();

  @override
  // TODO: implement email
  String? get email => throw UnimplementedError();

  @override
  // TODO: implement emailVerifiedAt
  DateTime? get emailVerifiedAt => throw UnimplementedError();

  @override
  // TODO: implement firstName
  String? get firstName => throw UnimplementedError();

  @override
  // TODO: implement gender
  String? get gender => throw UnimplementedError();

  @override
  // TODO: implement id
  int? get id => throw UnimplementedError();

  @override
  // TODO: implement isOnline
  bool? get isOnline => throw UnimplementedError();

  @override
  // TODO: implement isVerified
  bool? get isVerified => throw UnimplementedError();

  @override
  // TODO: implement lastName
  String? get lastName => throw UnimplementedError();

  @override
  // TODO: implement lastSeen
  DateTime? get lastSeen => throw UnimplementedError();

  @override
  // TODO: implement personalPhoto
  String? get personalPhoto => throw UnimplementedError();

  @override
  // TODO: implement phone
  String? get phone => throw UnimplementedError();

  @override
  // TODO: implement profileImage
  String? get profileImage => throw UnimplementedError();

  @override
  // TODO: implement googleId
  String? get googleId => throw UnimplementedError();

  @override
  // TODO: implement otp
  int? get otp => throw UnimplementedError();
}


