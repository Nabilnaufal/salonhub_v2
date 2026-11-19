import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum BookingStatus { booked, waiting, onProcess, finished }

extension BookingStatusX on BookingStatus {
  int get progressIndex => index;

  String get label {
    switch (this) {
      case BookingStatus.booked:
        return 'Dipesan';
      case BookingStatus.waiting:
        return 'Menunggu';
      case BookingStatus.onProcess:
        return 'Diproses';
      case BookingStatus.finished:
        return 'Selesai';
    }
  }

  static BookingStatus fromBackend(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'waiting':
      case 'menunggu':
        return BookingStatus.waiting;
      case 'on_process':
      case 'on process':
      case 'on-process':
      case 'in_progress':
      case 'in progress':
      case 'processing':
      case 'diproses':
        return BookingStatus.onProcess;
      case 'finished':
      case 'completed':
      case 'selesai':
        return BookingStatus.finished;
      case 'booked':
      case 'booked_in':
      case 'dipesan':
      default:
        return BookingStatus.booked;
    }
  }
}

class BookingService {
  const BookingService({
    required this.name,
    required this.description,
    required this.image,
  });

  final String name;
  final String description;
  final String image;
}

class BookingOrder {
  const BookingOrder({
    this.id = '',
    this.shopId = '',
    required this.shopName,
    required this.location,
    required this.rating,
    required this.shopImage,
    required this.dateLabel,
    required this.services,
    required this.barberName,
    required this.barberDescription,
    required this.barberImage,
    required this.status,
    this.isCancelled = false,
    this.timeEstimation,
  });

  final String id;
  final String shopId;
  final String shopName;
  final String location;
  final String rating;
  final String shopImage;
  final String dateLabel;
  final List<BookingService> services;
  final String barberName;
  final String barberDescription;
  final String barberImage;
  final BookingStatus status;
  final bool isCancelled;
  final String? timeEstimation;

  BookingOrder copyWith({
    BookingStatus? status,
    String? timeEstimation,
    List<BookingService>? services,
  }) {
    return BookingOrder(
      id: id,
      shopId: shopId,
      shopName: shopName,
      location: location,
      rating: rating,
      shopImage: shopImage,
      dateLabel: dateLabel,
      services: services ?? this.services,
      barberName: barberName,
      barberDescription: barberDescription,
      barberImage: barberImage,
      status: status ?? this.status,
      isCancelled: isCancelled,
      timeEstimation: timeEstimation ?? this.timeEstimation,
    );
  }
}

class OrdersController extends GetxController {
  final catalog = Get.find<CatalogService>();
  SupabaseClient get _client => Supabase.instance.client;

  final selectedTab = 0.obs;
  final isBookingCancelled = false.obs;
  final isBusy = false.obs;
  final isLoading = false.obs;

  final historyBarbers = <Barber>[].obs;
  final activeOrder = BookingOrder(
    shopName: '',
    location: '',
    rating: '',
    shopImage: '',
    dateLabel: '',
    services: const [],
    barberName: '',
    barberDescription: '',
    barberImage: '',
    status: BookingStatus.booked,
  ).obs;
  var historyOrder = BookingOrder(
    shopName: '',
    location: '',
    rating: '',
    shopImage: '',
    dateLabel: '',
    services: const [],
    barberName: '',
    barberDescription: '',
    barberImage: '',
    status: BookingStatus.finished,
  );

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;

