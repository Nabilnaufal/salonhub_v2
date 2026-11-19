import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class SecurityController extends GetxController {
  final auth = Get.find<AuthService>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final isCurrentPasswordObscured = true.obs;
  final isNewPasswordObscured = true.obs;
  final isBusy = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordObscured.toggle();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordObscured.toggle();
  }

  Future<void> savePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    if (currentPassword.isEmpty || newPassword.length < 6) {
      _showError('Password baru minimal 6 karakter.');
      return;
    }

    final email = auth.profile.value?.email;
    if (email == null) {
      _showError('Sesi tidak valid, silakan login ulang.');
      return;
    }

    isBusy.value = true;
    try {
      // Verifikasi password lama sebelum mengganti.
      await auth.signIn(email: email, password: currentPassword);
      await auth.changePassword(newPassword);
      currentPasswordController.clear();
      newPasswordController.clear();
      showAppSnack('Keamanan', 'Kata sandi berhasil diperbarui.');
    } catch (_) {
      _showError('Password lama salah atau password baru ditolak.');
    } finally {
      isBusy.value = false;
    }
  }

  void _showError(String message) {
    showAppSnack('Keamanan', message, type: AppSnackType.error);
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
