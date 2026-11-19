import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';
import 'package:salonhub_v2/app/widgets/auth_page_layout.dart';
import 'package:salonhub_v2/app/widgets/phone_country_code_prefix.dart';

import '../controllers/register_screen_controller.dart';

class RegisterScreenView extends GetView<RegisterScreenController> {
  const RegisterScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: 'Register here',
      titleStyle: AppTextStyles.headline2,
      topPadding: 32,
      description: 'Silahkan Masukan Data Lengkapmu disini\nuntuk membuat akun',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Nama',
            hintText: 'nabil real',
            iconPath: 'lib/assets/icons/User.svg',
            controller: controller.nameController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Email',
            hintText: 'nabil@gmail.com',
            iconPath: 'lib/assets/icons/Vector.svg',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Nomor handphone',
            hintText: '89568000000',
            controller: controller.phoneController,
            prefixIcon: const PhoneCountryCodePrefix(),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 82,
              maxWidth: 82,
              minHeight: 48,
              maxHeight: 48,
            ),

            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          Obx(
            () => AppTextField(
              label: 'password',
              hintText: '********',
              iconPath: 'lib/assets/icons/Key Minimalistic.svg',
              obscureText: controller.isCreatePasswordObscured.value,
              controller: controller.passwordController,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: controller.toggleCreatePasswordVisibility,
                icon: Icon(
                  controller.isCreatePasswordObscured.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.primary900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => AppTextField(
              label: 'Konfirmasi password',
              hintText: '********',
              iconPath: 'lib/assets/icons/Key Minimalistic.svg',
              obscureText: controller.isConfirmPasswordObscured.value,
              controller: controller.confirmPasswordController,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: controller.toggleConfirmPasswordVisibility,
                icon: Icon(
                  controller.isConfirmPasswordObscured.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.primary900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => AppPrimaryButton(
              label: 'Daftar',
              onPressed: controller.register,
              isLoading: controller.isBusy.value,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Sudah Punya Akun ? ',
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.blueGray500,
                  ),
                ),
                GestureDetector(
                  onTap: controller.openLogin,
                  child: Text(
                    'Login',
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
