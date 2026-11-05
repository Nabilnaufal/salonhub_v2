import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  static const _assetPath = 'lib/assets/';
  static const _iconPath = '${_assetPath}icons/';

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
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 18, bottom: 20),
                    child: Column(
                      children: [
                        _buildAvatar(),
                        const SizedBox(height: 10),
                        Text(
                          'Naufal Nabil',
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.primary900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildField(
                          label: 'Nama',
                          controller: controller.nameController,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          label: 'Email',
                          controller: controller.emailController,
                          prefixIcon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => _buildField(
                            label: 'Kata sandi',
                            controller: controller.passwordController,
                            prefixAsset: 'Key Minimalistic.svg',
                            obscureText: controller.isPasswordObscured.value,
                            suffixIcon: IconButton(
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.isPasswordObscured.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.blueGray300,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSaveButton(),
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
            'Akun',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: AppColors.blueGray300,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset('${_assetPath}login_picture.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    IconData? prefixIcon,
    String? prefixAsset,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
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
            keyboardType: keyboardType,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray900,
            ),
            decoration: InputDecoration(
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
              prefixIcon: prefixIcon == null && prefixAsset == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(11),
                      child: prefixAsset == null
                          ? Icon(
                              prefixIcon,
                              color: AppColors.primary900,
                              size: 20,
                            )
                          : SvgPicture.asset(
                              '$_iconPath$prefixAsset',
                              width: 20,
                              height: 20,
                            ),
                    ),
              suffixIcon: suffixIcon,
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
        onPressed: controller.saveAccount,
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
