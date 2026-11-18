import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class PaymentController extends GetxController {
  final catalog = Get.find<CatalogService>();

  String methodName = 'QRIS';
  String methodImage = 'lib/assets/icons/QRIS Logo - Black - zonalogo.com.svg';
  String bookingId = '';
  int totalPrice = 0;
  String appointmentDateLabel = '';
  String serviceName = '';
  int servicePrice = 0;
  int serviceFeePrice = 25000;
  String bookingCode = '';
  String shopName = '';
  bool isBusy = false;

  @override
  void onInit() {
    _readPaymentArguments();
    super.onInit();
  }

  bool get isQris => methodName.toUpperCase() == 'QRIS';

  String get paymentCode {
    switch (methodName.toUpperCase()) {
      case 'BCA':
        return '3901 1234 5678 9012';
      case 'MANDIRI':
        return '8808 1234 5678 9012';
      case 'BRI':
        return '2621 1234 5678 9012';
      case 'BNI':
        return '9881 1234 5678 9012';
      default:
        return 'QRIS-2026-0001';
    }
  }

  String formatRupiah(int amount) {
    final digits = amount.toString();
    final formatted = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        formatted.write('.');
      }
      formatted.write(digits[index]);
    }

    return 'Rp$formatted';
  }

  Future<void> markAsPaid() async {
    if (isBusy) return;
    isBusy = true;
    update();

    try {
      if (bookingId.isNotEmpty) {
        await catalog.markBookingPaid(bookingId, method: methodName);
      }
      Get.toNamed(
        Routes.INVOICE,
        arguments: {
          'appointmentDateLabel': appointmentDateLabel,
          'bookingCode': bookingCode,
          'paymentMethodName': methodName,
          'serviceName': serviceName,
          'servicePrice': servicePrice,
          'serviceFeePrice': serviceFeePrice,
          'totalPrice': totalPrice,
        },
      );
    } catch (_) {
      Get.snackbar(
        'Pembayaran gagal',
        'Status pembayaran belum tersimpan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isBusy = false;
      update();
    }
  }

  void _readPaymentArguments() {
    final arguments = Get.arguments;
    if (arguments is! Map) return;

    final name = arguments['methodName'];
    if (name is String) methodName = name;

    final image = arguments['methodImage'];
    if (image is String) methodImage = image;

    final id = arguments['bookingId'];
    if (id is String) bookingId = id;

    final code = arguments['bookingCode'];
    if (code is String) bookingCode = code;

    final shop = arguments['shopName'];
    if (shop is String) shopName = shop;

    final total = arguments['totalPrice'];
    if (total is int) totalPrice = total;

    final dateLabel = arguments['appointmentDateLabel'];
    if (dateLabel is String) appointmentDateLabel = dateLabel;

    final selectedServiceName = arguments['serviceName'];
    if (selectedServiceName is String) serviceName = selectedServiceName;

    final selectedServicePrice = arguments['servicePrice'];
    if (selectedServicePrice is int) servicePrice = selectedServicePrice;

    final feePrice = arguments['serviceFeePrice'];
    if (feePrice is int) serviceFeePrice = feePrice;
  }
}
