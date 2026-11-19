import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final auth = Get.find<AuthService>();
  final emailController = TextEditingController();
  final isBusy = false.obs;

  Future<void> sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showAppSnack(
        'Email kosong',
        'Masukkan email yang terdaftar.',
        type: AppSnackType.error,
      );
      return;
    }

    isBusy.value = true;
    try {
      await auth.resetPassword(email);
      showAppSnack(
        'Email terkirim',
        'Cek 6 digit kode yang kami kirim ke $email.',
      );
      Get.offNamed(Routes.RESET_PASSWORD, arguments: {'email': email});
    } catch (_) {
      showAppSnack(
        'Gagal mengirim',
        'Email tidak ditemukan atau server sedang sibuk.',

        type: AppSnackType.error,
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
