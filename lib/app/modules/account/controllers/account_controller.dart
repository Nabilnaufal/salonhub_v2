import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final nameController = TextEditingController(text: 'Naufal Nabil');
  final emailController = TextEditingController(text: 'naufalnabil@gmail.com');
  final passwordController = TextEditingController(text: 'password');
  final isPasswordObscured = true.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void saveAccount() {
    Get.snackbar(
      'Akun',
      'Perubahan akun berhasil disimpan.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
