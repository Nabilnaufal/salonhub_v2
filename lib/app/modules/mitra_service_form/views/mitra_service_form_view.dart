import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_service_form/controllers/mitra_service_form_controller.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraServiceFormView extends GetView<MitraServiceFormController> {
  const MitraServiceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MitraPageHeader(
                title: controller.isEditing ? 'Edit Layanan' : 'Tambah Layanan',
                subtitle: 'Layanan akan tampil di halaman customer',
                onBack: controller.back,
              ),
              const SizedBox(height: 20),
              _buildPhotoPicker(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.blueGray200),
                ),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Nama layanan',
                      hintText: 'Contoh: Basic haircut',
                      iconPath: 'lib/assets/icons/Scissors.svg',
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Deskripsi',
                      hintText: 'Jelaskan singkat layanan ini',
                      iconPath: 'lib/assets/icons/Question Square.svg',
                      controller: controller.descriptionController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Harga (Rp)',
                            hintText: '20000',
                            iconPath: 'lib/assets/icons/Wallet Money.svg',
                            keyboardType: TextInputType.number,
                            controller: controller.priceController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Durasi (menit)',
                            hintText: '30',
                            iconPath: 'lib/assets/icons/Stopwatch.svg',
                            keyboardType: TextInputType.number,
                            controller: controller.durationController,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/Question Square.svg',
                      width: 17,
                      height: 17,
                      colorFilter: const ColorFilter.mode(
                        AppColors.blue700,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Layanan aktif akan langsung terlihat oleh customer '
                        'saat memilih barber.',
                        style: AppTextStyles.caption1.copyWith(
                          color: AppColors.blue800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppPrimaryButton(
                label: controller.isEditing
                    ? 'Simpan Perubahan'
                    : 'Tambah Layanan',
                onPressed: controller.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return InkWell(
      onTap: controller.pickImage,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.blueGray300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => controller.image.value.isEmpty
                  ? Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.primary50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 19,
                        color: AppColors.primary900,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppPhoto(
                        controller.image.value,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload foto layanan',
                  style: AppTextStyles.subHeadline3.copyWith(
                    color: AppColors.coolGray800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'JPG atau PNG, maksimal 2 MB',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
