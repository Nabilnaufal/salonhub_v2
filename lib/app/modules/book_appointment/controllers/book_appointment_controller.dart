import 'package:get/get.dart';
import 'package:salonhub_v2/app/models/barber.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class AppointmentStylist {
  const AppointmentStylist({
    this.id = '',
    required this.name,
    required this.specialty,
    required this.image,
  });

  final String id;
  final String name;
  final String specialty;
  final String image;
}

class AppointmentService {
  const AppointmentService({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
  });

  final String id;
  final String name;
  final int price;
  final String description;
}

class BookAppointmentController extends GetxController {
  final catalog = Get.find<CatalogService>();

  String shopId = '';
  String shopName = '';
  String shopImage = '';
  String shopLocation = '';
  String shopRating = '';

  final now = DateTime.now();
  late final displayedMonth = DateTime(now.year, now.month).obs;
  late final selectedDate = now.day.obs;
  final selectedStylistIndex = Rxn<int>();
  final selectedServiceIndexes = <int>{}.obs;
  final selectedTime = '08.00'.obs;
  final isLoading = false.obs;

  final stylists = <AppointmentStylist>[].obs;
  final services = <AppointmentService>[].obs;

  final availableTimes = const [
    '08.00',
    '08.30',
    '09.00',
    '09.30',
    '10.00',
    '10.30',
    '11.30',
    '13.00',
    '15.30',
    '16.00',
    '17.00',
    '17.30',
  ];

