import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

class MitraBottomNav extends StatelessWidget {
  const MitraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.orderBadge = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int orderBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.blueGray100)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueGray900.withValues(alpha: .05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              _item(0, 'Beranda', iconPath: 'Home Smile.svg'),
              _item(
                1,
                'Pesanan',
                icon: Icons.receipt_long_rounded,
                badge: orderBadge,
              ),
              _item(2, 'Jadwal', iconPath: 'Calendar Mark.svg'),
              _item(3, 'Profil', iconPath: 'User.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    int index,
    String label, {
    String? iconPath,
    IconData? icon,
    int badge = 0,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary900 : AppColors.coolGray400;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (iconPath != null)
                  SvgPicture.asset(
                    'lib/assets/icons/$iconPath',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  )
                else
                  Icon(icon, size: 22, color: color),
                if (badge > 0)
                  Positioned(
                    right: -8,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red600,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        '$badge',
                        style: AppTextStyles.caption2.copyWith(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.caption2.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 18 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: AppColors.secondary900,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
