import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_orders/controllers/mitra_orders_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_empty_state.dart';
import 'package:salonhub_v2/app/widgets/mitra_order_card.dart';

class MitraOrdersView extends GetView<MitraOrdersController> {
  const MitraOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan',
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.primary900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Obx(
                          () => Text(
                            '${controller.data.orders.length} pesanan • '
                            '${controller.data.newOrdersCount} baru',
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.coolGray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blueGray200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: SvgPicture.asset(
                        'lib/assets/icons/setting-4.svg',
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary900,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.changeQuery,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.coolGray900,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama customer, kode, atau layanan...',
                    hintStyle: AppTextStyles.caption1.copyWith(
                      color: AppColors.blueGray400,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'lib/assets/icons/search-normal.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(color: AppColors.primary900),
                  ),
                ),
              ),
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
                      label: 'Semua',
                      count: controller.data.orders.length,
                      isSelected: controller.selectedStatus.value == null,
                      onTap: () => controller.selectStatus(null),
                    ),
                    for (final status in MitraOrderStatus.values) ...[
                      const SizedBox(width: 8),
                      _filterChip(
                        label: status.label,
                        count: controller.countForStatus(status),
                        isSelected: controller.selectedStatus.value == status,
                        color: status.color,
                        onTap: () => controller.selectStatus(status),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: const [
                      MitraEmptyState(
                        icon: Icons.receipt_long_rounded,
                        title: 'Belum ada pesanan',
                        description:
                            'Pesanan dengan filter ini belum tersedia. '
                            'Coba pilih status lain atau ubah kata kunci.',
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return MitraOrderCard(
                      order: order,
                      onTap: () => controller.openOrder(order),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = AppColors.blueGray200}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _filterChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    Color color = AppColors.primary900,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: isSelected ? color : AppColors.blueGray200),
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
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withValues(alpha: .22)
                    : AppColors.blueGray100,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.caption2.copyWith(
                  color: isSelected ? AppColors.white : AppColors.coolGray500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
