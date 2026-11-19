import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MitraRegisterController extends GetxController {
  final auth = Get.find<AuthService>();
  final data = Get.find<MitraDataService>();

  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final agreeToTerms = false.obs;
  final isBusy = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void toggleTerms() {
    agreeToTerms.toggle();
  }

  Future<void> submit() async {
    if (!agreeToTerms.value) {
      _showError('Centang persetujuan terlebih dahulu untuk melanjutkan.');
      return;
    }

    final shopName = shopNameController.text.trim();
    final ownerName = ownerNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final password = passwordController.text;

    if (shopName.isEmpty ||
        ownerName.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        password.length < 6) {
      _showError('Lengkapi semua data (password minimal 6 karakter).');
      return;
    }

    isBusy.value = true;
    try {
      await auth.signUpMitra(
        shopName: shopName,
        ownerName: ownerName,
        email: email,
        phone: phone,
        address: address,
        password: password,
      );

      if (auth.isLoggedIn) {
        await data.load();
        Get.offAllNamed(Routes.MITRA_MAIN);
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

  void back() {
    Get.back();
  }

  void _showError(String message) {
    showAppSnack('Syarat & ketentuan', message, type: AppSnackType.error);
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
