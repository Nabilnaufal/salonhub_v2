import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_schedule/controllers/mitra_schedule_controller.dart';

class MitraScheduleView extends GetView<MitraScheduleController> {
  const MitraScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Obx(
          () => Column(
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
                            'Jadwal',
                            style: AppTextStyles.headline3.copyWith(
                              color: AppColors.primary900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Januari 2026 • Minggu ini',
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.coolGray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => controller.editOpeningHours(context),
                      icon: SvgPicture.asset(
                        'lib/assets/icons/setting-4.svg',
                        width: 15,
                        height: 15,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary900,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: const Text('Atur jam'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary900,
                        side: const BorderSide(color: AppColors.blueGray200),
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 36),
                        textStyle: AppTextStyles.caption1.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildDayStrip(),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSummaryCard(),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Timeline',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headline5.copyWith(
                          color: AppColors.coolGray900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _legend(AppColors.secondary900, 'Terisi'),
                    const SizedBox(width: 10),
                    _legend(AppColors.teal600, 'Selesai'),
                    const SizedBox(width: 10),
                    _legend(AppColors.blueGray300, 'Kosong'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: controller.slots.length,
                  itemBuilder: (context, index) {
                    final time = controller.slots[index];
                    return _TimelineSlot(
                      time: time,
                      order: controller.orderAt(time),
                      isLast: index == controller.slots.length - 1,
                      onOpen: controller.openOrder,
                      onAdd: () => controller.addWalkIn(time),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayStrip() {
    return SizedBox(
      height: 66,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = controller.days[index];
          final isSelected = controller.selectedDay.value == index;

          return InkWell(
            onTap: () => controller.selectDay(index),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary900 : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary900
                      : AppColors.blueGray200,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.weekdayOf(day),
                    style: AppTextStyles.caption2.copyWith(
                      color: isSelected
                          ? AppColors.primary200
                          : AppColors.coolGray400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: AppTextStyles.headline5.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.coolGray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.secondary900
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    final booked = controller.bookedSlots;
    final available = controller.availableSlots;
    final progress = booked / controller.slots.length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _summaryItem('Terisi', '$booked slot', AppColors.secondary900),
              Container(width: 1, height: 32, color: AppColors.blueGray100),
              _summaryItem('Tersedia', '$available slot', AppColors.teal700),
              Container(width: 1, height: 32, color: AppColors.blueGray100),
              _summaryItem(
                'Total',
                '${controller.slots.length} slot',
                AppColors.primary900,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.blueGray100,
              valueColor: const AlwaysStoppedAnimation(AppColors.secondary900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.headline5.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.coolGray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption2.copyWith(color: AppColors.coolGray500),
        ),
      ],
    );
  }
}

class _TimelineSlot extends StatelessWidget {
  const _TimelineSlot({
    required this.time,
    required this.order,
    required this.isLast,
    required this.onOpen,
    required this.onAdd,
  });

  final String time;
  final MitraOrder? order;
  final bool isLast;
  final void Function(MitraOrder order) onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final hasOrder = order != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              time,
              style: AppTextStyles.caption2.copyWith(
                color: hasOrder ? AppColors.coolGray800 : AppColors.coolGray400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 18),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: hasOrder ? AppColors.secondary900 : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasOrder
                      ? AppColors.secondary900
                      : AppColors.blueGray300,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(width: 1.5, height: 46, color: AppColors.blueGray200),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: hasOrder ? _buildOrderCard() : _buildEmptySlot(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard() {
    final currentOrder = order!;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onOpen(order!),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blueGray200),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 42,
                decoration: BoxDecoration(
                  color: currentOrder.status.color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentOrder.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentOrder.serviceSummary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/Scissors.svg',
                          width: 11,
                          height: 11,
                          colorFilter: const ColorFilter.mode(
                            AppColors.coolGray400,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            currentOrder.barberName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption2.copyWith(
                              color: AppColors.coolGray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.coolGray400,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentOrder.status.label,
                    style: AppTextStyles.caption2.copyWith(
                      color: currentOrder.status.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blueGray200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 16,
              color: AppColors.blueGray400,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Slot tersedia',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.coolGray400,
                ),
              ),
            ),
            Text(
              'Tambah',
              style: AppTextStyles.caption2.copyWith(
                color: AppColors.primary900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
