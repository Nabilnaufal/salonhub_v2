import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_earnings/controllers/mitra_earnings_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraEarningsView extends GetView<MitraEarningsController> {
  const MitraEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              MitraPageHeader(
                title: 'Pendapatan',
                subtitle: 'Ringkasan transaksi barbershopmu',
                onBack: Get.back,
              ),
              const SizedBox(height: 16),
              _buildPeriodSelector(),
              const SizedBox(height: 14),
              _buildRevenueCard(),
              const SizedBox(height: 14),
              _buildChartCard(),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Transaksi terbaru',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headline5.copyWith(
                        color: AppColors.coolGray900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${controller.transactionCount} transaksi',
                    style: AppTextStyles.caption2.copyWith(
                      color: AppColors.coolGray500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...controller.transactions.map(_buildTransaction),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: controller.downloadReport,
                  icon: SvgPicture.asset(
                    'lib/assets/icons/Cloud Download.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary900,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text(
                    'Unduh Laporan PDF',
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.primary900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    const labels = ['Hari ini', 'Minggu ini', 'Bulan ini'];

    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () => controller.selectPeriod(index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: controller.selectedPeriod.value == index
                      ? AppColors.primary900
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: controller.selectedPeriod.value == index
                        ? AppColors.primary900
                        : AppColors.blueGray200,
                  ),
                ),
                child: Text(
                  labels[index],
                  style: AppTextStyles.caption1.copyWith(
                    color: controller.selectedPeriod.value == index
                        ? AppColors.white
                        : AppColors.coolGray600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary900, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: .2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pendapatan bersih',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.primary200,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (controller.growthPercent != null)
                _growthBadge(controller.growthPercent!),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatRupiah(controller.netRevenue),
            style: AppTextStyles.display2.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _summary(
                  'Pendapatan kotor',
                  formatRupiah(controller.grossRevenue),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.white.withValues(alpha: .14),
                ),
                _summary(
                  'Biaya platform',
                  '-${formatRupiah(controller.platformFee)}',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.white.withValues(alpha: .14),
                ),
                _summary('Transaksi', '${controller.transactionCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.primary200,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _growthBadge(double growth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'lib/assets/icons/Square Arrow Right Up.svg',
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(
              AppColors.teal300,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.teal300,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    final values = controller.weeklyRevenue;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    // Tanpa guard, semua nilai 0 membuat tinggi bar jadi NaN.
    final scaleMax = maxValue <= 0 ? 1 : maxValue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren 7 hari terakhir',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${(values[index] / 1000).round()}k',
                              maxLines: 1,
                              style: AppTextStyles.caption2.copyWith(
                                color: AppColors.coolGray400,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 20 + (values[index] / scaleMax) * 58,
                            decoration: BoxDecoration(
                              color: index == values.length - 1
                                  ? AppColors.primary900
                                  : AppColors.primary100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              controller.weeklyLabels[index],
                              maxLines: 1,
                              style: AppTextStyles.caption2.copyWith(
                                color: AppColors.coolGray500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction(
    ({String title, String subtitle, int amount, bool isIncome}) transaction,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: transaction.isIncome ? AppColors.teal50 : AppColors.red50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              transaction.isIncome
                  ? 'lib/assets/icons/Wallet Money.svg'
                  : 'lib/assets/icons/Close Square.svg',
              width: 17,
              height: 17,
              colorFilter: ColorFilter.mode(
                transaction.isIncome ? AppColors.teal700 : AppColors.red600,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.coolGray800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.isIncome ? '+' : '-'}'
            '${formatRupiah(transaction.amount)}',
            style: AppTextStyles.caption1.copyWith(
              color: transaction.isIncome
                  ? AppColors.teal700
                  : AppColors.red600,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
