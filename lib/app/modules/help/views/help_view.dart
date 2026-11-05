import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 14, bottom: 20),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          '${_iconPath}Icon.svg',
                          width: 58,
                          height: 52,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Bagaimana kami bisa\nmembantu hari ini?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline3.copyWith(
                            color: AppColors.primary900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Beri tahu kami kendala yang kamu alami\nagar kami dapat membantumu.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.blueGray400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          label: 'Nama',
                          controller: controller.nameController,
                          prefixAsset: 'User.svg',
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Email',
                          controller: controller.emailController,
                          prefixAsset: 'Vector.svg',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _buildDescriptionField(),
                      ],
                    ),
                  ),
                ),
                _buildSendButton(),
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
            'Bantuan',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String prefixAsset,
    TextInputType? keyboardType,
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
          height: 42,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray900,
            ),
            decoration: _inputDecoration(
              prefixIcon: SvgPicture.asset(
                '$_iconPath$prefixAsset',
                width: 18,
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi',
          style: AppTextStyles.caption1.copyWith(color: AppColors.blueGray900),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 120,
          child: TextField(
            controller: controller.descriptionController,
            maxLines: 5,
            minLines: 5,
            textAlignVertical: TextAlignVertical.top,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray900,
            ),
            decoration: _inputDecoration(hintText: 'Tulis deskripsi di sini'),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({Widget? prefixIcon, String? hintText}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.blueGray300),
    );

    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.caption1.copyWith(color: AppColors.blueGray400),
      filled: false,
      prefixIcon: prefixIcon == null
          ? null
          : Padding(padding: const EdgeInsets.all(11), child: prefixIcon),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary900),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: controller.sendHelpRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Kirim',
          style: AppTextStyles.headline4.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
