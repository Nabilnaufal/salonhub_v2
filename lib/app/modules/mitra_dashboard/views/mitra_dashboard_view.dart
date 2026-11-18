import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_dashboard/controllers/mitra_dashboard_controller.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/widgets/mitra_order_card.dart';
import 'package:salonhub_v2/app/widgets/mitra_section_header.dart';
import 'package:salonhub_v2/app/widgets/mitra_stat_card.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';

class MitraDashboardView extends GetView<MitraDashboardController> {
  const MitraDashboardView({super.key, this.onOpenOrders, this.onOpenSchedule});

  final VoidCallback? onOpenOrders;
  final VoidCallback? onOpenSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildShopStatusCard(),
              const SizedBox(height: 18),
              const MitraSectionHeader(title: 'Ringkasan hari ini'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MitraStatCard(
                      label: 'Pendapatan hari ini',
                      value: formatRupiah(controller.data.todayRevenue),
                      iconPath: 'lib/assets/icons/Wallet Money.svg',
                      iconColor: AppColors.teal700,
                      iconBackground: AppColors.teal50,
                      footer: '+12% dari kemarin',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MitraStatCard(
                      label: 'Pesanan hari ini',
                      value: '${controller.data.todayOrders.length}',
                      iconPath: 'lib/assets/icons/Calendar Mark.svg',
                      iconColor: AppColors.blue700,
                      iconBackground: AppColors.blue50,
                      footer: '2 pesanan baru',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MitraStatCard(
                      label: 'Antrean aktif',
                      value: '${controller.data.activeOrdersCount}',
                      iconPath: 'lib/assets/icons/Stopwatch.svg',
                      iconColor: AppColors.secondary900,
                      iconBackground: AppColors.secondary50,
                      footer: 'Perlu diproses',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MitraStatCard(
                      label: 'Rating toko',
                      value: controller.shop.rating.toStringAsFixed(1),
                      iconPath: 'lib/assets/icons/star-yellow.svg',
                      iconColor: AppColors.yellow700,
                      iconBackground: AppColors.yellow50,
                      footer: '${controller.shop.reviewCount} ulasan',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildRevenueCard(),
              const SizedBox(height: 18),
              const MitraSectionHeader(title: 'Akses cepat'),
              const SizedBox(height: 10),
              _buildQuickActions(context),
              const SizedBox(height: 18),
              MitraSectionHeader(
                title: 'Pesanan terbaru',
                actionLabel: 'Lihat semua',
                onAction: () {
                  if (onOpenOrders != null) {
                    onOpenOrders!();
                  } else {
                    controller.openOrders();
                  }
                },
              ),
              const SizedBox(height: 10),
              ...controller.recentOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MitraOrderCard(
                    order: order,
                    onTap: () => Get.toNamed(
                      Routes.MITRA_ORDER_DETAIL,
                      arguments: order.id,
                    ),
                  ),
                ),
              ),
              if (controller.latestReviews.isNotEmpty) ...[
                const SizedBox(height: 8),
                const MitraSectionHeader(title: 'Ulasan terbaru'),
                const SizedBox(height: 10),
                _buildLatestReview(controller.latestReviews.first),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.blueGray900.withValues(alpha: .08),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppPhoto(controller.shop.image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat pagi,',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.coolGray500,
                ),
              ),
              Text(
                controller.shop.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.coolGray900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        _headerIcon(
          iconPath: 'Chat Round Unread.svg',
          onTap: controller.openChat,
          badge: 3,
        ),
        const SizedBox(width: 8),
        _headerIcon(
          icon: Icons.notifications_none_rounded,
          onTap: controller.openNotifications,
          badge: controller.data.newOrdersCount,
        ),
      ],
    );
  }

  Widget _headerIcon({
    IconData? icon,
    String? iconPath,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blueGray200),
            ),
            child: Center(
              child: iconPath != null
                  ? SvgPicture.asset(
                      'lib/assets/icons/$iconPath',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary900,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(icon!, size: 20, color: AppColors.primary900),
            ),
          ),
          if (badge > 0)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.red600,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: AppColors.white, width: 1.5),
                ),
                child: Text(
                  '$badge',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShopStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary900, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: .22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'lib/assets/icons/Shop.svg',
                colorFilter: ColorFilter.mode(
                  controller.isShopOpen
                      ? AppColors.secondary300
                      : AppColors.red300,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: controller.isShopOpen
                            ? AppColors.teal400
                            : AppColors.red400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        controller.isShopOpen
                            ? 'Toko sedang buka'
                            : 'Toko sedang tutup',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.subHeadline3.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Jam operasional 09.00 - 20.00 WIB',
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.primary200,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: controller.isShopOpen,
            onChanged: (_) => controller.toggleShop(),
            activeThumbColor: AppColors.secondary900,
            activeTrackColor: AppColors.white.withValues(alpha: .85),
            inactiveThumbColor: AppColors.primary300,
            inactiveTrackColor: AppColors.primary800,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    final values = controller.weeklyRevenue;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final total = values.fold(0, (sum, value) => sum + value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pendapatan mingguan',
                      style: AppTextStyles.headline5.copyWith(
                        color: AppColors.coolGray900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatRupiah(total),
                      style: AppTextStyles.headline3.copyWith(
                        color: AppColors.primary900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/Square Arrow Right Up.svg',
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        AppColors.teal700,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '+18%',
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.teal700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 104,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: 18 + (values[index] / maxValue) * 58,
                          decoration: BoxDecoration(
                            color: index == values.length - 1
                                ? AppColors.primary900
                                : AppColors.primary100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          controller.weeklyLabels[index],
                          style: AppTextStyles.caption2.copyWith(
                            color: index == values.length - 1
                                ? AppColors.primary900
                                : AppColors.coolGray400,
                            fontWeight: index == values.length - 1
                                ? FontWeight.w700
                                : FontWeight.w500,
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

  Widget _buildQuickActions(BuildContext context) {
    final items =
        <
          ({
            String label,
            String icon,
            Color color,
            Color background,
            VoidCallback action,
          })
        >[
          (
            label: 'Layanan',
            icon: 'lib/assets/icons/Scissors.svg',
            color: AppColors.primary900,
            background: AppColors.primary50,
            action: controller.openServices,
          ),
          (
            label: 'Tim Barber',
            icon: 'lib/assets/icons/User.svg',
            color: AppColors.blue700,
            background: AppColors.blue50,
            action: controller.openTeam,
          ),
          (
            label: 'Jadwal',
            icon: 'lib/assets/icons/Calendar.svg',
            color: AppColors.teal700,
            background: AppColors.teal50,
            action: () {
              if (onOpenSchedule != null) {
                onOpenSchedule!();
              } else {
                controller.openSchedule();
              }
            },
          ),
          (
            label: 'Ulasan',
            icon: 'lib/assets/icons/star-yellow.svg',
            color: AppColors.yellow700,
            background: AppColors.yellow50,
            action: controller.openReviews,
          ),
          (
            label: 'Pendapatan',
            icon: 'lib/assets/icons/Wallet Money.svg',
            color: AppColors.secondary900,
            background: AppColors.secondary50,
            action: controller.openEarnings,
          ),
          (
            label: 'Profil Toko',
            icon: 'lib/assets/icons/Shop.svg',
            color: AppColors.accent900,
            background: AppColors.accent50,
            action: controller.openShopProfile,
          ),
        ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 24) / 3;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: InkWell(
                    onTap: item.action,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.blueGray200),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              item.icon,
                              colorFilter: ColorFilter.mode(
                                item.color,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.coolGray800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildLatestReview(MitraReview review) {
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
                radius: 18,
                backgroundImage: AssetImage(review.customerImage),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 1),
                            child: SvgPicture.asset(
                              'lib/assets/icons/star-yellow.svg',
                              width: 13,
                              height: 13,
                              colorFilter: ColorFilter.mode(
                                i < review.rating.round()
                                    ? AppColors.secondary900
                                    : AppColors.primary100,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Text(
                          review.dateLabel,
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.openReviews,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Balas',
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body3.copyWith(
              color: AppColors.coolGray600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
