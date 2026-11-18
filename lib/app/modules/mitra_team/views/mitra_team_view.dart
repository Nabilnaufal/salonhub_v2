import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_team/controllers/mitra_team_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_empty_state.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraTeamView extends GetView<MitraTeamController> {
  const MitraTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddMember,
        backgroundColor: AppColors.primary900,
        foregroundColor: AppColors.white,
        icon: SvgPicture.asset(
          'lib/assets/icons/User.svg',
          width: 19,
          height: 19,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
        label: Text(
          'Tambah Barber',
          style: AppTextStyles.caption1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Obx(
                () => MitraPageHeader(
                  title: 'Tim Barber',
                  subtitle:
                      '${controller.data.team.length} barber • '
                      '${controller.activeCount} aktif',
                  onBack: Get.back,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSummary(),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _filterChip('Semua', 0),
                    const SizedBox(width: 8),
                    _filterChip('Aktif', 1),
                    const SizedBox(width: 8),
                    _filterChip('Nonaktif', 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final members = controller.filteredMembers;
                if (members.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: MitraEmptyState(
                      iconPath: 'lib/assets/icons/People Nearby.svg',
                      title: 'Belum ada barber',
                      description:
                          'Tambahkan anggota tim agar customer bisa memilih '
                          'barber saat booking.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: members.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _memberCard(members[index]);
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary900, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _summaryItem('${controller.data.team.length}', 'Total barber'),
          Container(
            width: 1,
            height: 34,
            color: AppColors.white.withValues(alpha: .16),
          ),
          _summaryItem('${controller.activeCount}', 'Aktif hari ini'),
          Container(
            width: 1,
            height: 34,
            color: AppColors.white.withValues(alpha: .16),
          ),
          _summaryItem(
            controller.averageRating.toStringAsFixed(1),
            'Rating tim',
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headline3.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption2.copyWith(color: AppColors.primary200),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int index) {
    final isSelected = controller.selectedFilter.value == index;

    return InkWell(
      onTap: () => controller.selectFilter(index),
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary900 : AppColors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.primary900 : AppColors.blueGray200,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption1.copyWith(
            color: isSelected ? AppColors.white : AppColors.coolGray600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _memberCard(MitraTeamMember member) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(member.image),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: member.isActive
                            ? AppColors.teal500
                            : AppColors.blueGray300,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/star-yellow.svg',
                          width: 13,
                          height: 13,
                          colorFilter: const ColorFilter.mode(
                            AppColors.secondary900,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          member.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'lib/assets/icons/Scissors.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            AppColors.coolGray400,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${member.todayBookings} hari ini',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 19,
                  color: AppColors.coolGray400,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.openEditMember(member);
                  } else {
                    controller.deleteMember(member);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit barber'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus barber'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.blueGray100),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/icons/Stopwatch.svg',
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  AppColors.coolGray400,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Shift ${member.shift}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray500,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                member.isActive ? 'Aktif' : 'Nonaktif',
                maxLines: 1,
                style: AppTextStyles.caption2.copyWith(
                  color: member.isActive
                      ? AppColors.teal700
                      : AppColors.coolGray400,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 40,
                height: 28,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: member.isActive,
                    onChanged: (_) => controller.toggleMember(member.id),
                    activeThumbColor: AppColors.primary900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
