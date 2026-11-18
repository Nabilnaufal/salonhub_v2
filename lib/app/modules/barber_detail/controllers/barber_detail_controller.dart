import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/models/mitra.dart' show formatRupiah;
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class ServiceBooking {
  const ServiceBooking({
    required this.time,
    required this.name,
    required this.service,
    required this.image,
    required this.color,
  });

  final String time;
  final String name;
  final String service;
  final String image;
  final Color color;
}

typedef BarberReview = ({
  String name,
  double rating,
  String comment,
  String image,
});

class BarberDetailController extends GetxController {
  final catalog = Get.find<CatalogService>();

  final selectedTab = 0.obs;
  final ready = false.obs;

  String shopId = '';
  Barber? barber;

  String shopName = '';
  String shopImage = '';
  String location = '';
  String rating = '0.0';
  String description = '';

  final openingHours = <({String day, String hours})>[].obs;
  final services =
      <({String name, String description, String price, String image})>[].obs;
  final teamMembers =
      <({String name, String role, String rating, String image})>[].obs;
  final reviews = <BarberReview>[].obs;
  final scheduleBookings = <ServiceBooking>[].obs;
  final isFavorite = false.obs;
  final scheduleDay = DateTime.now().obs;

  String get scheduleDate {
    final day = scheduleDay.value;
    final now = DateTime.now();
    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return 'Jadwal hari ini';
    }
    return 'Jadwal ${day.day}/${day.month}/${day.year}';
  }

  List<String> get scheduleTimes {
    final now = DateTime.now();
    final day = scheduleDay.value;
    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    return List.generate(13, (index) {
      final hour = 8 + index;
      return '${hour.toString().padLeft(2, '0')}.00';
    }).where((time) {
      if (!isToday) return true;
      return int.parse(time.split('.').first) >= now.hour;
    }).toList();
  }

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Barber) {
      barber = arguments;
      shopId = arguments.id;
      _applyBarber(arguments);
    } else if (arguments is Map && arguments['shopId'] is String) {
      shopId = arguments['shopId'] as String;
    }

    _load();
    super.onInit();
  }

  void _applyBarber(Barber value) {
    shopName = value.name;
    shopImage = value.image;
    location = value.description;
    rating = '${value.rating}  (${value.distance})';
  }

  Future<void> _load() async {
    try {
      if (shopId.isEmpty) {
        final shops = await catalog.loadShops();
        if (shops.isEmpty) return;
        barber = shops.first;
        shopId = barber!.id;
        _applyBarber(barber!);
      }

      final detail = await catalog.loadShop(shopId);
      final shop = detail.shop;
      shopName = shop['name'] as String? ?? shopName;
      shopImage = shop['image_url'] as String? ?? shopImage;
      location = shop['address'] as String? ?? location;
      description = shop['description'] as String? ?? '';
      rating =
          '${(shop['rating'] as num?)?.toStringAsFixed(1) ?? '0.0'}'
          '  (${shop['review_count'] ?? 0})';

      openingHours.assignAll(
        detail.hours.map((row) {
          const dayNames = [
            'Senin',
            'Selasa',
            'Rabu',
            'Kamis',
            'Jumat',
            'Sabtu',
            'Minggu',
          ];
          final open = (row['open_time'] as String?)?.substring(0, 5) ?? '-';
          final close = (row['close_time'] as String?)?.substring(0, 5) ?? '-';
          return (
            day: dayNames[(row['day_of_week'] as num).toInt()],
            hours: row['is_closed'] == true
                ? 'Tutup'
                : '${open.replaceAll(':', '.')} - ${close.replaceAll(':', '.')}',
          );
        }),
      );

      services.assignAll(
        detail.services.map(
          (row) => (
            name: row['name'] as String,
            description: row['description'] as String? ?? '',
            price: formatRupiah((row['price'] as num).toInt()),
            image: row['image_url'] as String? ?? '',
          ),
        ),
      );

      teamMembers.assignAll(
        detail.barbers.map(
          (row) => (
            name: row['name'] as String,
            role: row['role'] as String? ?? 'Barber',
            rating: ((row['rating'] as num?)?.toDouble() ?? 0).toStringAsFixed(
              1,
            ),
            image: row['image_url'] as String? ?? '',
          ),
        ),
      );

      reviews.assignAll(
        detail.reviews.map((row) {
          final profile = row['public_profiles'] as Map?;
          return (
            name: profile?['full_name'] as String? ?? 'Customer',
            rating: (row['rating'] as num?)?.toDouble() ?? 0,
            comment: row['comment'] as String? ?? '',
            image: profile?['avatar_url'] as String? ?? '',
          );
        }),
      );

      isFavorite.value = await catalog.isFavorite(shopId);
      await _loadSchedule();
      ready.value = true;
    } catch (_) {
      ready.value = true;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
    if (index == 2) _loadSchedule();
  }

  /// Booking toko pada hari yang dipilih, dipakai tab Jadwal.
  Future<void> _loadSchedule() async {
    if (shopId.isEmpty) return;
    try {
      final rows = await catalog.loadDayBookings(shopId, scheduleDay.value);
      scheduleBookings.assignAll(
        rows.map((row) {
          final scheduled = DateTime.parse(
            row['scheduled_at'] as String,
          ).toLocal();
          return ServiceBooking(
            time:
                '${scheduled.hour.toString().padLeft(2, '0')}.'
                '${scheduled.minute.toString().padLeft(2, '0')}',
            name: row['barber_name'] as String? ?? 'Barber',
            service: 'Sudah dibooking',
            image: row['barber_image'] as String? ?? '',
            color: Colors.teal,
          );
        }),
      );
    } catch (_) {
      scheduleBookings.clear();
    }
  }

  void changeScheduleDay(DateTime day) {
    scheduleDay.value = day;
    _loadSchedule();
  }

  Future<void> toggleFavorite() async {
    if (shopId.isEmpty) return;
    try {
      isFavorite.value = await catalog.toggleFavorite(shopId);
      Get.snackbar(
        'Favorit',
        isFavorite.value
            ? '$shopName ditambahkan ke favorit.'
            : '$shopName dihapus dari favorit.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'Favorit',
        'Gagal menyimpan favorit.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void openChat() {
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {'shopId': shopId, 'name': shopName, 'image': shopImage},
    );
  }

  void openMaps() {
    final value = barber;
    if (value?.latitude == null || value?.longitude == null) {
      Get.snackbar(
        'Peta',
        'Lokasi toko belum diatur.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    openMapLocation(value!.latitude!, value.longitude!, shopName);
  }

  void shareShop() {
    final value = barber;
    shareText(
      '${value?.name ?? shopName}\n${location}\n'
      'Buka SalonHub untuk booking.',
    );
  }

  void bookNow() {
    final value = barber;
    if (value == null) {
      Get.snackbar(
        'Booking',
        'Barbershop belum siap, coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    Get.toNamed(Routes.BOOK_APPOINTMENT, arguments: value);
  }
}
