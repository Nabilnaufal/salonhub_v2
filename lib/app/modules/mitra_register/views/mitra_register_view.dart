import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_register/controllers/mitra_register_controller.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraRegisterView extends GetView<MitraRegisterController> {
  const MitraRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MitraPageHeader(
                title: 'Daftar Barbershop',
                subtitle: 'Lengkapi data untuk bergabung sebagai mitra',
                onBack: controller.back,
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.blueGray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Informasi Barbershop'),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'Nama barbershop',
                      hintText: 'Contoh: Masterpiece Barbershop',
                      iconPath: 'lib/assets/icons/Shop.svg',
                      controller: controller.shopNameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Alamat lengkap',
                      hintText: 'Jl. Kaliurang KM 5, Sleman',
                      iconPath: 'lib/assets/icons/Map Point.svg',
                      controller: controller.addressController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel('Informasi Pemilik'),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'Nama pemilik',
                      hintText: 'Nama sesuai KTP',
                      iconPath: 'lib/assets/icons/User.svg',
                      controller: controller.ownerNameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email',
                      hintText: 'nama@email.com',
                      iconPath: 'lib/assets/icons/Vector.svg',
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Nomor WhatsApp',
                      hintText: '08xx xxxx xxxx',
                      iconPath: 'lib/assets/icons/Chat Round Unread.svg',
                      keyboardType: TextInputType.phone,
                      controller: controller.phoneController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel('Keamanan Akun'),
                    const SizedBox(height: 12),
                    Obx(
                      () => AppTextField(
                        label: 'Password',
                        hintText: 'Minimal 8 karakter',
                        iconPath: 'lib/assets/icons/Key Minimalistic.svg',
                        obscureText: controller.isPasswordObscured.value,
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordObscured.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppColors.primary900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => InkWell(
                  onTap: controller.toggleTerms,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: controller.agreeToTerms.value,
                          onChanged: (_) => controller.toggleTerms(),
                          activeColor: AppColors.primary900,
                          side: const BorderSide(color: AppColors.blueGray300),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Saya setuju dengan Syarat & Ketentuan serta '
                          'Kebijakan Privasi SalonHub Mitra.',
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.blueGray600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppPrimaryButton(
                label: 'Daftar Sekarang',
                onPressed: controller.submit,
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Proses verifikasi memakan waktu 1x24 jam kerja.',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.blueGray400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.headline5.copyWith(
        color: AppColors.coolGray900,
        fontSize: 14,
      ),
    );
  }
}
