import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraDashboardController extends GetxController {
  final data = Get.find<MitraDataService>();

  @override
  void onInit() {
    data.load();
    super.onInit();
  }

  MitraShop get shop => data.shop.value;
  bool get isShopOpen => data.isShopOpen.value;
  List<MitraOrder> get recentOrders => data.orders.take(3).toList();
  List<MitraReview> get latestReviews => data.reviews.take(1).toList();

  List<int> get weeklyRevenue {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index));
      return data.orders
          .where((order) {
            final at = order.scheduledAt;
            return at != null &&
                at.year == day.year &&
                at.month == day.month &&
                at.day == day.day &&
                order.isPaid &&
                order.status != MitraOrderStatus.dibatalkan;
          })
          .fold(0, (total, order) => total + order.totalPrice);
    });
  }

  List<String> get weeklyLabels {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final now = DateTime.now();
    return List.generate(
      7,
      (index) => names[dayLabelIndex(now.subtract(Duration(days: 6 - index)))],
    );
  }

  int dayLabelIndex(DateTime date) => date.weekday - 1;

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

  Future<void> openChat() async {
    await Get.toNamed(Routes.MITRA_CHAT);
    await data.loadUnreadChats();
  }

  void openNotifications() {
    if (data.newOrdersCount > 0) {
      Get.toNamed(Routes.MITRA_ORDERS);
      return;
    }
    Get.snackbar(
      'Notifikasi',
      'Tidak ada notifikasi baru saat ini.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
