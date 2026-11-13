import 'package:flutter/material.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

class MitraSectionHeader extends StatelessWidget {
  const MitraSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 15,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel!,
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.primary900,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
