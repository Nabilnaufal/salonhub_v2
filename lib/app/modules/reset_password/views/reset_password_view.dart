import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';
import 'package:salonhub_v2/app/widgets/auth_page_layout.dart';
import 'package:salonhub_v2/app/widgets/otp_input.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: 'Password baru',
      description:
          'Masukkan 6 digit kode dari email, lalu buat password baru kamu.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OtpInput(
            controllers: controller.otpControllers,
            focusNodes: controller.otpFocusNodes,
            onChanged: controller.onOtpChanged,
          ),
          const SizedBox(height: 24),
          Obx(
            () => AppTextField(
              label: 'Password baru',
              hintText: '********',
              iconPath: 'lib/assets/icons/Key Minimalistic.svg',
              controller: controller.passwordController,
              obscureText: controller.isPasswordObscured.value,
              textInputAction: TextInputAction.next,
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
          const SizedBox(height: 18),
          AppTextField(
            label: 'Ulangi password',
            hintText: '********',
            iconPath: 'lib/assets/icons/Key Minimalistic.svg',
            controller: controller.confirmController,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          AppPrimaryButton(
            label: 'Simpan password',
            onPressed: controller.submit,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: controller.resend,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Belum menerima kode?'),
          ),
        ],
      ),
    );
  }
}
