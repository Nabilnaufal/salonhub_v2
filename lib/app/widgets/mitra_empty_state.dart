import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

class MitraEmptyState extends StatelessWidget {
  const MitraEmptyState({
    super.key,
    this.icon,
    this.iconPath,
    required this.title,
    required this.description,
  }) : assert(
         icon != null || iconPath != null,
         'Either icon or iconPath must be provided.',
       );

  final IconData? icon;
  final String? iconPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: iconPath != null
                ? SvgPicture.asset(
                    iconPath!,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary900,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(icon, size: 26, color: AppColors.primary900),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.subHeadline2.copyWith(
              color: AppColors.coolGray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.coolGray500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
