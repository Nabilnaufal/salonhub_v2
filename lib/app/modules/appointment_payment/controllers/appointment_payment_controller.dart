import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';

class PaymentMethod {
  const PaymentMethod({
    required this.name,
    required this.description,
    required this.image,
  });

  final String name;
  final String description;
  final String image;
}

class AppointmentPaymentController extends GetxController {
  final selectedPaymentIndex = 0.obs;

  String bookingId = '';
  String bookingCode = '';
  String shopName = '';
  String shopImage = '';
  String shopLocation = '';
  String shopRating = '';
  DateTime appointmentDate = DateTime.now();
  String appointmentTime = '08.00';
  String stylistName = 'Barber';
  String stylistImage = '';
  String serviceName = '';
  int servicePrice = 0;
  int serviceFeePrice = 25000;

  final paymentMethods = const [
    PaymentMethod(
      name: 'QRIS',
      description: 'Scan kode QR dengan aplikasi pembayaran',
      image: 'lib/assets/icons/QRIS Logo - Black - zonalogo.com.svg',
    ),
    PaymentMethod(
      name: 'BCA',
      description: 'Transfer melalui Bank BCA',
      image:
          'lib/assets/icons/Bank Central Asia (BCA) Logo - Colored - zonalogo.com.svg',
    ),
    PaymentMethod(
      name: 'Mandiri',
      description: 'Transfer melalui Bank Mandiri',
      image: 'lib/assets/icons/Bank Mandiri Logo - Colored - zonalogo.com.svg',
    ),
    PaymentMethod(
      name: 'BRI',
      description: 'Transfer melalui Bank BRI',
      image:
          'lib/assets/icons/Bank Rakyat Indonesia (BRI) Logo - Vertical Colored - zonalogo.com.svg',
    ),
    PaymentMethod(
      name: 'BNI',
      description: 'Transfer melalui Bank BNI',
      image:
          'lib/assets/icons/Bank Negara Indonesia (BNI) Logo - Colored - zonalogo.com.svg',
    ),
  ];

  static const _dayNames = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void onInit() {
    _readAppointmentArguments();
    super.onInit();
  }

  int get totalPrice => servicePrice + serviceFeePrice;

  String get appointmentDateLabel {
    final dayName = _dayNames[appointmentDate.weekday % 7];
    final monthName = _monthNames[appointmentDate.month - 1];

    return '$dayName, ${appointmentDate.day} $monthName '
        '${appointmentDate.year} - $appointmentTime WIB';
  }

  void selectPayment(int index) {
    selectedPaymentIndex.value = index;
    update();
  }

  void proceedToPayment() {
    final method = paymentMethods[selectedPaymentIndex.value];

    Get.toNamed(
      Routes.PAYMENT,
      arguments: {
        'methodName': method.name,
        'methodImage': method.image,
        'bookingId': bookingId,
        'bookingCode': bookingCode,
        'shopName': shopName,
        'totalPrice': totalPrice,
        'appointmentDateLabel': appointmentDateLabel,
        'stylistName': stylistName,
        'stylistImage': stylistImage,
        'serviceName': serviceName,
        'servicePrice': servicePrice,
        'serviceFeePrice': serviceFeePrice,
      },
    );
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

  void _readAppointmentArguments() {
    final arguments = Get.arguments;
    if (arguments is! Map) return;

    final code = arguments['bookingCode'];
    if (code is String) bookingCode = code;

    final id = arguments['bookingId'];
    if (id is String) bookingId = id;

    final name = arguments['shopName'];
    if (name is String) shopName = name;

    final image = arguments['shopImage'];
    if (image is String) shopImage = image;

    final location = arguments['shopLocation'];
    if (location is String) shopLocation = location;

    final rating = arguments['shopRating'];
    if (rating is String) shopRating = rating;

    final date = arguments['date'];
    if (date is DateTime) {
      appointmentDate = date;
      appointmentTime =
          '${date.hour.toString().padLeft(2, '0')}.'
          '${date.minute.toString().padLeft(2, '0')}';
    }

    final selectedStylistName = arguments['stylistName'];
    if (selectedStylistName is String) stylistName = selectedStylistName;

    final selectedStylistImage = arguments['stylistImage'];
    if (selectedStylistImage is String) stylistImage = selectedStylistImage;

    final service = arguments['serviceName'];
    if (service is String) serviceName = service;

    final price = arguments['servicePrice'];
    if (price is int) servicePrice = price;

    final fee = arguments['serviceFeePrice'];
    if (fee is int) serviceFeePrice = fee;
  }
}
