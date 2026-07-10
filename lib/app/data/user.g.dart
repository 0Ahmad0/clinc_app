// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      isVerified: json['is_verified'] as bool?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      birthDay: json['birth_day'] == null
          ? null
          : DateTime.parse(json['birth_day'] as String),
      phone: json['phone'] as String?,
      accountStatus: json['account_status'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
      personalPhoto: json['personal_photo'] as String?,
      isOnline: json['is_online'] as bool?,
      profileImage: json['profile_image'] as String?,
      googleId: json['google_id'] as String?,
      otp: (json['otp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'account_status': instance.accountStatus,
      'birth_day': instance.birthDay?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'first_name': instance.firstName,
      'gender': instance.gender,
      'id': instance.id,
      'is_online': instance.isOnline,
      'is_verified': instance.isVerified,
      'last_name': instance.lastName,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'personal_photo': instance.personalPhoto,
      'phone': instance.phone,
      'profile_image': instance.profileImage,
      'google_id': instance.googleId,
      'otp': instance.otp,
    };
