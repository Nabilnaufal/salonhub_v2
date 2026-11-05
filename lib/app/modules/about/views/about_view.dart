import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  static const _assetPath = 'lib/assets/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary900,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary900,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHero(),
              Expanded(child: _buildAboutPanel()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 278,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                '${_assetPath}barber_pattern_376x424.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Tentang',
                      style: AppTextStyles.headline4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Image.asset(
                  '${_assetPath}logo.png',
                  width: 112,
                  height: 88,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 4),
                Text(
                  'Salonhub',
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Salonhub',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Salonhub adalah solusi praktis untuk pemesanan layanan barber secara online. Aplikasi ini memudahkan kamu mencari, memilih, dan memesan layanan cukur dengan cepat.',
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray500,
              height: 1.35,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: Get.back,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary900,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Kembali',
                style: AppTextStyles.headline4.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
