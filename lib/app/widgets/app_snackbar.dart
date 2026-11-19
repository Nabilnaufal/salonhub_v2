import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

enum AppSnackType { success, error, info }

/// Snackbar seragam: kartu putih solid yang muncul dari atas layar.
void showAppSnack(
  String title,
  String message, {
  AppSnackType type = AppSnackType.success,
}) {
  final accent = switch (type) {
    AppSnackType.success => const Color(0xFF15803D),
    AppSnackType.error => const Color(0xFF9F1239),
    AppSnackType.info => AppColors.primary900,
  };
  final icon = switch (type) {
    AppSnackType.success => Icons.check_circle_outline,
    AppSnackType.error => Icons.error_outline,
    AppSnackType.info => Icons.info_outline,
  };

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: AppColors.white,
    colorText: AppColors.coolGray900,
    borderRadius: 12,
    borderColor: accent.withValues(alpha: .25),
    borderWidth: 1,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .08),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ],
    icon: Icon(icon, color: accent, size: 22),
    maxWidth: 640,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    animationDuration: const Duration(milliseconds: 250),
    barBlur: 0,
    titleText: Text(
      title,
      style: AppTextStyles.subHeadline2.copyWith(
        color: AppColors.coolGray900,
        fontWeight: FontWeight.w700,
      ),
    ),
    messageText: Text(
      message,
      style: AppTextStyles.caption1.copyWith(
        color: AppColors.coolGray600,
        height: 1.35,
      ),
    ),
  );
}
