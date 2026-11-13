import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_shop_profile/controllers/mitra_shop_profile_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraShopProfileView extends GetView<MitraShopProfileController> {
  const MitraShopProfileView({super.key});

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
                title: 'Profil Barbershop',
                subtitle: 'Tampilan toko di halaman customer',
                onBack: Get.back,
                actions: [
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: controller.editProfile,
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
                        Icons.edit_outlined,
                        size: 17,
                        color: AppColors.primary900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCover(),
              const SizedBox(height: 14),
              _buildIdentityCard(),
              const SizedBox(height: 12),
              _buildStatusCard(),
              const SizedBox(height: 12),
              _buildDescriptionCard(),
              const SizedBox(height: 12),
              _buildLocationCard(),
              const SizedBox(height: 12),
              _buildOpeningHoursCard(),
              const SizedBox(height: 12),
              _buildFacilitiesCard(),
              const SizedBox(height: 12),
              _buildGalleryCard(),
              const SizedBox(height: 12),
              _buildContactCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueGray200),
      ),
      child: child,
    );
  }

  Widget _cardTitle(String title, {Widget? trailing}) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.coolGray900,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildCover() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            controller.shop.image,
            height: 168,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.coolGray900.withValues(alpha: .55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: controller.isShopOpen
                  ? AppColors.teal600
                  : AppColors.red600,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  controller.isShopOpen ? 'Buka' : 'Tutup',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 12,
          right: 14,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'lib/assets/icons/Shop.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary900,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  controller.shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  controller.shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.coolGray900,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset(
                'lib/assets/icons/Verified Check.svg',
                width: 17,
                height: 17,
                colorFilter: const ColorFilter.mode(
                  AppColors.blue600,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                'lib/assets/icons/star-yellow.svg',
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondary900,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                controller.shop.rating.toStringAsFixed(1),
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.coolGray800,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '(${controller.shop.reviewCount} ulasan)',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.coolGray500,
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                'lib/assets/icons/Map Point.svg',
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  AppColors.coolGray400,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  controller.shop.distanceLabel,
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: controller.isShopOpen ? AppColors.teal50 : AppColors.red50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'lib/assets/icons/Shop.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                controller.isShopOpen ? AppColors.teal700 : AppColors.red600,
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
                  controller.isShopOpen
                      ? 'Menerima pesanan'
                      : 'Toko sedang tutup',
                  style: AppTextStyles.subHeadline3.copyWith(
                    color: AppColors.coolGray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.isShopOpen
                      ? 'Customer bisa melakukan booking'
                      : 'Customer tidak bisa booking saat ini',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.coolGray500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: controller.isShopOpen,
            onChanged: (_) => controller.toggleShop(),
            activeThumbColor: AppColors.primary900,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Tentang barbershop'),
          const SizedBox(height: 8),
          Text(
            controller.shop.description,
            style: AppTextStyles.body3.copyWith(
              color: AppColors.coolGray600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Lokasi'),
          const SizedBox(height: 10),
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.blueGray100,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('lib/assets/background2.png'),
                fit: BoxFit.cover,
                opacity: .35,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/icons/Map Point.svg',
                width: 34,
                height: 34,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary900,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'lib/assets/icons/Map Point.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.coolGray400,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  controller.shop.address,
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.coolGray600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: controller.openMap,
              icon: SvgPicture.asset(
                'lib/assets/icons/Map Arrow Square.svg',
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary900,
                  BlendMode.srcIn,
                ),
              ),
              label: const Text('Lihat di peta'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary900,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: AppTextStyles.caption1.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHoursCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Jam operasional'),
          const SizedBox(height: 8),
          for (final item in controller.shop.openingHours)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 74,
                    child: Text(
                      item.day,
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.coolGray600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.isClosed ? 'Tutup' : item.hours,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption1.copyWith(
                        color: item.isClosed
                            ? AppColors.red600
                            : AppColors.coolGray800,
                        fontWeight: FontWeight.w600,
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

  Widget _buildFacilitiesCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Fasilitas'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.shop.facilities
                .map(
                  (facility) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      facility,
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.primary900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            'Galeri',
            trailing: Text(
              '${controller.shop.gallery.length} foto',
              style: AppTextStyles.caption2.copyWith(
                color: AppColors.coolGray400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.shop.gallery.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  controller.shop.gallery[index],
                  width: 110,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.primary900,
              ),
              const SizedBox(width: 8),
              Text(
                controller.shop.phone,
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.coolGray800,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Nomor toko',
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
}
