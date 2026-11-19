import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/data/receipt_download_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class MitraOrderDetailController extends GetxController {
  final data = Get.find<MitraDataService>();

  final isBusy = false.obs;

  late final String orderCode;

  MitraOrder? get order => data.findByCode(orderCode);

  @override
  void onInit() {
    final arguments = Get.arguments;
    orderCode = arguments is String ? arguments : '';
    data.load();
    super.onInit();
  }

  Future<void> acceptOrder() async {
    await _setStatus(MitraOrderStatus.menunggu);
    showAppSnack(
      'Pesanan diterima',
      'Customer akan melihat status pesanannya menjadi "Menunggu".',
    );
  }

  Future<void> startOrder() async {
    await _setStatus(MitraOrderStatus.diproses);
    showAppSnack(
      'Layanan dimulai',
      'Status pesanan berubah menjadi "Diproses".',
    );
  }

  Future<void> finishOrder() async {
    await _setStatus(MitraOrderStatus.selesai);
    showAppSnack(
      'Pesanan selesai',
      'Terima kasih, pesanan sudah ditandai selesai.',
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
      await _setStatus(MitraOrderStatus.dibatalkan);
    }
  }

  void openChat() {
    Get.toNamed(Routes.MITRA_CHAT);
  }

  Future<void> callCustomer() async {
    final phone = order?.customerPhone ?? '';
    if (phone.isEmpty) {
      showAppSnack(
        'Nomor tidak tersedia',
        'Customer walk-in tidak punya nomor telepon.',

        type: AppSnackType.error,
      );
      return;
    }
    try {
      await callNumber(phone);
    } catch (_) {
      showAppSnack(
        'Gagal menelepon',
        'Aplikasi telepon tidak dapat dibuka.',
        type: AppSnackType.error,
      );
    }
  }

  final _receiptService = ReceiptDownloadService();

  Future<void> printReceipt() async {
    final currentOrder = order;
    if (currentOrder == null) return;

    try {
      final location = await _receiptService.download(
        ReceiptData(
          bookingCode: currentOrder.id,
          appointmentDateLabel:
              '${currentOrder.dateLabel} - ${currentOrder.timeLabel}',
          paymentMethodName: currentOrder.paymentMethod.isEmpty
              ? 'Cash'
              : currentOrder.paymentMethod,
          serviceName: currentOrder.serviceSummary,
          servicePrice: currentOrder.totalPrice,
          serviceFeePrice: 0,
          totalPrice: currentOrder.totalPrice,
          shopName: data.shop.value.name,
        ),
      );
      showAppSnack(
        'Struk tersimpan',
        'PDF pesanan ${currentOrder.id} disimpan di $location.',
      );
    } catch (_) {
      showAppSnack(
        'Unduh gagal',
        'Struk belum dapat disimpan. Coba lagi.',
        type: AppSnackType.error,
      );
    }
  }

  Future<void> _setStatus(MitraOrderStatus status) async {
    if (orderCode.isEmpty) return;
    isBusy.value = true;
    try {
      await data.updateOrderStatus(orderCode, status);
    } finally {
      isBusy.value = false;
    }
  }
}
