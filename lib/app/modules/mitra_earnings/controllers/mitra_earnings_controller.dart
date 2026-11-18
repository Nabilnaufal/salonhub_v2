import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/data/receipt_download_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraEarningsController extends GetxController {
  final data = Get.find<MitraDataService>();
  final _receiptService = ReceiptDownloadService();

  /// 0 = hari ini, 1 = minggu ini, 2 = bulan ini.
  final selectedPeriod = 0.obs;

  @override
  void onInit() {
    data.load();
    super.onInit();
  }

  List<int> get weeklyRevenue {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index));
      return _paidOrders
          .where((order) {
            final at = order.scheduledAt;
            return at != null &&
                at.year == day.year &&
                at.month == day.month &&
                at.day == day.day;
          })
          .fold(0, (total, order) => total + order.totalPrice);
    });
  }

  List<String> get weeklyLabels {
    const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return names[day.weekday - 1];
    });
  }

  List<({String title, String subtitle, int amount, bool isIncome})>
  get transactions => _paidOrders
      .take(10)
      .map(
        (order) => (
          title: order.customerName,
          subtitle: order.serviceSummary,
          amount: order.totalPrice,
          isIncome: true,
        ),
      )
      .toList();

  List<MitraOrder> get _paidOrders => data.orders
      .where(
        (order) => order.isPaid && order.status != MitraOrderStatus.dibatalkan,
      )
      .toList();

  int get grossRevenue {
    final now = DateTime.now();
    switch (selectedPeriod.value) {
      case 1:
        return _paidOrders
            .where(
              (order) =>
                  order.scheduledAt != null &&
                  now.difference(order.scheduledAt!).inDays < 7,
            )
            .fold(0, (total, order) => total + order.totalPrice);
      case 2:
        return _paidOrders
            .where(
              (order) =>
                  order.scheduledAt != null &&
                  order.scheduledAt!.month == now.month &&
                  order.scheduledAt!.year == now.year,
            )
            .fold(0, (total, order) => total + order.totalPrice);
      default:
        return data.todayRevenue;
    }
  }

  int get platformFee => (grossRevenue * 0.05).round();

  int get netRevenue => grossRevenue - platformFee;

  int get transactionCount {
    switch (selectedPeriod.value) {
      case 1:
        return _paidOrders
            .where(
              (order) =>
                  order.scheduledAt != null &&
                  DateTime.now().difference(order.scheduledAt!).inDays < 7,
            )
            .length;
      case 2:
        return _paidOrders
            .where(
              (order) =>
                  order.scheduledAt != null &&
                  order.scheduledAt!.month == DateTime.now().month,
            )
            .length;
      default:
        return data.todayOrders.where((order) => order.isPaid).length;
    }
  }

  double get growthPercent => 0;

  String get periodLabel {
    switch (selectedPeriod.value) {
      case 1:
        return 'Minggu ini';
      case 2:
        return 'Bulan ini';
      default:
        return 'Hari ini';
    }
  }

  void selectPeriod(int index) {
    selectedPeriod.value = index;
  }

  Future<void> downloadReport() async {
    if (_paidOrders.isEmpty) {
      Get.snackbar(
        'Belum ada transaksi',
        'Laporan dibuat setelah ada pesanan lunas.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      final location = await _receiptService.downloadEarnings(
        shopName: data.shop.value.name,
        periodLabel: periodLabel,
        rows: _paidOrders
            .map(
              (order) => (
                code: order.id,
                date: order.dateLabel,
                customer: order.customerName,
                amount: order.totalPrice,
                paid: order.isPaid,
              ),
            )
            .toList(),
      );
      Get.snackbar(
        'Laporan tersimpan',
        'PDF laporan ${periodLabel.toLowerCase()} disimpan di $location.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'Unduh gagal',
        'Laporan belum dapat disimpan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
