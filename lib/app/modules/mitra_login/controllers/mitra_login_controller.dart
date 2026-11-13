import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraLoginController extends GetxController {
  final emailController = TextEditingController(text: 'mitra@salonhub.id');
  final passwordController = TextEditingController(text: 'mitra12345');

  final isPasswordObscured = true.obs;
  final rememberMe = true.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.toggle();
  }

  void toggleRememberMe() {
    rememberMe.toggle();
  }

  void login() {
    Get.offAllNamed(Routes.MITRA_MAIN);
  }

  void loginAsDemo() {
    Get.offAllNamed(Routes.MITRA_MAIN);
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
