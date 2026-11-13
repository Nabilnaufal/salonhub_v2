import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraProfileController extends GetxController {
  final data = Get.find<MitraDataService>();

  void openShopProfile() {
    Get.toNamed(Routes.MITRA_SHOP_PROFILE);
  }

  void openServices() {
    Get.toNamed(Routes.MITRA_SERVICES);
  }

  void openTeam() {
    Get.toNamed(Routes.MITRA_TEAM);
  }

  void openReviews() {
    Get.toNamed(Routes.MITRA_REVIEWS);
  }

  void openEarnings() {
    Get.toNamed(Routes.MITRA_EARNINGS);
  }

  void openSettings() {
    Get.toNamed(Routes.MITRA_SETTINGS);
  }

  void openChat() {
    Get.toNamed(Routes.MITRA_CHAT);
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Keluar dari akun mitra?'),
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

    if (confirmed == true) {
      Get.offAllNamed(Routes.MITRA_LOGIN);
    }
  }
}
