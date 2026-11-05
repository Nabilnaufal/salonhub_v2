import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/security_controller.dart';

class SecurityView extends GetView<SecurityController> {
  const SecurityView({super.key});

  static const _iconPath = 'lib/assets/icons/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.teal50,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.teal50,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildPasswordFields(),
                const Spacer(),
                _buildSaveButton(),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blueGray900,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Keamanan',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        Obx(
          () => _buildPasswordField(
            label: 'Kata sandi',
            hintText: 'Masukkan kata sandi',
            controller: controller.currentPasswordController,
            obscureText: controller.isCurrentPasswordObscured.value,
            onToggleVisibility: controller.toggleCurrentPasswordVisibility,
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => _buildPasswordField(
            label: 'Kata sandi baru',
            hintText: 'Masukkan kata sandi baru',
            controller: controller.newPasswordController,
            obscureText: controller.isNewPasswordObscured.value,
            onToggleVisibility: controller.toggleNewPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption1.copyWith(color: AppColors.blueGray900),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray900,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.caption1.copyWith(
                color: AppColors.blueGray400,
              ),
              filled: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blueGray300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blueGray300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary900),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(11),
                child: SvgPicture.asset(
                  '${_iconPath}Key Minimalistic.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.blueGray300,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: controller.savePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Simpan',
          style: AppTextStyles.headline4.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
