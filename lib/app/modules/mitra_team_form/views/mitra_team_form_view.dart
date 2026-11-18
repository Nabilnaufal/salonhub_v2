import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_team_form/controllers/mitra_team_form_controller.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraTeamFormView extends GetView<MitraTeamFormController> {
  const MitraTeamFormView({super.key});

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
                title: controller.isEditing ? 'Edit Barber' : 'Tambah Barber',
                subtitle: 'Data barber tampil di halaman customer',
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
                      label: 'Nama barber',
                      hintText: 'Contoh: Luther Hammes',
                      iconPath: 'lib/assets/icons/User.svg',
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Spesialisasi',
                      hintText: 'Contoh: Specialist Haircut',
                      iconPath: 'lib/assets/icons/Scissors.svg',
                      controller: controller.roleController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Shift kerja',
                      hintText: '09.00 - 17.00',
                      iconPath: 'lib/assets/icons/Stopwatch.svg',
                      controller: controller.shiftController,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 17,
                      color: AppColors.secondary900,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Barber yang aktif akan muncul di daftar tim dan bisa '
                        'dipilih customer saat booking.',
                        style: AppTextStyles.caption1.copyWith(
                          color: AppColors.yellow900,
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
                    : 'Tambah Barber',
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
                        Icons.add_a_photo_outlined,
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
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload foto barber',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.coolGray800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gunakan foto persegi agar rapi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption2.copyWith(
                      color: AppColors.coolGray400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
