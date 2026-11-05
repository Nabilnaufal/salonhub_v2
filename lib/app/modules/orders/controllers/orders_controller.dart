import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

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
    this.timeEstimation,
  });

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
  final String? timeEstimation;

  BookingOrder copyWith({
    BookingStatus? status,
    String? timeEstimation,
    List<BookingService>? services,
  }) {
    return BookingOrder(
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
      timeEstimation: timeEstimation ?? this.timeEstimation,
    );
  }
}

class OrdersController extends GetxController {
  final selectedTab = 0.obs;
  final isBookingCancelled = false.obs;

  final historyBarbers = const [
    Barber(
      name: 'Varcity Barbershop Jogja ex The Varcher',
      description: 'Condongcatur',
      distance: '10 km',
      rating: '4.5',
      image: 'lib/assets/barbershop_haircut_3.jpg',
    ),
    Barber(
      name: 'Twinsky Monkey Barber & Men Stuff',
      description: 'Jl Taman Siswa',
      distance: '8 km',
      rating: '5.0',
      image: 'lib/assets/barbershop_exterior_1.jpg',
    ),
    Barber(
      name: 'Barberman - Haircut styling & massage',
      description: 'J-Walk Centre',
      distance: '17 km',
      rating: '4.5',
      image: 'lib/assets/barbershop_interior_2.jpg',
    ),
    Barber(
      name: 'Alana Barbershop - Haircut massage & Spa',
      description: 'Banguntapan',
      distance: '5 km',
      rating: '4.5',
      image: 'lib/assets/barbershop_haircut_1.jpg',
    ),
  ];

  final activeOrder = const BookingOrder(
    shopName: 'Masterpiece Barbershop - Haircut styling',
    location: 'Jogja Expo Centre (2 km)',
    rating: '5.0  (24)',
    shopImage: 'lib/assets/barbershop_haircut_2.jpg',
    dateLabel: 'Min, 15 Jan - 08.00 WIB',
    services: [
      BookingService(
        name: 'Potong rambut dasar',
        description: 'Potong rambut dasar & vitamin',
        image: 'lib/assets/barbershop_haircut_3.jpg',
      ),
    ],
    barberName: 'Luther Hammes',
    barberDescription: 'Spesialis potong rambut',
    barberImage: 'lib/assets/barbershop_interior_1.jpg',
    status: BookingStatus.booked,
  ).obs;

  final historyOrder = const BookingOrder(
    shopName: 'Masterpiece Barbershop - Haircut styling',
    location: 'Jogja Expo Centre (2 km)',
    rating: '5.0  (24)',
    shopImage: 'lib/assets/barbershop_haircut_2.jpg',
    dateLabel: 'Min, 08 Jan - 10.00 WIB',
    services: [
      BookingService(
        name: 'Potong rambut dasar',
        description: 'Potong rambut dasar & vitamin',
        image: 'lib/assets/barbershop_haircut_3.jpg',
      ),
    ],
    barberName: 'Luther Hammes',
    barberDescription: 'Spesialis potong rambut',
    barberImage: 'lib/assets/barbershop_interior_1.jpg',
    status: BookingStatus.finished,
  );

  BookingOrder get currentOrder =>
      selectedTab.value == 0 ? activeOrder.value : historyOrder;

  bool get isHistory => selectedTab.value == 1;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  // Dipanggil saat status booking dari backend sudah tersedia.
  // UI akan otomatis menyesuaikan progres dan detail statusnya.
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

    if (confirmed == true) {
      isBookingCancelled.value = true;
      Get.snackbar(
        'Pesanan dibatalkan',
        'Pesanan kamu berhasil dibatalkan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void openMaps() {
    Get.snackbar(
      'Peta',
      'Lokasi barbershop siap dibuka.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void openChat() {
    Get.snackbar(
      'Pesan',
      'Fitur chat akan segera tersedia.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void openRatingReview(BookingOrder order) {
    Get.toNamed(
      Routes.RATING_REVIEW,
      arguments: {
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
    }
  }
}
