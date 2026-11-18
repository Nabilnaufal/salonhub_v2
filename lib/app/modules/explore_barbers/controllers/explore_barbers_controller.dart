import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/widgets/filter_bottom_sheet.dart';

class ExploreBarbersController extends GetxController {
  final catalog = Get.find<CatalogService>();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedCategory = 0.obs;
  final filters = Rxn<FilterOptions>();
  final isLoading = false.obs;
  final onlyFavorites = false.obs;
  final favoriteIds = <String>{}.obs;

  final categories = const [
    'Semua Layanan',
    'Potong Rambut',
    'Basic Haircut',
    'Coloring',
    'Treatment',
  ];

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is String && arguments.trim().isNotEmpty) {
      searchController.text = arguments;
      searchQuery.value = arguments;
    }
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      await catalog.loadShops();
      favoriteIds.assignAll(await catalog.favoriteShopIds());
    } finally {
      isLoading.value = false;
    }
  }

  List<Barber> get filteredBarbers {
    final query = searchQuery.value.trim().toLowerCase();
    final filter = filters.value;
    final chip = selectedCategory.value == 0
        ? null
        : categories[selectedCategory.value].toLowerCase();

    return catalog.shops.where((shop) {
      if (onlyFavorites.value && !favoriteIds.contains(shop.id)) return false;
      if (filter != null) {
        if (double.parse(shop.rating) < filter.minimumRating) return false;
        if (shop.distanceKm < filter.nearestKm) return false;
        if (shop.distanceKm > filter.farthestKm) return false;
        final options = filter.category?.toLowerCase();
        if (options != null && !_hasService(shop.id, options)) return false;
      }
      if (chip != null) {
        final keyword = chip == 'potong rambut' ? 'haircut' : chip;
        if (!_hasService(shop.id, keyword)) return false;
      }
      if (query.isEmpty) return true;
      return shop.name.toLowerCase().contains(query) ||
          shop.description.toLowerCase().contains(query);
    }).toList();
  }

  bool _hasService(String shopId, String keyword) {
    final names = catalog.serviceNamesByShop[shopId] ?? const <String>{};
    return names.any((name) => name.contains(keyword));
  }

  void changeSearch(String value) {
    searchQuery.value = value;
  }

  void changeCategory(int index) {
    selectedCategory.value = index;
  }

  Future<void> openFilter(BuildContext context) async {
    final result = await FilterBottomSheet.show(
      context,
      current: filters.value,
    );
    if (result == null) return;
    filters.value = result.isEmpty ? null : result;
  }

  bool get hasActiveFilter =>
      filters.value != null ||
      selectedCategory.value != 0 ||
      onlyFavorites.value;

  void clearFilter() {
    filters.value = null;
    selectedCategory.value = 0;
    onlyFavorites.value = false;
  }

  void toggleOnlyFavorites() {
    onlyFavorites.toggle();
  }

  void openBarber(Barber barber) {
    Get.toNamed(Routes.BARBER_DETAIL, arguments: barber);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
