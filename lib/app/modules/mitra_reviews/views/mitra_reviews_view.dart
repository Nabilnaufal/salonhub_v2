import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_reviews/controllers/mitra_reviews_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_empty_state.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraReviewsView extends GetView<MitraReviewsController> {
  const MitraReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Obx(
                () => MitraPageHeader(
                  title: 'Ulasan & Rating',
                  subtitle: '${controller.data.reviews.length} ulasan masuk',
                  onBack: Get.back,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSummary(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 34,
              child: Obx(
                () => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _filterChip(
                      'Semua',
                      controller.data.reviews.length,
                      controller.selectedRating.value == null,
                      () => controller.selectRating(null),
                    ),
                    for (var rating = 5; rating >= 1; rating--) ...[
                      const SizedBox(width: 8),
                      _filterChip(
                        '$rating ★',
                        controller.countForRating(rating),
                        controller.selectedRating.value == rating,
                        () => controller.selectRating(rating),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final reviews = controller.filteredReviews;
                if (reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: MitraEmptyState(
                      iconPath: 'lib/assets/icons/Star.svg',
                      title: 'Belum ada ulasan',
                      description:
                          'Ulasan customer dengan filter ini belum tersedia.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: reviews.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _reviewCard(reviews[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.averageRating.toStringAsFixed(1),
                style: AppTextStyles.display2.copyWith(
                  color: AppColors.primary900,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  for (var index = 0; index < 5; index++)
                    Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: SvgPicture.asset(
                        'lib/assets/icons/star-yellow.svg',
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          index < controller.averageRating.round()
                              ? AppColors.secondary900
                              : AppColors.primary100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${controller.data.reviews.length} ulasan',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.coolGray500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 70, color: AppColors.blueGray100),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                for (var rating = 5; rating >= 1; rating--)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                          child: Text(
                            '$rating',
                            style: AppTextStyles.caption2.copyWith(
                              color: AppColors.coolGray500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: controller.data.reviews.isEmpty
                                  ? 0
                                  : controller.countForRating(rating) /
                                        controller.data.reviews.length,
                              minHeight: 5,
                              backgroundColor: AppColors.blueGray100,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.secondary900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
    String label,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary900 : AppColors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.primary900 : AppColors.blueGray200,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.caption1.copyWith(
                color: isSelected ? AppColors.white : AppColors.coolGray600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: AppTextStyles.caption2.copyWith(
                color: isSelected
                    ? AppColors.primary200
                    : AppColors.coolGray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(MitraReview review) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundImage: AssetImage(review.customerImage),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        for (var index = 0; index < 5; index++)
                          Padding(
                            padding: const EdgeInsets.only(right: 1),
                            child: SvgPicture.asset(
                              'lib/assets/icons/star-yellow.svg',
                              width: 13,
                              height: 13,
                              colorFilter: ColorFilter.mode(
                                index < review.rating.round()
                                    ? AppColors.secondary900
                                    : AppColors.primary100,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            review.dateLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption2.copyWith(
                              color: AppColors.coolGray400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: AppTextStyles.body3.copyWith(
              color: AppColors.coolGray600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          if (review.reply != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.blueGray50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blueGray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icons/Shop.svg',
                        width: 13,
                        height: 13,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary900,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Balasan kamu',
                        style: AppTextStyles.caption2.copyWith(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.reply!,
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.coolGray600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => controller.openReply(review),
              icon: review.reply == null
                  ? SvgPicture.asset(
                      'lib/assets/icons/Chat Round Unread.svg',
                      width: 15,
                      height: 15,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary900,
                        BlendMode.srcIn,
                      ),
                    )
                  : const Icon(
                      Icons.edit_outlined,
                      size: 15,
                      color: AppColors.primary900,
                    ),
              label: Text(
                review.reply == null ? 'Balas' : 'Ubah balasan',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
