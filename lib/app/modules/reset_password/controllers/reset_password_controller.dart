import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

class ResetPasswordController extends GetxController {
  final auth = Get.find<AuthService>();

  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final isBusy = false.obs;
  final isPasswordObscured = true.obs;

  String _email = '';

  String get otpCode => otpControllers.map((item) => item.text).join();

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Map && arguments['email'] is String) {
      _email = arguments['email'] as String;
    }
    super.onInit();
  }

  void onOtpChanged(int index) {
    if (otpControllers[index].text.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    }

    if (otpControllers[index].text.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (otpCode.length != 6) {
      _showError('Masukkan 6 digit kode.');
      return;
    }

    final password = passwordController.text;
    if (password.length < 6) {
      _showError('Password minimal 6 karakter.');
      return;
    }
    if (password != confirmController.text) {
      _showError('Konfirmasi password tidak sama.');
      return;
    }

    isBusy.value = true;
    try {
      await auth.verifyRecoveryOtp(email: _email, token: otpCode);
      await auth.updatePassword(password);
      final profile = await auth.loadProfile();
      Get.snackbar(
        'Password diperbarui',
        'Gunakan password baru untuk masuk berikutnya.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(
        profile?.isMitra == true ? Routes.MITRA_MAIN : Routes.HOME,
      );
    } catch (_) {
      _showError('Kode salah atau sudah kedaluwarsa.');
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> resend() async {
    if (_email.isEmpty) return;
    await auth.resetPassword(_email);
    Get.snackbar(
      'Kode dikirim ulang',
      'Cek kembali kotak masuk $_email.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Reset gagal',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFFF1F2),
      colorText: const Color(0xFF9F1239),
    );
  }

  @override
  void onClose() {
    for (final item in otpControllers) {
      item.dispose();
    }
    for (final item in otpFocusNodes) {
      item.dispose();
    }
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
