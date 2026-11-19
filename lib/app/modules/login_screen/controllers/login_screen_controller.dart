import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreenController extends GetxController {
  final auth = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordObscured = true.obs;
  final isBusy = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void openForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  void openRegister() {
    Get.toNamed(Routes.REGISTER_SCREEN);
  }

  void openMitraLogin() {
    Get.toNamed(Routes.MITRA_LOGIN);
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
      Get.offAllNamed(
        profile?.isMitra == true ? Routes.MITRA_MAIN : Routes.HOME,
      );
    } on AuthException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Tidak dapat terhubung ke server. Coba lagi.');
    } finally {
      isBusy.value = false;
    }
  }

  void _showError(String message) {
    showAppSnack('Login gagal', message, type: AppSnackType.error);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
