import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreenController extends GetxController {
  final auth = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCreatePasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;
  final isBusy = false.obs;

  void toggleCreatePasswordVisibility() {
    isCreatePasswordObscured.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.toggle();
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showError('Semua data wajib diisi.');
      return;
    }

    if (password != confirmPasswordController.text) {
      _showError('Konfirmasi password tidak sama.');
      return;
    }

    if (password.length < 6) {
      _showError('Password minimal 6 karakter.');
      return;
    }

    isBusy.value = true;
    try {
      await auth.signUpCustomer(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (auth.isLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.toNamed(Routes.OTP_SCREEN, arguments: {'email': email});
      }
    } on AuthException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Pendaftaran gagal. Coba lagi.');
    } finally {
      isBusy.value = false;
    }
  }

  void openLogin() {
    Get.toNamed(Routes.LOGIN_SCREEN);
  }

  void _showError(String message) {
    showAppSnack('Pendaftaran gagal', message, type: AppSnackType.error);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
