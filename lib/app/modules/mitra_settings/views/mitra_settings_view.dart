import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_settings/controllers/mitra_settings_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraSettingsView extends GetView<MitraSettingsController> {
  const MitraSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            MitraPageHeader(
              title: 'Pengaturan',
              subtitle: 'Kelola preferensi akun dan toko',
              onBack: Get.back,
            ),
            const SizedBox(height: 18),
            _group('Toko', [
              _SettingRow(
                iconPath: 'lib/assets/icons/Calendar Mark.svg',
                title: 'Jam operasional',
                subtitle: 'Atur jam buka setiap hari',
                onTap: () => controller.openOpeningHours(context),
              ),
              _SettingRow(
                iconPath: 'lib/assets/icons/Wallet Money.svg',
                title: 'Metode pembayaran',
                subtitle: 'QRIS dan transfer bank',
                onTap: controller.openPaymentMethods,
              ),
              _SettingRow(
                iconPath: 'lib/assets/icons/Shop.svg',
                title: 'Profil barbershop',
                subtitle: 'Alamat, foto, dan fasilitas',
                onTap: controller.openShopProfile,
              ),
            ]),
            const SizedBox(height: 14),
            _group('Preferensi', [
              Obx(
                () => _SettingRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifikasi pesanan',
                  subtitle: 'Beritahu saat ada pesanan baru',
                  trailing: Switch(
                    value: controller.orderNotifications.value,
                    onChanged: (_) => controller.toggleOrderNotifications(),
                    activeThumbColor: AppColors.primary900,
                  ),
                ),
              ),
              Obx(
                () => _SettingRow(
                  icon: Icons.volume_up_outlined,
                  title: 'Suara notifikasi',
                  subtitle: 'Bunyikan alarm pesanan masuk',
                  trailing: Switch(
                    value: controller.soundNotifications.value,
                    onChanged: (_) => controller.toggleSoundNotifications(),
                    activeThumbColor: AppColors.primary900,
                  ),
                ),
              ),
              Obx(
                () => _SettingRow(
                  icon: Icons.campaign_outlined,
                  title: 'Promo & tips',
                  subtitle: 'Info program mitra SalonHub',
                  trailing: Switch(
                    value: controller.promoNotifications.value,
                    onChanged: (_) => controller.togglePromoNotifications(),
                    activeThumbColor: AppColors.primary900,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            _group('Keamanan', [
              _SettingRow(
                iconPath: 'lib/assets/icons/Key Minimalistic.svg',
                title: 'Ubah password',
                subtitle: 'Perbarui kata sandi akun mitra',
                onTap: controller.openChangePassword,
              ),
              _SettingRow(
                iconPath: 'lib/assets/icons/Verified Check outline.svg',
                title: 'Verifikasi akun',
                subtitle: 'Akun mitra sudah terverifikasi',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal50,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    'Terverifikasi',
                    style: AppTextStyles.caption2.copyWith(
                      color: AppColors.teal700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            _group('Lainnya', [
              _SettingRow(
                iconPath: 'lib/assets/icons/Question Square.svg',
                title: 'Pusat bantuan',
                subtitle: 'FAQ dan kontak tim SalonHub',
                onTap: controller.openHelp,
              ),
              _SettingRow(
                icon: Icons.info_outline_rounded,
                title: 'Tentang aplikasi',
                subtitle: 'Versi 1.0.0',
                onTap: controller.openAbout,
              ),
              _SettingRow(
                icon: Icons.shield_outlined,
                title: 'Kebijakan privasi',
                subtitle: 'Cara kami menjaga datamu',
                onTap: controller.openPrivacy,
              ),
            ]),
            const SizedBox(height: 18),
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
          ],
        ),
      ),
    );
  }

  Widget _group(String title, List<Widget> children) {
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
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 54),
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

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    this.icon,
    this.iconPath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  }) : assert(
         icon != null || iconPath != null,
         'Either icon or iconPath must be provided.',
       );

  final IconData? icon;
  final String? iconPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              padding: iconPath == null ? null : const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(9),
              ),
              child: iconPath != null
                  ? SvgPicture.asset(
                      iconPath!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary900,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(icon!, size: 17, color: AppColors.primary900),
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
            if (trailing != null)
              trailing!
            else
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
