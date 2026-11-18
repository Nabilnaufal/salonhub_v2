import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final auth = Get.find<AuthService>();
  final emailController = TextEditingController();
  final isBusy = false.obs;

  Future<void> sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Email kosong',
        'Masukkan email yang terdaftar.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isBusy.value = true;
    try {
      await auth.resetPassword(email);
      Get.snackbar(
        'Email terkirim',
        'Cek tautan reset password di $email.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offNamed(Routes.LOGIN_SCREEN);
    } catch (_) {
      Get.snackbar(
        'Gagal mengirim',
        'Email tidak ditemukan atau server sedang sibuk.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isBusy.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
