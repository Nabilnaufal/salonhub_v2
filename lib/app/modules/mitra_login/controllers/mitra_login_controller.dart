import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

class MitraLoginController extends GetxController {
  final auth = Get.find<AuthService>();
  final data = Get.find<MitraDataService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final rememberMe = true.obs;
  final isBusy = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void toggleRememberMe() {
    rememberMe.toggle();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showError('Email dan password wajib diisi.');
      return;
    }

    isBusy.value = true;
    try {
      await auth.signIn(email: email, password: password);
      final profile = await auth.loadProfile();
      if (profile?.isMitra != true) {
        await auth.signOut();
        _showError('Akun ini bukan akun mitra.');
        return;
      }

      await data.load();
      Get.offAllNamed(Routes.MITRA_MAIN);
    } on AuthException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Tidak dapat terhubung ke server. Coba lagi.');
    } finally {
      isBusy.value = false;
    }
  }

  void loginAsDemo() {
    Get.toNamed(Routes.MITRA_REGISTER);
  }

  void openRegister() {
    Get.toNamed(Routes.MITRA_REGISTER);
  }

  void back() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
      return;
    }
    Get.offAllNamed(Routes.LOGIN_SCREEN);
  }

  void _showError(String message) {
    Get.snackbar(
      'Login mitra gagal',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFFF1F2),
      colorText: const Color(0xFF9F1239),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
