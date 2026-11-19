import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_login/controllers/mitra_login_controller.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/app_text_field.dart';

class MitraLoginView extends GetView<MitraLoginController> {
  const MitraLoginView({super.key});

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
              Row(
                children: [
                  InkWell(
                    onTap: controller.back,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.blueGray200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppColors.primary900,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _brandPill(),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Masuk ke akun mitra',
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.primary900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kelola pesanan dan jadwal barbershopmu\ndari satu tempat.',
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.blueGray500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.blueGray200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blueGray900.withValues(alpha: .04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Email atau nomor WhatsApp',
                      hintText: 'mitra@salonhub.id',
                      iconPath: 'lib/assets/icons/Vector.svg',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => AppTextField(
                        label: 'Password',
                        hintText: '********',
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
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 6,
                      children: [
                        Obx(
                          () => InkWell(
                            onTap: controller.toggleRememberMe,
                            borderRadius: BorderRadius.circular(4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (_) =>
                                        controller.toggleRememberMe(),
                                    activeColor: AppColors.primary900,
                                    side: const BorderSide(
                                      color: AppColors.blueGray300,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Ingat saya',
                                  style: AppTextStyles.caption1.copyWith(
                                    color: AppColors.blueGray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Lupa password?',
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.primary900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    AppPrimaryButton(
                      label: 'Masuk',
                      onPressed: controller.login,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun mitra? ',
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.blueGray500,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.openRegister,
                      child: Text(
                        'Daftar Barbershop',
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.primary900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Dengan masuk, kamu menyetujui Syarat & Ketentuan\n'
                  'serta Kebijakan Privasi SalonHub Mitra.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.blueGray400,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'lib/assets/icons/Scissors.svg',
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.primary900,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'SalonHub Mitra',
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
