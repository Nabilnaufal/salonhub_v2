import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/modules/mitra_order_detail/controllers/mitra_order_detail_controller.dart';
import 'package:salonhub_v2/app/widgets/app_primary_button.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';
import 'package:salonhub_v2/app/widgets/mitra_status_chip.dart';

class MitraOrderDetailView extends GetView<MitraOrderDetailController> {
  const MitraOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Obx(() {
          final order = controller.order;
          if (order == null) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  MitraPageHeader(title: 'Detail Pesanan', onBack: Get.back),
                  const SizedBox(height: 40),
                  const Text('Pesanan tidak ditemukan.'),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: MitraPageHeader(
                  title: 'Detail Pesanan',
                  subtitle: order.id,
                  onBack: Get.back,
                  actions: [
                    SizedBox(width: 38, height: 38),
                    InkWell(
                      onTap: controller.printReceipt,
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
                          Icons.receipt_long_rounded,
                          size: 17,
                          color: AppColors.primary900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  children: [
                    _buildStatusCard(order),
                    const SizedBox(height: 12),
                    _buildCustomerCard(order),
                    const SizedBox(height: 12),
                    _buildScheduleCard(order),
                    const SizedBox(height: 12),
                    _buildServicesCard(order),
                    const SizedBox(height: 12),
                    _buildPaymentCard(order),
                    const SizedBox(height: 12),
                    _buildNoteCard(order),
                  ],
                ),
              ),
              _buildBottomBar(context, order),
            ],
          );
        }),
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: child,
    );
  }

  Widget _buildStatusCard(MitraOrder order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: order.status.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: order.status.color.withValues(alpha: .22)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: order.status.color,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: SvgPicture.asset(
                  order.status.iconAsset,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
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
                      order.status.label,
                      style: AppTextStyles.headline5.copyWith(
                        color: order.status.color,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.status.description,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray600,
                      ),
                    ),
                  ],
                ),
              ),
              MitraStatusChip(status: order.status, compact: true),
            ],
          ),
          if (order.status != MitraOrderStatus.dibatalkan) ...[
            const SizedBox(height: 16),
            _buildProgress(order),
          ],
        ],
      ),
    );
  }

  Widget _buildProgress(MitraOrder order) {
    const labels = ['Baru', 'Menunggu', 'Diproses', 'Selesai'];
    const values = [
      MitraOrderStatus.baru,
      MitraOrderStatus.menunggu,
      MitraOrderStatus.diproses,
      MitraOrderStatus.selesai,
    ];
    final activeIndex = values.indexOf(order.status);

    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2.5,
                          color: index <= activeIndex
                              ? order.status.color
                              : AppColors.blueGray200,
                        ),
                      ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: index <= activeIndex
                            ? order.status.color
                            : AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index <= activeIndex
                              ? order.status.color
                              : AppColors.blueGray300,
                          width: 2,
                        ),
                      ),
                      child: index < activeIndex
                          ? SvgPicture.asset(
                              'lib/assets/icons/ceklis_putih.svg',
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                            )
                          : null,
                    ),
                    if (index < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2.5,
                          color: index < activeIndex
                              ? order.status.color
                              : AppColors.blueGray200,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  labels[index],
                  style: AppTextStyles.caption2.copyWith(
                    color: index <= activeIndex
                        ? order.status.color
                        : AppColors.coolGray400,
                    fontWeight: index == activeIndex
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCustomerCard(MitraOrder order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(order.customerImage),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: AppTextStyles.subHeadline3.copyWith(
                        color: AppColors.coolGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.customerPhone,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray500,
                      ),
                    ),
                  ],
                ),
              ),
              _roundAction(
                icon: Icons.call_outlined,
                onTap: controller.callCustomer,
              ),
              const SizedBox(width: 8),
              _roundAction(
                iconPath: 'Chat Round Unread.svg',
                onTap: controller.openChat,
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundAction({
    IconData? icon,
    String? iconPath,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    final foreground = filled ? AppColors.white : AppColors.primary900;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary900 : AppColors.primary50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: iconPath != null
              ? SvgPicture.asset(
                  'lib/assets/icons/$iconPath',
                  width: 17,
                  height: 17,
                  colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                )
              : Icon(icon, size: 17, color: foreground),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(MitraOrder order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadwal & Barber',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _detailRow('Calendar Mark.svg', 'Tanggal', order.dateLabel),
          const SizedBox(height: 10),
          _detailRow('Stopwatch.svg', 'Jam', order.timeLabel),
          const SizedBox(height: 10),
          _detailRow(
            'Stopwatch.svg',
            'Estimasi durasi',
            '${order.totalDuration} menit',
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.blueGray100),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(order.barberImage),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  order.barberName,
                  style: AppTextStyles.subHeadline3.copyWith(
                    color: AppColors.coolGray800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'Barber',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.primary900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String icon, String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(
          'lib/assets/icons/$icon',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.coolGray400,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.coolGray500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.coolGray800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesCard(MitraOrder order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < order.services.length; index++) ...[
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary900,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.services[index].name,
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.coolGray800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${order.services[index].durationMinutes} menit',
                        style: AppTextStyles.caption2.copyWith(
                          color: AppColors.coolGray400,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatRupiah(order.services[index].price),
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.coolGray800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (index != order.services.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: AppColors.blueGray100),
              ),
          ],
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.blueGray200),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Total',
                style: AppTextStyles.subHeadline3.copyWith(
                  color: AppColors.coolGray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                formatRupiah(order.totalPrice),
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.primary900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(MitraOrder order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.coolGray900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _detailRow('Wallet Money.svg', 'Metode', order.paymentMethod),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/icons/material-symbols_check-circle-rounded.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.teal600,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order.isPaid ? 'Sudah dibayar' : 'Belum dibayar',
                style: AppTextStyles.caption1.copyWith(
                  color: order.isPaid ? AppColors.teal700 : AppColors.red600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                order.id,
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.coolGray400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(MitraOrder order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sticky_note_2_outlined,
                size: 16,
                color: AppColors.primary900,
              ),
              const SizedBox(width: 6),
              Text(
                'Catatan customer',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.coolGray900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.note,
            style: AppTextStyles.body3.copyWith(
              color: AppColors.coolGray600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, MitraOrder order) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.viewPaddingOf(context).bottom,
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Total pesanan',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.coolGray500,
                ),
              ),
              const Spacer(),
              Text(
                formatRupiah(order.totalPrice),
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.primary900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildActions(order),
        ],
      ),
    );
  }

  Widget _buildActions(MitraOrder order) {
    switch (order.status) {
      case MitraOrderStatus.baru:
        return Row(
          children: [
            Expanded(
              child: _outlineAction(
                label: 'Tolak',
                color: AppColors.red600,
                onTap: controller.cancelOrder,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _primaryAction(
                label: 'Terima Pesanan',
                onTap: controller.acceptOrder,
              ),
            ),
          ],
        );
      case MitraOrderStatus.menunggu:
        return Row(
          children: [
            Expanded(
              child: _outlineAction(
                label: 'Batalkan',
                color: AppColors.red600,
                onTap: controller.cancelOrder,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _primaryAction(
                label: 'Mulai Layanan',
                onTap: controller.startOrder,
              ),
            ),
          ],
        );
      case MitraOrderStatus.diproses:
        return SizedBox(
          width: double.infinity,
          child: _primaryAction(
            label: 'Selesaikan Pesanan',
            onTap: controller.finishOrder,
          ),
        );
      case MitraOrderStatus.selesai:
        return SizedBox(
          width: double.infinity,
          child: _outlineAction(
            label: 'Lihat Struk',
            color: AppColors.primary900,
            onTap: controller.printReceipt,
          ),
        );
      case MitraOrderStatus.dibatalkan:
        return Container(
          width: double.infinity,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.red50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Pesanan dibatalkan',
            style: AppTextStyles.subHeadline3.copyWith(
              color: AppColors.red700,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }

  Widget _primaryAction({required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 46,
      child: Obx(
        () => IgnorePointer(
          ignoring: controller.isBusy.value,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary900,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.isBusy.value
                ? const AppButtonSpinner()
                : Text(
                    label,
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _outlineAction({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: .6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.subHeadline3.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
