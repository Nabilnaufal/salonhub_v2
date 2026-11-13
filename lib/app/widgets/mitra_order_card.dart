import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/widgets/mitra_status_chip.dart';

class MitraOrderCard extends StatelessWidget {
  const MitraOrderCard({super.key, required this.order, required this.onTap});

  static const _iconPath = 'lib/assets/icons/';

  final MitraOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blueGray200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary100, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        order.customerImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.subHeadline3.copyWith(
                            color: AppColors.coolGray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.id,
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MitraStatusChip(status: order.status, compact: true),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: AppColors.blueGray100),
              const SizedBox(height: 10),
              _infoRow('Scissors.svg', order.serviceSummary, maxLines: 1),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _infoRow(
                      'Stopwatch.svg',
                      '${order.dateLabel} • ${order.timeLabel}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatRupiah(order.totalPrice),
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String icon, String text, {int maxLines = 1}) {
    return Row(
      children: [
        SvgPicture.asset(
          '$_iconPath$icon',
          width: 14,
          height: 14,
          colorFilter: const ColorFilter.mode(
            AppColors.coolGray400,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.coolGray600,
            ),
          ),
        ),
      ],
    );
  }
}
