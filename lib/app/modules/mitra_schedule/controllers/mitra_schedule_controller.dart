import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraScheduleController extends GetxController {
  final data = Get.find<MitraDataService>();

  final selectedDay = 0.obs;

  static const _weekdayLabels = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  final DateTime baseDate = DateTime(2026, 1, 15);

  final slots = const [
    '08.00',
    '08.30',
    '09.00',
    '09.30',
    '10.00',
    '10.30',
    '11.00',
    '11.30',
    '12.00',
    '13.00',
    '14.00',
    '15.00',
    '16.00',
    '17.00',
    '18.00',
    '19.00',
  ];

  List<DateTime> get days =>
      List.generate(7, (index) => baseDate.add(Duration(days: index)));

  String weekdayOf(DateTime date) => _weekdayLabels[date.weekday - 1];

  List<MitraOrder> get selectedOrders =>
      selectedDay.value == 0 ? data.todayOrders : const [];

  int get bookedSlots => selectedOrders.length;

  int get availableSlots => slots.length - bookedSlots;

  MitraOrder? orderAt(String time) {
    for (final order in selectedOrders) {
      if (order.timeLabel.startsWith(time)) {
        return order;
      }
    }
    return null;
  }

  void selectDay(int index) {
    selectedDay.value = index;
  }

  void openOrder(MitraOrder order) {
    Get.toNamed(Routes.MITRA_ORDER_DETAIL, arguments: order.id);
  }

  void addWalkIn(String time) {
    Get.snackbar(
      'Tambah pesanan',
      'Slot $time siap diisi pesanan walk-in.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void editOpeningHours() {
    Get.snackbar(
      'Jam operasional',
      'Pengaturan jam buka toko akan tersedia di sini.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
