import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

class ProfileController extends GetxController {
  final auth = Get.find<AuthService>();

  final notificationsEnabled = true.obs;

  String get displayName => auth.profile.value?.fullName ?? 'Pengguna';
  String get email => auth.profile.value?.email ?? '';
  String get avatarUrl => auth.profile.value?.avatarUrl ?? '';

  @override
  void onInit() {
    notificationsEnabled.value =
        auth.profile.value?.notificationsEnabled ?? true;
    super.onInit();
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    try {
      await auth.setNotifications(value);
    } catch (_) {
      // Biarkan nilai lokal; pengaturan bisa dicoba lagi nanti.
    }
  }

  void openAccount() {
    Get.toNamed(Routes.ACCOUNT);
  }

  void openSecurity() {
    Get.toNamed(Routes.SECURITY);
  }

  void openHelp() {
    Get.toNamed(Routes.HELP);
  }

  void openAbout() {
    Get.toNamed(Routes.ABOUT);
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu dapat masuk kembali kapan saja.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await auth.signOut();
    } catch (_) {
      // Sesi lokal tetap dihapus walau panggilan server gagal.
    }
    Get.offAllNamed(Routes.LOGIN_SCREEN);
  }

  void changeNavigation(int index) {
    switch (index) {
      case 0:
        Get.offNamed(Routes.HOME);
      case 1:
        Get.offNamed(Routes.ORDERS);
      case 2:
        Get.offNamed(Routes.CHAT);
    }
  }
}