  final unavailableTimes = <String>{}.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Barber) {
      shopId = arguments.id;
      shopName = arguments.name;
      shopImage = arguments.image;
    } else if (arguments is Map && arguments['shopId'] is String) {
      shopId = arguments['shopId'] as String;
    }
    _load();
    super.onInit();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      if (shopId.isEmpty) {
        final shops = await catalog.loadShops();
        if (shops.isEmpty) return;
        shopId = shops.first.id;
        shopName = shops.first.name;
        shopImage = shops.first.image;
      }

      final detail = await catalog.loadShop(shopId);
      shopName = detail.shop['name'] as String? ?? shopName;
      shopImage = detail.shop['image_url'] as String? ?? shopImage;
      shopLocation = detail.shop['address'] as String? ?? '';
      shopRating =
          '${(detail.shop['rating'] as num?)?.toStringAsFixed(1) ?? '0.0'}'
          '  (${detail.shop['review_count'] ?? 0})';

      stylists.assignAll(
        detail.barbers.map(
          (row) => AppointmentStylist(
            id: row['id'] as String,
            name: row['name'] as String,
            specialty: row['role'] as String? ?? 'Barber',
            image: row['image_url'] as String? ?? '',
          ),
        ),
      );
      services.assignAll(
        detail.services.map(
          (row) => AppointmentService(
            id: row['id'] as String,
            name: row['name'] as String,
            price: (row['price'] as num).toInt(),
            description: row['description'] as String? ?? '',
          ),
        ),
      );

      if (stylists.isNotEmpty) selectedStylistIndex.value = 0;
      if (services.isNotEmpty) selectedServiceIndexes.add(0);
      await _loadBookedSlots();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  AppointmentStylist? get selectedStylist =>
      selectedStylistIndex.value == null || stylists.isEmpty
      ? null
      : stylists[selectedStylistIndex.value!];

  List<AppointmentService> get selectedServices => services
      .asMap()
      .entries
      .where((entry) => selectedServiceIndexes.contains(entry.key))
      .map((entry) => entry.value)
      .toList();

  String get selectedServiceName =>
      selectedServices.map((service) => service.name).join(', ');

  int get selectedServicesPrice =>
      selectedServices.fold(0, (total, service) => total + service.price);

  void selectDate(int date) {
    selectedDate.value = date;
    update();
    _loadBookedSlots();
  }

  DateTime _asDateTime(String time) {
    final parts = time.split('.');
    return DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime get selectedDateTime => DateTime(
    displayedMonth.value.year,
    displayedMonth.value.month,
    selectedDate.value,
  );

  Future<void> _loadBookedSlots() async {
    if (shopId.isEmpty) return;
    try {
      final booked = await catalog.bookedSlots(
        shopId,
        selectedDateTime,
        barberId: selectedStylist?.id,
      );
      // Jam yang sudah lewat untuk hari ini juga tidak bisa dipilih.
      final now = DateTime.now();
      final isToday =
          selectedDateTime.year == now.year &&
          selectedDateTime.month == now.month &&
          selectedDateTime.day == now.day;
      final past = isToday
          ? availableTimes
                .where((time) => _asDateTime(time).isBefore(now))
                .toSet()
          : const <String>{};

      unavailableTimes.assignAll({...booked, ...past});
      if (unavailableTimes.contains(selectedTime.value)) {
        final free = availableTimes.firstWhereOrNull(
          (time) => !unavailableTimes.contains(time),
        );
        if (free != null) selectedTime.value = free;
      }
      update();
    } catch (_) {
      unavailableTimes.clear();
    }
  }

  void previousMonth() {
    _changeMonth(-1);
  }

  void nextMonth() {
    _changeMonth(1);
  }

  void _changeMonth(int offset) {
    final currentMonth = displayedMonth.value;
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + offset);
    final daysInNextMonth = DateTime(
      nextMonth.year,
      nextMonth.month + 1,
      0,
    ).day;
    final selectedDay = selectedDate.value.clamp(1, daysInNextMonth).toInt();

    displayedMonth.value = nextMonth;
    selectedDate.value = selectedDay;
    update();
    _loadBookedSlots();
  }

  void selectStylist(int index) {
    selectedStylistIndex.value = index;
    update();
    _loadBookedSlots();
  }

  void selectService(int index) {
    if (selectedServiceIndexes.contains(index)) {
      if (selectedServiceIndexes.length > 1) {
        selectedServiceIndexes.remove(index);
      }
    } else {
      selectedServiceIndexes.add(index);
    }
    update();
  }

  void selectTime(String time) {
    if (!unavailableTimes.contains(time)) {
      selectedTime.value = time;
      update();
    }
  }

  String formatRupiah(int amount) {
    final digits = amount.toString();
    final formatted = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        formatted.write('.');
      }
      formatted.write(digits[index]);
    }

    return 'Rp$formatted';
  }

  String get servicePrice => formatRupiah(selectedServicesPrice);

  String get serviceFeePrice => formatRupiah(25000);

  Future<void> submitBooking() async {
    final selected = selectedServices;
    if (selected.isEmpty) {
      showAppSnack(
        'Pilih layanan',
        'Pilih minimal satu layanan.',
        type: AppSnackType.error,
      );
      return;
    }

    final parts = selectedTime.value.split('.');
    final scheduledAt = DateTime(
      displayedMonth.value.year,
      displayedMonth.value.month,
      selectedDate.value,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    isLoading.value = true;
    try {
      final booking = await catalog.createBooking(
        shopId: shopId,
        serviceIds: selected.map((service) => service.id).toList(),
        scheduledAt: scheduledAt,
        barberId: selectedStylist?.id,
      );

      Get.toNamed(
        Routes.APPOINTMENT_PAYMENT,
        arguments: {
          'bookingId': booking['id'],
          'bookingCode': booking['code'],
          'shopName': shopName,
          'shopImage': shopImage,
          'shopLocation': shopLocation,
          'shopRating': shopRating,
          'date': scheduledAt,
          'stylistName': selectedStylist?.name ?? 'Barber',
          'stylistImage': selectedStylist?.image ?? '',
          'serviceName': selectedServiceName,
          'servicePrice': (booking['subtotal'] as num).toInt(),
          'serviceFeePrice': (booking['service_fee'] as num).toInt(),
          'totalPrice': (booking['total_price'] as num).toInt(),
        },
      );
    } catch (_) {
      showAppSnack(
        'Booking gagal',
        'Jadwal tidak tersedia atau koneksi bermasalah.',
        type: AppSnackType.error,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
