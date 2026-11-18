import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

class BarberDetailQuickAction extends StatelessWidget {
  const BarberDetailQuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.highlighted = false,
  });

  static const _iconPath = 'lib/assets/icons/';

  final String icon;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              '$_iconPath$icon',
              width: 22,
              height: 22,
              colorFilter: highlighted
                  ? const ColorFilter.mode(AppColors.red600, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: AppTextStyles.caption1.copyWith(
                color: highlighted ? AppColors.red600 : AppColors.primary900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
