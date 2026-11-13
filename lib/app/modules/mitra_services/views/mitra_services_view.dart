import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_services/controllers/mitra_services_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_empty_state.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraServicesView extends GetView<MitraServicesController> {
  const MitraServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddService,
        backgroundColor: AppColors.primary900,
        foregroundColor: AppColors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(
          'Tambah Layanan',
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
                  title: 'Layanan',
                  subtitle:
                      '${controller.data.services.length} layanan • '
                      '${controller.activeCount} aktif',
                  onBack: Get.back,
                ),
              ),
            ),
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
                final services = controller.filteredServices;
                if (services.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: MitraEmptyState(
                      iconPath: 'lib/assets/icons/Scissors.svg',
                      title: 'Belum ada layanan',
                      description:
                          'Tambahkan layanan pertama agar customer bisa '
                          'memilih saat booking.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _serviceCard(services[index]);
                  },
                );
              }),
            ),
          ],
        ),
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

  Widget _serviceCard(MitraService service) {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  service.image,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            formatRupiah(service.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.subHeadline3.copyWith(
                              color: AppColors.primary900,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '•',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray300,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          'lib/assets/icons/Stopwatch.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            AppColors.coolGray400,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${service.durationMinutes} menit',
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
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 19,
                  color: AppColors.coolGray400,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.openEditService(service);
                  } else {
                    controller.deleteService(service);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit layanan'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus layanan'),
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
                service.isActive
                    ? 'lib/assets/icons/material-symbols_check-circle-rounded.svg'
                    : 'lib/assets/icons/Close Square.svg',
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  service.isActive ? AppColors.teal600 : AppColors.coolGray400,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  service.isActive
                      ? 'Tampil di halaman customer'
                      : 'Disembunyikan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption2.copyWith(
                    color: service.isActive
                        ? AppColors.teal700
                        : AppColors.coolGray500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${service.totalBookings}x dipesan',
                maxLines: 1,
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.coolGray400,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 44,
                height: 30,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: service.isActive,
                    onChanged: (_) => controller.toggleService(service.id),
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
