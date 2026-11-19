import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class RatingReviewController extends GetxController {
  final catalog = Get.find<CatalogService>();

  final selectedRating = 4.obs;
  final selectedTags = <String>{'Secara keseluruhan baik'}.obs;
  final reviewController = TextEditingController();
  final isBusy = false.obs;

  final tags = const [
    'Secara keseluruhan baik',
    'Pelayanan baik',
    'Memuaskan',
    'Nyaman',
    'Direkomendasikan',
    'Terjangkau',
    'Hasil sempurna',
    'Estimasi akurat',
  ];

  String bookingId = '';
  String shopId = '';
  String shopName = 'Barbershop';
  String location = '';
  String rating = '0.0';
  String shopImage = '';

  @override
  void onInit() {
    _readArguments();
    super.onInit();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  void selectRating(int rating) {
    selectedRating.value = rating;
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  Future<void> submitReview() async {
    if (shopId.isEmpty) {
      _showError('Data barbershop tidak ditemukan.');
      return;
    }

    isBusy.value = true;
    try {
      final tagsText = selectedTags.join(', ');
      final comment = [
        reviewController.text.trim(),
        if (tagsText.isNotEmpty) tagsText,
      ].where((part) => part.isNotEmpty).join('. ');

      await catalog.submitReview(
        bookingId: bookingId,
        shopId: shopId,
        rating: selectedRating.value,
        comment: comment,
      );

      Get.back();
      showAppSnack(
        'Ulasan terkirim',
        'Terima kasih sudah memberikan rating dan ulasan.',
      );
    } catch (_) {
      _showError('Ulasan belum tersimpan. Pastikan booking sudah selesai.');
    } finally {
      isBusy.value = false;
    }
  }

  void _showError(String message) {
    showAppSnack('Ulasan gagal', message, type: AppSnackType.error);
  }

  void _readArguments() {
    final arguments = Get.arguments;
    if (arguments is! Map) return;

    if (arguments['bookingId'] is String) {
      bookingId = arguments['bookingId'] as String;
    }
    if (arguments['shopId'] is String) {
      shopId = arguments['shopId'] as String;
    }
    if (arguments['shopName'] is String) {
      shopName = arguments['shopName'] as String;
    }
    if (arguments['location'] is String) {
      location = arguments['location'] as String;
    }
    if (arguments['rating'] is String) {
      rating = arguments['rating'] as String;
    }
    if (arguments['shopImage'] is String) {
      shopImage = arguments['shopImage'] as String;
    }
  }
}
