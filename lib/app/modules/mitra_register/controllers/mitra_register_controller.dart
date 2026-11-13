import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraRegisterController extends GetxController {
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final agreeToTerms = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void toggleTerms() {
    agreeToTerms.toggle();
  }

  void submit() {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Syarat & ketentuan',
        'Centang persetujuan terlebih dahulu untuk melanjutkan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFFFF1F2),
        colorText: const Color(0xFF9F1239),
      );
      return;
    }

    Get.offAllNamed(Routes.MITRA_LOGIN);
    Get.snackbar(
      'Pendaftaran diterima',
      'Data barbershop kamu akan diverifikasi oleh tim SalonHub.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void back() {
    Get.back();
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
