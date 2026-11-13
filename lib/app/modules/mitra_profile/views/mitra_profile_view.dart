import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_profile/controllers/mitra_profile_controller.dart';

class MitraProfileView extends GetView<MitraProfileController> {
  const MitraProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Profil',
                      style: AppTextStyles.headline3.copyWith(
                        color: AppColors.primary900,
                      ),
                    ),
                  ),
                  _iconButton(
                    'lib/assets/icons/setting-4.svg',
                    onTap: controller.openSettings,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildProfileCard(),
              const SizedBox(height: 14),
              _buildMenuGroup('Kelola toko', [
                _MenuItem(
                  icon: 'lib/assets/icons/Shop.svg',
                  color: AppColors.primary900,
                  background: AppColors.primary50,
                  title: 'Profil Barbershop',
                  subtitle: 'Nama, alamat, foto, dan fasilitas',
                  onTap: controller.openShopProfile,
                ),
                _MenuItem(
                  icon: 'lib/assets/icons/Scissors.svg',
                  color: AppColors.secondary900,
                  background: AppColors.secondary50,
                  title: 'Layanan',
                  subtitle: 'Harga, durasi, dan status layanan',
                  onTap: controller.openServices,
                ),
                _MenuItem(
                  icon: 'lib/assets/icons/User.svg',
                  color: AppColors.blue700,
                  background: AppColors.blue50,
                  title: 'Tim Barber',
                  subtitle: 'Anggota tim dan shift kerja',
                  onTap: controller.openTeam,
                ),
                _MenuItem(
                  icon: 'lib/assets/icons/star-yellow.svg',
                  color: AppColors.yellow700,
                  background: AppColors.yellow50,
                  title: 'Ulasan & Rating',
                  subtitle: 'Balas ulasan customer',
                  onTap: controller.openReviews,
                ),
              ]),
              const SizedBox(height: 14),
              _buildMenuGroup('Keuangan', [
                _MenuItem(
                  icon: 'lib/assets/icons/Wallet Money.svg',
                  color: AppColors.teal700,
                  background: AppColors.teal50,
                  title: 'Pendapatan & Laporan',
                  subtitle: 'Transaksi dan unduh laporan',
                  onTap: controller.openEarnings,
                ),
              ]),
              const SizedBox(height: 14),
              _buildMenuGroup('Akun', [
                _MenuItem(
                  icon: 'lib/assets/icons/Chat Round Unread.svg',
                  color: AppColors.accent900,
                  background: AppColors.accent50,
                  title: 'Pesan',
                  subtitle: 'Chat dengan customer',
                  onTap: controller.openChat,
                ),
                _MenuItem(
                  icon: 'lib/assets/icons/setting-4.svg',
                  color: AppColors.coolGray700,
                  background: AppColors.blueGray100,
                  title: 'Pengaturan',
                  subtitle: 'Keamanan, notifikasi, dan lainnya',
                  onTap: controller.openSettings,
                ),
                _MenuItem(
                  icon: 'lib/assets/icons/Question Square.svg',
                  color: AppColors.coolGray700,
                  background: AppColors.blueGray100,
                  title: 'Pusat Bantuan',
                  subtitle: 'FAQ dan hubungi tim SalonHub',
                  onTap: () {
                    Get.snackbar(
                      'Pusat Bantuan',
                      'Halaman bantuan mitra akan segera tersedia.',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: AppColors.red600,
                  ),
                  label: Text(
                    'Keluar Akun',
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.red600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.red600.withValues(alpha: .5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'SalonHub Mitra v1.0.0',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(String iconPath, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blueGray200),
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            AppColors.primary900,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final shop = controller.data.shop.value;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary900, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(shop.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headline5.copyWith(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: .16),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icons/Verified Check.svg',
                                width: 11,
                                height: 11,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.secondary300,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Mitra Terverifikasi',
                                style: AppTextStyles.caption2.copyWith(
                                  color: AppColors.secondary300,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary200,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _stat('${controller.data.orders.length}', 'Pesanan'),
                _divider(),
                _stat('${controller.data.services.length}', 'Layanan'),
                _divider(),
                _stat(shop.rating.toStringAsFixed(1), 'Rating'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption2.copyWith(color: AppColors.primary200),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 26,
      color: AppColors.white.withValues(alpha: .14),
    );
  }

  Widget _buildMenuGroup(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.coolGray500,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blueGray200),
          ),
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                items[index],
                if (index != items.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 58),
                    child: Divider(height: 1, color: AppColors.blueGray100),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subHeadline3.copyWith(
                      color: AppColors.coolGray800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption2.copyWith(
                      color: AppColors.coolGray500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.coolGray300,
            ),
          ],
        ),
      ),
    );
  }
}
