import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  final currentPasswordController = TextEditingController(text: 'password');
  final newPasswordController = TextEditingController();
  final isCurrentPasswordObscured = true.obs;
  final isNewPasswordObscured = true.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordObscured.toggle();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordObscured.toggle();
  }

  void savePassword() {
    Get.snackbar(
      'Keamanan',
      'Kata sandi berhasil diperbarui.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
