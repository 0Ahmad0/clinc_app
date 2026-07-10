import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/user.dart';

class StorageService extends GetxService {
  static final StorageService _instance = StorageService._();

  static StorageService get instance => _instance;

  StorageService._();

  final GetStorage _box = GetStorage();

  // مفاتيح التخزين

  static const String _themeKey = 'isDarkMode';

  ///Keys
  static const String TOKEN = 'access_token';
  static const String LANG_CODE = 'lang_code';
  static const String REFRESH_TOKEN_EXPIRE = 'refresh_token_expire_in_seconds';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String LOGIN_TIME = 'login_time';
  static const String USER = 'user';
  static const String CLINIC = 'clinic';
  static const String PROFILE_COMPLETED = 'profile_completed';
  static const String ONBOARDING_SEEN = 'onboarding_seen';
  static const String PENDING_REGISTRATION_REFERENCE =
      'pending_registration_reference';
  static const String ROLE = 'role';
  static const String ACCOUNT_TYPE = 'account_type';
  static const String APP_NOTIFICATIONS = 'app_notifications';
  static const String EMAIL_NOTIFICATIONS = 'email_notifications';
  static const String SMS_NOTIFICATIONS = 'sms_notifications';
  static const String APPOINTMENT_REMINDERS = 'appointment_reminders';
  static const String PROMOTIONAL_NOTIFICATIONS = 'promotional_notifications';

  // دالة لتهيئة الخدمة (سيتم استدعاؤها تلقائياً)
  Future<StorageService> init() async {
    return this;
  }

  // --- دوال اللغة ---
  String get languageCode {
    // اقرأ اللغة، وإذا لم تكن موجودة، استخدم 'en' كافتراضي
    return _box.read(LANG_CODE) ?? 'en';
  }

  writeData(String key, dynamic value) async {
    await _box.write(key, value);
  }

  String? readData(String key) {
    String? result;
    if (_box.hasData(key)) {
      result = _box.read(key);
    }

    return result;
  }

  bool readBool(String key, {required bool fallback}) {
    return _box.read<bool>(key) ?? fallback;
  }

  Future<void> saveBool(String key, bool value) => _box.write(key, value);

  Future removeData(String key) async {
    if (_box.hasData(key)) {
      await _box.remove(key);
    }
  }

  Locale get locale => Locale(languageCode);

  void saveLanguage(String languageCode) {
    _box.write(LANG_CODE, languageCode);
  }

  // --- دوال الثيم ---
  bool get isDarkMode {
    // اقرأ الثيم، وافترض false (Light) كافتراضي
    return _box.read(_themeKey) ?? false;
  }

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void saveTheme(bool isDarkMode) {
    _box.write(_themeKey, isDarkMode);
  }

  Future setAccessToken(String? token) async {
    await writeData(TOKEN, token);
  }

  String getAccessToken() {
    return readData(TOKEN) ?? '';
  }

  Future cacheUserModel(Map<String, dynamic>? userInfo) async {
    await writeData(USER, jsonEncode(userInfo));
  }

  Future cacheClinic(Map<String, dynamic> clinic) async {
    await writeData(CLINIC, jsonEncode(clinic));
  }

  Map<String, dynamic>? getCachedClinic() {
    try {
      final value = _box.read(CLINIC);
      if (value == null) return null;
      return Map<String, dynamic>.from(jsonDecode(value.toString()) as Map);
    } catch (_) {
      return null;
    }
  }

  Future setProfileCompleted(bool value) async {
    await writeData(PROFILE_COMPLETED, value);
  }

  bool get isProfileCompleted => _box.read(PROFILE_COMPLETED) == true;

  Future setOnboardingSeen() async {
    await writeData(ONBOARDING_SEEN, true);
  }

  bool get hasSeenOnboarding => _box.read(ONBOARDING_SEEN) == true;

  Future setPendingRegistrationReference(String? value) async {
    await writeData(PENDING_REGISTRATION_REFERENCE, value);
  }

  String? getPendingRegistrationReference() {
    return _box.read(PENDING_REGISTRATION_REFERENCE)?.toString();
  }

  UserModel? getCachedUserModel() {
    try {
      final data = readData(USER);
      if (data == null || data.isEmpty || data == 'null') return null;

      final decoded = jsonDecode(data);
      if (decoded == null) return null;

      return UserModel.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<void> depose() async {
    await Future.wait(
      [
        removeData(TOKEN),
        removeData(LOGIN_TIME),
        removeData(REFRESH_TOKEN),
        removeData(REFRESH_TOKEN_EXPIRE),
        removeData(USER),
        removeData(CLINIC),
        removeData(PROFILE_COMPLETED),
        removeData(PENDING_REGISTRATION_REFERENCE),
        removeData(ROLE),
        removeData(ACCOUNT_TYPE),
      ]
      as Iterable<Future>,
    );
  }
}
