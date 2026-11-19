import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class OtpScreenController extends GetxController {
  final auth = Get.find<AuthService>();

  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());
  final isBusy = false.obs;

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

  Future<void> sendCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = otpCode;
    if (code.length != 6) {
      _showError('Masukkan 6 digit kode.');
      return;
    }

    isBusy.value = true;
    try {
      await auth.verifySignupOtp(email: _email, token: code);
      final profile = await auth.loadProfile();
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
    await auth.resendSignupOtp(_email);
    showAppSnack('Kode dikirim ulang', 'Cek kembali kotak masuk $_email.');
  }

  void _showError(String message) {
    showAppSnack('Verifikasi gagal', message, type: AppSnackType.error);
  }

  @override
  void onClose() {
    for (final item in otpControllers) {
      item.dispose();
    }
    for (final item in otpFocusNodes) {
      item.dispose();
    }
    super.onClose();
  }
}
