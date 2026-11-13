import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraDashboardController extends GetxController {
  final data = Get.find<MitraDataService>();

  MitraShop get shop => data.shop.value;
  bool get isShopOpen => data.isShopOpen.value;
  List<MitraOrder> get recentOrders => data.orders.take(3).toList();
  List<MitraReview> get latestReviews => data.reviews.take(1).toList();

  List<int> get weeklyRevenue => const [
    850000,
    1200000,
    700000,
    1450000,
    980000,
    1650000,
    1250000,
  ];

  List<String> get weeklyLabels => const [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  void toggleShop() {
    data.toggleShop();
  }

  void openOrders() {
    Get.toNamed(Routes.MITRA_ORDERS);
  }

  void openServices() {
    Get.toNamed(Routes.MITRA_SERVICES);
  }

  void openTeam() {
    Get.toNamed(Routes.MITRA_TEAM);
  }

  void openSchedule() {
    Get.toNamed(Routes.MITRA_SCHEDULE);
  }

  void openReviews() {
    Get.toNamed(Routes.MITRA_REVIEWS);
  }

  void openEarnings() {
    Get.toNamed(Routes.MITRA_EARNINGS);
  }

  void openShopProfile() {
    Get.toNamed(Routes.MITRA_SHOP_PROFILE);
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
