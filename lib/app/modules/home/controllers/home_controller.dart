import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/widgets/filter_bottom_sheet.dart';

class HomeController extends GetxController {
  final catalog = Get.find<CatalogService>();
  final auth = Get.find<AuthService>();

  final searchController = TextEditingController();
  final selectedNavIndex = 0.obs;
  final nearbyBarbers = <Barber>[].obs;
  final recommendedBarbers = <Barber>[].obs;
  final filters = Rxn<FilterOptions>();
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  String get userName => auth.profile.value?.fullName ?? 'Salonhubers';
  String? get avatarUrl => auth.profile.value?.avatarUrl;

  @override
  void onInit() {
    loadShops();
    super.onInit();
  }

  Future<void> loadShops() async {
    isLoading.value = true;
    try {
      final shops = await catalog.loadShops();
      _applyShops(shops);
    } catch (_) {
      // Halaman tetap menampilkan state kosong bila offline.
    } finally {
      isLoading.value = false;
    }
  }

  void _applyShops(List<Barber> shops) {
    final query = searchQuery.value.trim().toLowerCase();
    final filter = filters.value;

    var visible = shops;
    if (filter != null) {
      visible = visible
          .where(
            (shop) =>
                double.parse(shop.rating) >= filter.minimumRating &&
                shop.distanceKm >= filter.nearestKm &&
                shop.distanceKm <= filter.farthestKm,
          )
          .toList();
    }
    if (query.isNotEmpty) {
      visible = visible
          .where(
            (shop) =>
                shop.name.toLowerCase().contains(query) ||
                shop.description.toLowerCase().contains(query),
          )
          .toList();
    }

    nearbyBarbers.assignAll(visible.take(3));
    recommendedBarbers.assignAll(
      [...visible]..sort((a, b) => b.rating.compareTo(a.rating)),
    );
  }

  void changeSearch(String value) {
    searchQuery.value = value;
    _applyShops(catalog.shops);
  }

  Future<void> openFilter(BuildContext context) async {
    final result = await FilterBottomSheet.show(
      context,
      current: filters.value,
    );
    if (result == null) return;
    filters.value = result.isEmpty ? null : result;
    _applyShops(catalog.shops);
  }

  void openExplore() {
    Get.toNamed(
      Routes.EXPLORE_BARBERS,
      arguments: searchQuery.value.isEmpty ? null : searchQuery.value,
    );
  }

  void openBarber(Barber barber) {
    Get.toNamed(Routes.BARBER_DETAIL, arguments: barber);
  }

  void changeNavigation(int index) {
    if (index == 1) {
      Get.offNamed(Routes.ORDERS);
      return;
    }

    if (index == 2) {
      Get.offNamed(Routes.CHAT);
      return;
    }

    if (index == 3) {
      Get.offNamed(Routes.PROFILE);
      return;
    }

    selectedNavIndex.value = index;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void openRecommendedBarbers() {
    Get.toNamed(Routes.EXPLORE_BARBERS);
  }
}
