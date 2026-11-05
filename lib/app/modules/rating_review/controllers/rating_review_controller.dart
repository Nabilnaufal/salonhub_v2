import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingReviewController extends GetxController {
  final selectedRating = 4.obs;
  final selectedTags = <String>{'Secara keseluruhan baik'}.obs;
  final reviewController = TextEditingController();

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

  String shopName = 'Masterpiece Barbershop - Haircut styling';
  String location = 'Jogja Expo Centre (2 km)';
  String rating = '5.0  (24)';
  String shopImage = 'lib/assets/barbershop_haircut_2.jpg';

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

  void submitReview() {
    Get.snackbar(
      'Ulasan terkirim',
      'Terima kasih sudah memberikan rating dan ulasan.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _readArguments() {
    final arguments = Get.arguments;
    if (arguments is! Map) {
      return;
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
