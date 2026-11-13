import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraMainController extends GetxController {
  final data = Get.find<MitraDataService>();
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void openChat() {
    Get.toNamed(Routes.MITRA_CHAT);
  }

  void openNotifications() {
    Get.snackbar(
      'Notifikasi',
      'Tidak ada notifikasi baru saat ini.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
