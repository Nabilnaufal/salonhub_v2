import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/providers/routing_provider.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class FindBarberController extends GetxController {
  FindBarberController({required this.routingProvider});

  final catalog = Get.find<CatalogService>();
  final RoutingProvider routingProvider;
  final locationSearchController = TextEditingController();
  final selectedMarker = (-1).obs;
  final isSearching = false.obs;
  final showSuccessToast = false.obs;
  final selectedRecentSearch = 0.obs;
  final locationQuery = ''.obs;
  final routePoints = <LatLng>[].obs;
  final isRouting = false.obs;
  final sheetController = DraggableScrollableController();

  final currentLocation = const LatLng(-7.7508, 110.3794);

  final markerPositions = <LatLng>[].obs;
  final mapBarbers = <Barber>[].obs;
  final nearbyBarbers = <Barber>[].obs;

  final recentSearches = const [
    (name: 'Alfamart Jakal', address: 'Jl. Kaliurang Km. 9,5, Ngaglik, Sleman'),
    (
      name: 'Sentrum Space',
      address: 'Jl. Kaliurang Timur No.KM 10, Ngaglik, Sleman',
    ),
    (
      name: 'Kantor Pos Ngaglik',
      address: 'Jl. Kaliurang No.10, Ngaglik, Sleman',
    ),
  ];

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    final shops = await catalog.loadShops();
    nearbyBarbers.assignAll(shops);
    mapBarbers.assignAll(
      shops.where(
        (barber) => barber.latitude != null && barber.longitude != null,
      ),
    );
    markerPositions.assignAll(
      mapBarbers.map((barber) => LatLng(barber.latitude!, barber.longitude!)),
    );
  }

  List<({String name, String address})> get filteredRecentSearches {
    final query = locationQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return recentSearches;
    }

    return recentSearches.where((location) {
      return location.name.toLowerCase().contains(query) ||
          location.address.toLowerCase().contains(query);
    }).toList();
  }

  void selectMarker(int index) {
    selectedMarker.value = index;
    routePoints.clear();
    _loadRoadRoute(index);
  }

  Future<void> _loadRoadRoute(int index) async {
    if (index < 0 || index >= markerPositions.length) {
      return;
    }

    final destination = markerPositions[index];
    isRouting.value = true;

    try {
      final points = await routingProvider.getDrivingRoute(
        origin: currentLocation,
        destination: destination,
      );

      if (selectedMarker.value != index) {
        return;
      }
      routePoints.assignAll(points);
    } catch (_) {
      // Jika layanan routing sedang tidak tersedia, jangan menggambar
      // garis lurus palsu. Rute akan dicoba lagi saat marker dipilih ulang.
    } finally {
      if (selectedMarker.value == index) {
        isRouting.value = false;
      }
    }
  }

  void openBarber(Barber barber) {
    Get.toNamed(Routes.BARBER_DETAIL, arguments: barber);
  }

  void openSearch() {
    isSearching.value = true;
    _animateSheet(.58);
  }

  void changeLocationQuery(String value) {
    locationQuery.value = value;
  }

  void closeSearch() {
    isSearching.value = false;
    _animateSheet(.34);
  }

  void selectRecentSearch(int index) {
    selectedRecentSearch.value = index;
  }

  Timer? _toastTimer;

  void showLocationSuccess() {
    _toastTimer?.cancel();
    showSuccessToast.value = true;
    _toastTimer = Timer(const Duration(seconds: 4), hideSuccessToast);
  }

  void hideSuccessToast() {
    _toastTimer?.cancel();
    _toastTimer = null;
    showSuccessToast.value = false;
  }

  void _animateSheet(double size) {
    if (!sheetController.isAttached) {
      return;
    }

    sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void onClose() {
    _toastTimer?.cancel();
    locationSearchController.dispose();
    sheetController.dispose();
    super.onClose();
  }
}
