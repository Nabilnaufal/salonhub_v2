import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/profile_controller.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
        backgroundColor: AppColors.primary900,
        body: Column(
          children: [
            _buildProfileHeader(),
            Expanded(child: _buildSettingsPanel()),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.primary900,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 8, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Profile',
                    style: AppTextStyles.headline4.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    '${_assetPath}logo.png',
                    width: 82,
                    height: 38,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildProfileAvatar(),
                  const SizedBox(width: 14),
                  Obx(
                    () => Text(
                      controller.displayName,
                      style: AppTextStyles.headline2.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Obx(
                () => _buildContactRow(
                  icon: Icons.email_rounded,
                  text: controller.email,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _buildContactRow(
                  icon: Icons.phone_outlined,
                  text: controller.auth.profile.value?.phone ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: AppColors.teal100,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Obx(() => AppPhoto(controller.avatarUrl, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildContactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body2.copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.teal50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan',
            style: AppTextStyles.body3.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: 8),
          _buildNotificationRow(),
          _buildSettingItem('Akun', onTap: controller.openAccount),
          _buildSettingItem('Keamanan', onTap: controller.openSecurity),
          _buildSettingItem('Bantuan', onTap: controller.openHelp),
          _buildSettingItem('Tentang', onTap: controller.openAbout),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary900,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Keluar',
                style: AppTextStyles.headline4.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationRow() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.blueGray200)),
      ),
      child: Row(
        children: [
          Text(
            'Notifikasi',
            style: AppTextStyles.subHeadline2.copyWith(
              color: AppColors.primary900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Obx(
            () => Switch(
              value: controller.notificationsEnabled.value,
              onChanged: controller.toggleNotifications,
              activeThumbColor: AppColors.primary900,
              activeTrackColor: AppColors.teal50,
              trackOutlineColor: const WidgetStatePropertyAll(
                AppColors.primary900,
              ),
              trackOutlineWidth: const WidgetStatePropertyAll(1.2),
              inactiveThumbColor: AppColors.blueGray400,
              inactiveTrackColor: AppColors.blueGray200,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.blueGray200)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.subHeadline2.copyWith(
                color: AppColors.primary900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.blueGray500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: controller.changeNavigation,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.teal50,
      selectedItemColor: AppColors.primary900,
      unselectedItemColor: AppColors.blueGray400,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        _bottomBarItem('Home', 'Home Smile.svg', false),
        _bottomBarItem('Booking', 'Calendar Mark.svg', false),
        _bottomBarItem('Chat', 'Chat Round Unread.svg', false),
        _bottomBarItem('Profile', 'User.svg', true),
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
