import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/rating_review_controller.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';

class RatingReviewView extends GetView<RatingReviewController> {
  const RatingReviewView({super.key});

  static const _iconPath = 'lib/assets/icons/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary900,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.teal50,
        body: Column(
          children: [
            _buildHero(),
            Expanded(child: _buildReviewPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.primary900),
          Opacity(
            opacity: .12,
            child: Image.asset(
              'lib/assets/barber_pattern_376x424.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _buildShopSummary(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 42, minHeight: 40),
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const SizedBox(width: 8),
          Text(
            'Rating & ulasan',
            style: AppTextStyles.headline4.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildShopSummary() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppPhoto(
            controller.shopImage,
            width: 76,
            height: 76,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.shopName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              _shopInfoRow(icon: 'Map Point.svg', text: controller.location),
              const SizedBox(height: 5),
              _shopInfoRow(icon: 'Star.svg', text: controller.rating),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shopInfoRow({required String icon, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          '$_iconPath$icon',
          width: 15,
          height: 15,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray200,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rating',
              style: AppTextStyles.body3.copyWith(color: AppColors.blueGray900),
            ),
            const SizedBox(height: 8),
            _buildRatingSelector(),
            const SizedBox(height: 18),
            Text(
              'Ulasan',
              style: AppTextStyles.body3.copyWith(color: AppColors.blueGray900),
            ),
            const SizedBox(height: 7),
            _buildReviewInput(),
            const SizedBox(height: 13),
            _buildReviewTags(),
            const SizedBox(height: 37),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Obx(
      () => Row(
        children: [
          ...List.generate(5, (index) {
            final isSelected = index < controller.selectedRating.value;

            return GestureDetector(
              onTap: () => controller.selectRating(index + 1),
              child: Padding(
                padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                child: SvgPicture.asset(
                  isSelected
                      ? '${_iconPath}star-yellow.svg'
                      : '${_iconPath}Star.svg',
                  width: 32,
                  height: 32,
                  colorFilter: isSelected
                      ? null
                      : const ColorFilter.mode(
                          AppColors.blueGray200,
                          BlendMode.srcIn,
                        ),
                ),
              ),
            );
          }),
          const SizedBox(width: 13),
          Text(
            '(${controller.selectedRating.value}.0)',
            style: AppTextStyles.body3.copyWith(color: AppColors.blueGray900),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewInput() {
    return Obx(
      () => SizedBox(
        height: 149,
        child: Stack(
          children: [
            TextField(
              controller: controller.reviewController,
              maxLines: 6,
              style: AppTextStyles.body3.copyWith(color: AppColors.blueGray900),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 44, 10, 10),
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blueGray300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blueGray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary900,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            if (controller.selectedTags.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                child: Wrap(
                  spacing: 6,
                  children: controller.selectedTags.map(_selectedTag).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _selectedTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blueGray400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => controller.toggleTag(tag),
            child: SvgPicture.asset(
              '${_iconPath}Close Square.svg',
              width: 13,
              height: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTags() {
    return Obx(
      () => Wrap(
        spacing: 17,
        runSpacing: 12,
        children: controller.tags.map((tag) {
          if (controller.selectedTags.contains(tag)) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: () => controller.toggleTag(tag),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                tag,
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: controller.submitReview,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(
          'Kirim',
          style: AppTextStyles.headline5.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