    isLoading.value = true;
    try {
      final rows = await _client
          .from('bookings')
          .select('*, booking_items(*), shops(*), barbers(*)')
          .eq('customer_id', uid)
          .order('scheduled_at', ascending: false);

      final orders = rows.map(_mapBooking).toList();
      final finished = orders
          .where(
            (order) =>
                order.status == BookingStatus.finished || order.isCancelled,
          )
          .toList();

      final latestActive = orders.where(
        (order) => order.status != BookingStatus.finished && !order.isCancelled,
      );
      if (latestActive.isNotEmpty) {
        activeOrder.value = latestActive.first;
        isBookingCancelled.value = false;
      }

      historyBarbers.assignAll(
        finished.map(
          (order) => Barber(
            id: order.shopId,
            name: order.shopName,
            description: order.location,
            distance: '',
            rating: order.rating,
            image: order.shopImage,
          ),
        ),
      );
      if (finished.isNotEmpty) {
        historyOrder = finished.first;
      }
    } catch (_) {
      // Biarkan state kosong bila gagal memuat.
    } finally {
      isLoading.value = false;
    }
  }

  BookingOrder _mapBooking(Map<String, dynamic> row) {
    final shop = row['shops'] as Map?;
    final barber = row['barbers'] as Map?;
    final items = (row['booking_items'] as List? ?? [])
        .map((item) => item as Map)
        .toList();
    final scheduled = DateTime.parse(row['scheduled_at'] as String);
    final shopRating = (shop?['rating'] as num?)?.toStringAsFixed(1) ?? '0.0';
    final reviewCount = shop?['review_count'] ?? 0;

    return BookingOrder(
      id: row['id'] as String,
      shopId: row['shop_id'] as String,
      shopName: shop?['name'] as String? ?? 'Barbershop',
      location: shop?['address'] as String? ?? '',
      rating: '$shopRating  ($reviewCount)',
      shopImage: shop?['image_url'] as String? ?? '',
      dateLabel:
          '${_dayLabel(scheduled)}, ${scheduled.day} '
          '${_monthLabel(scheduled.month)} - '
          '${scheduled.hour.toString().padLeft(2, '0')}.'
          '${scheduled.minute.toString().padLeft(2, '0')} WIB',
      services: items
          .map(
            (item) => BookingService(
              name: item['name'] as String,
              description: '${item['duration_minutes']} menit',
              image: '',
            ),
          )
          .toList(),
      barberName: barber?['name'] as String? ?? 'Barber',
      barberDescription: barber?['role'] as String? ?? 'Barber',
      barberImage: barber?['image_url'] as String? ?? '',
      status: BookingStatusX.fromBackend(row['status'] as String?),
      isCancelled: row['status'] == 'cancelled',
    );
  }

  String _dayLabel(DateTime date) {
    const names = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    return names[date.weekday % 7];
  }

  String _monthLabel(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return names[month - 1];
  }

  BookingOrder get currentOrder =>
      selectedTab.value == 0 ? activeOrder.value : historyOrder;

  bool get isHistory => selectedTab.value == 1;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void updateActiveBookingStatus(
    String backendStatus, {
    String? timeEstimation,
    List<BookingService>? services,
  }) {
    activeOrder.value = activeOrder.value.copyWith(
      status: BookingStatusX.fromBackend(backendStatus),
      timeEstimation: timeEstimation,
      services: services,
    );
  }

  Future<void> cancelBooking() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan booking?'),
        content: const Text(
          'Pesanan ini akan dibatalkan dan tidak dapat dikembalikan.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Kembali')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isBusy.value = true;
    try {
      if (activeOrder.value.id.isNotEmpty) {
        await catalog.cancelBooking(activeOrder.value.id);
      }
      isBookingCancelled.value = true;
      showAppSnack('Pesanan dibatalkan', 'Pesanan kamu berhasil dibatalkan.');
    } catch (_) {
      showAppSnack(
        'Gagal membatalkan',
        'Coba lagi beberapa saat.',
        type: AppSnackType.error,
      );
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> openMaps() async {
    final coordinates = await catalog.shopCoordinates(currentOrder.shopId);
    if (coordinates == null) {
      showAppSnack(
        'Peta',
        'Lokasi barbershop belum diatur.',
        type: AppSnackType.error,
      );
      return;
    }
    try {
      await openMapLocation(coordinates.$1, coordinates.$2);
    } catch (_) {
      showAppSnack(
        'Peta',
        'Tidak bisa membuka aplikasi peta.',
        type: AppSnackType.error,
      );
    }
  }

  void openChat() {
    final order = activeOrder.value;
    if (order.shopId.isEmpty) return;
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'shopId': order.shopId,
        'name': order.shopName,
        'image': order.shopImage,
      },
    );
  }

  void openRatingReview(BookingOrder order) {
    Get.toNamed(
      Routes.RATING_REVIEW,
      arguments: {
        'bookingId': order.id,
        'shopId': order.shopId,
        'shopName': order.shopName,
        'location': order.location,
        'rating': order.rating,
        'shopImage': order.shopImage,
      },
    );
  }

  void changeNavigation(int index) {
    if (index == 0) {
      Get.offNamed(Routes.HOME);
    } else if (index == 2) {
      Get.offNamed(Routes.CHAT);
    } else if (index == 3) {
      Get.offNamed(Routes.PROFILE);
    }
  }
}
