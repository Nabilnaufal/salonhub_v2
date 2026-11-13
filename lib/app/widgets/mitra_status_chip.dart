import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraStatusChip extends StatelessWidget {
  const MitraStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  final MitraOrderStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 11.0 : 13.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: status.color.withValues(alpha: .28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            status.iconAsset,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(status.color, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: (compact ? AppTextStyles.caption2 : AppTextStyles.caption1)
                .copyWith(color: status.color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
