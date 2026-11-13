import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/data/mitra_dummy.dart';

class MitraEarningsController extends GetxController {
  final data = Get.find<MitraDataService>();

  /// 0 = hari ini, 1 = minggu ini, 2 = bulan ini.
  final selectedPeriod = 0.obs;

  List<int> get weeklyRevenue => MitraDummy.weeklyRevenue;
  List<String> get weeklyLabels => MitraDummy.weeklyLabels;
  List<({String title, String subtitle, int amount, bool isIncome})>
  get transactions => MitraDummy.transactions;

  int get grossRevenue {
    switch (selectedPeriod.value) {
      case 1:
        return weeklyRevenue.fold(0, (sum, value) => sum + value);
      case 2:
        return 18500000;
      default:
        return data.todayRevenue;
    }
  }

  int get platformFee => (grossRevenue * 0.05).round();

  int get netRevenue => grossRevenue - platformFee;

  int get transactionCount {
    switch (selectedPeriod.value) {
      case 1:
        return 64;
      case 2:
        return 268;
      default:
        return data.todayOrders.length;
    }
  }

  double get growthPercent {
    switch (selectedPeriod.value) {
      case 1:
        return 18.2;
      case 2:
        return 9.6;
      default:
        return 12.4;
    }
  }

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

  void downloadReport() {
    Get.snackbar(
      'Unduh laporan',
      'Laporan pendapatan ${periodLabel.toLowerCase()} disiapkan '
          'dalam format PDF.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void openTransaction(String title) {
    Get.snackbar(
      'Detail transaksi',
      'Transaksi $title akan ditampilkan di halaman detail.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
