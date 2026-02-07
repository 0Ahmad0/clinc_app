import 'dart:io';

import 'package:clinc_app_t1/app/core/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ProfileController extends GetxController {
  final profileFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) selectedImage.value = File(image.path);
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // Validation Methods
  String? validateUsername(String? value) {
    return AppValidator.validateUsername(value);
  }

  String? validateFullName(String? value) {
    return AppValidator.validateName(value);
  }

  String? validateEmail(String? value) {
    return AppValidator.validateEmail(value);
  }

  String? validatePhone(String? value) {
    return AppValidator.validateSaudiPhone(value);
  }

  void editProfile() {
    if (profileFormKey.currentState?.validate() ?? false) {
      debugPrint('تسجيل المستخدم: ${usernameController.text}');
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
