import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/models/barber.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  static const _assetPath = 'lib/assets/';
  static const _iconPath = '${_assetPath}icons/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary900,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.teal50,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: Obx(
                  () => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary900,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 62,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Pesanan',
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  '${_assetPath}logo.png',
                  width: 78,
                  height: 38,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isHistory) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTabSwitcher(),
          const SizedBox(height: 24),
          ...controller.historyBarbers.map(_buildHistoryItem),
        ],
      );
    }

    final order = controller.currentOrder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTabSwitcher(),
        const SizedBox(height: 25),
        _buildProgress(order.status),
        if (order.status == BookingStatus.finished) ...[
          const SizedBox(height: 58),
          _buildFinishedState(order),
        ] else ...[
          const SizedBox(height: 24),
          _buildBookingCard(order),
          if ((order.status == BookingStatus.waiting ||
                  order.status == BookingStatus.onProcess) &&
              order.timeEstimation != null) ...[
            const SizedBox(height: 20),
            _buildStatusInfo(order.status, order.timeEstimation!),
          ],
          const SizedBox(height: 22),
          _buildDateSection(order),
          const SizedBox(height: 22),
          _buildServiceSection(order),
          const SizedBox(height: 22),
          _buildBarberSection(order),
        ],
      ],
    );
  }

  Widget _buildHistoryItem(Barber barber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              barber.image,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barber.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.blueGray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _historyInfoRow(
                    icon: 'Map Point.svg',
                    text: '${barber.description} (${barber.distance})',
                  ),
                  const SizedBox(height: 5),
                  _historyInfoRow(icon: 'Star.svg', text: barber.rating),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyInfoRow({required String icon, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          '$_iconPath$icon',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.blueGray500,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blueGray200,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            alignment: controller.selectedTab.value == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: .5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.teal50,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.blueGray300,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _tabButton(label: 'Pesanan aktif', index: 0),
              _tabButton(label: 'Riwayat', index: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabButton({required String label, required int index}) {
    final selected = controller.selectedTab.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => controller.selectTab(index),
        borderRadius: BorderRadius.circular(18),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body3.copyWith(
              color: selected ? AppColors.blueGray900 : AppColors.blueGray500,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(BookingStatus status) {
    const steps = [
      'Calendar outline.svg',
      'Stopwatch.svg',
      'Scissors.svg',
      'Verified Check outline.svg',
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps
              .map(
                (step) => SvgPicture.asset(
                  '$_iconPath$step',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary900,
                    BlendMode.srcIn,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final progressWidth =
                constraints.maxWidth *
                (status.progressIndex / (steps.length - 1));

            return SizedBox(
              height: 14,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.blueGray200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    width: progressWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.secondary900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        steps.length,
                        (index) => _progressDot(
                          selected: index == status.progressIndex,
                          completed: index < status.progressIndex,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: BookingStatus.values
              .map((step) => _statusLabel(step.label))
              .toList(),
        ),
      ],
    );
  }

  Widget _progressDot({required bool selected, required bool completed}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? AppColors.secondary900 : AppColors.teal50,
        border: Border.all(
          color: selected || completed
              ? AppColors.primary900
              : AppColors.blueGray200,
          width: 3,
        ),
      ),
    );
  }

  Widget _statusLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary900,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption2.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildBookingCard(BookingOrder order) {
    final showCancel =
        !controller.isHistory && !controller.isBookingCancelled.value;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.teal100.withValues(alpha: .38),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blueGray200,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _roundedImage(order.shopImage, width: 70, height: 70),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.blueGray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _shopInfoRow(icon: 'Map Point.svg', text: order.location),
                    const SizedBox(height: 5),
                    _shopInfoRow(icon: 'Star.svg', text: order.rating),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, color: AppColors.blueGray200),
          ),
          Row(
            children: [
              _bookingAction(
                icon: 'logos_google-maps.svg',
                label: 'Peta',
                onTap: controller.openMaps,
              ),
              const SizedBox(width: 20),
              _bookingAction(
                icon: 'Chat Round Unread purple.svg',
                label: 'Pesan',
                onTap: controller.openChat,
              ),
              const Spacer(),
              if (showCancel)
                SizedBox(
                  width: 74,
                  height: 32,
                  child: FilledButton(
                    onPressed: controller.cancelBooking,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.primary900,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Text(
                      'Batalkan',
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shopInfoRow({required String icon, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          '$_iconPath$icon',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.blueGray500,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bookingAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Column(
          children: [
            SvgPicture.asset('$_iconPath$icon', width: 22, height: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.caption1.copyWith(
                color: AppColors.blueGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(BookingOrder order) {
    return _detailSection(
      icon: 'Calendar.svg',
      title: 'Tanggal & waktu',
      child: Text(
        order.dateLabel,
        style: AppTextStyles.body3.copyWith(color: AppColors.blueGray500),
      ),
    );
  }

  Widget _buildStatusInfo(BookingStatus status, String timeEstimation) {
    final isWaiting = status == BookingStatus.waiting;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.blueGray200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            '$_iconPath${isWaiting ? 'Stopwatch.svg' : 'Scissors.svg'}',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.blueGray900,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isWaiting ? 'Estimasi waktu' : 'Sedang diproses',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.blueGray900,
            ),
          ),
          const Spacer(),
          Text(
            timeEstimation,
            style: AppTextStyles.body3.copyWith(color: AppColors.blueGray600),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedState(BookingOrder order) {
    return Column(
      children: [
        SizedBox(
          width: 112,
          height: 112,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                '$_iconPath${'Verified Check.svg'}',
                width: 112,
                height: 112,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary900,
                  BlendMode.srcIn,
                ),
              ),
              SvgPicture.asset(
                '$_iconPath${'ceklis_putih.svg'}',
                width: 46,
                height: 34,
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(
          'Layanan selesai',
          textAlign: TextAlign.center,
          style: AppTextStyles.headline4.copyWith(color: AppColors.primary900),
        ),
        const SizedBox(height: 5),
        Text(
          'Terima kasih telah menggunakan layanan kami.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body3.copyWith(color: AppColors.primary800),
        ),
        const SizedBox(height: 68),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: FilledButton(
            onPressed: () => controller.openRatingReview(order),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary900,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Beri rating & ulasan',
                  style: AppTextStyles.headline5.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  '$_iconPath${'Hand Stars.svg'}',
                  width: 22,
                  height: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection(BookingOrder order) {
    return _detailSection(
      icon: 'Scissors.svg',
      title: 'Layanan dipilih',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: order.services
            .map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _personRow(
                  image: service.image,
                  name: service.name,
                  description: service.description,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBarberSection(BookingOrder order) {
    return _detailSection(
      icon: 'User.svg',
      title: 'Barber utama',
      child: _personRow(
        image: order.barberImage,
        name: order.barberName,
        description: order.barberDescription,
      ),
    );
  }

  Widget _detailSection({
    required String icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              '$_iconPath$icon',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.blueGray900,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.blueGray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Padding(padding: const EdgeInsets.only(left: 1), child: child),
      ],
    );
  }

  Widget _personRow({
    required String image,
    required String name,
    required String description,
  }) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(image, width: 42, height: 42, fit: BoxFit.cover),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.blueGray900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              description,
              style: AppTextStyles.caption1.copyWith(
                color: AppColors.blueGray500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roundedImage(
    String image, {
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: controller.changeNavigation,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.teal50,
      selectedItemColor: AppColors.primary900,
      unselectedItemColor: AppColors.blueGray400,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        _bottomBarItem('Home', 'Home Smile.svg', false),
        _bottomBarItem('Booking', 'Calendar Mark.svg', true),
        _bottomBarItem('Chat', 'Chat Round Unread.svg', false),
        _bottomBarItem('Profile', 'User.svg', false),
      ],
    );
  }

  BottomNavigationBarItem _bottomBarItem(
    String label,
    String icon,
    bool isActive,
  ) {
    final iconColor = isActive ? AppColors.primary900 : AppColors.blueGray400;

    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        '$_iconPath$icon',
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}
