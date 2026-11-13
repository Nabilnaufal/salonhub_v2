import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraOrderDetailController extends GetxController {
  final data = Get.find<MitraDataService>();

  late final String orderCode;

  MitraOrder? get order => data.findByCode(orderCode);

  @override
  void onInit() {
    final arguments = Get.arguments;
    orderCode = arguments is String
        ? arguments
        : (data.orders.isNotEmpty ? data.orders.first.id : '');
    super.onInit();
  }

  void acceptOrder() {
    _setStatus(MitraOrderStatus.menunggu);
    Get.snackbar(
      'Pesanan diterima',
      'Customer akan melihat status pesanannya menjadi "Menunggu".',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void startOrder() {
    _setStatus(MitraOrderStatus.diproses);
    Get.snackbar(
      'Layanan dimulai',
      'Status pesanan berubah menjadi "Diproses".',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void finishOrder() {
    _setStatus(MitraOrderStatus.selesai);
    Get.snackbar(
      'Pesanan selesai',
      'Terima kasih, pesanan sudah ditandai selesai.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> cancelOrder() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan pesanan?'),
        content: const Text(
          'Pesanan akan dibatalkan dan customer akan menerima '
          'pemberitahuan.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Kembali')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
            ),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _setStatus(MitraOrderStatus.dibatalkan);
    }
  }

  void openChat() {
    final currentOrder = order;
    if (currentOrder == null) {
      return;
    }
    Get.toNamed(
      Routes.MITRA_CHAT_ROOM,
      arguments: {
        'name': currentOrder.customerName,
        'image': currentOrder.customerImage,
      },
    );
  }

  void callCustomer() {
    final currentOrder = order;
    if (currentOrder == null) {
      return;
    }
    Get.snackbar(
      'Telepon customer',
      'Menghubungi ${currentOrder.customerPhone}...',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void printReceipt() {
    Get.snackbar(
      'Struk pesanan',
      'Struk ${order?.id} disiapkan untuk diunduh.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _setStatus(MitraOrderStatus status) {
    if (orderCode.isEmpty) {
      return;
    }
    data.updateOrderStatus(orderCode, status);
  }
}
