import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:salonhub_v2/app/widgets/opening_hours_editor.dart';

class MitraScheduleController extends GetxController {
  final data = Get.find<MitraDataService>();

  final selectedDay = 0.obs;

  static const _weekdayLabels = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  late final DateTime baseDate;
  final slots = const [
    '08.00',
    '08.30',
    '09.00',
    '09.30',
    '10.00',
    '10.30',
    '11.00',
    '11.30',
    '12.00',
    '13.00',
    '14.00',
    '15.00',
    '16.00',
    '17.00',
    '18.00',
    '19.00',
  ];

  @override
  void onInit() {
    final now = DateTime.now();
    baseDate = DateTime(now.year, now.month, now.day);
    data.load();
    super.onInit();
  }

  List<DateTime> get days =>
      List.generate(7, (index) => baseDate.add(Duration(days: index)));

  String weekdayOf(DateTime date) => _weekdayLabels[date.weekday - 1];

  List<MitraOrder> get selectedOrders {
    final day = days[selectedDay.value];
    return data.orders.where((order) {
      final at = order.scheduledAt;
      return at != null &&
          at.year == day.year &&
          at.month == day.month &&
          at.day == day.day;
    }).toList();
  }

  int get bookedSlots => selectedOrders.length;

  int get availableSlots => slots.length - bookedSlots;

  MitraOrder? orderAt(String time) {
    for (final order in selectedOrders) {
      if (order.timeLabel.startsWith(time)) {
        return order;
      }
    }
    return null;
  }

  void selectDay(int index) {
    selectedDay.value = index;
  }

  void openOrder(MitraOrder order) {
    Get.toNamed(Routes.MITRA_ORDER_DETAIL, arguments: order.id);
  }

  /// Tambah pesanan walk-in (tanpa akun customer) lewat RPC.
  Future<void> addWalkIn(String time) async {
    final shopId = data.shopId;
    if (shopId == null) return;
    if (data.services.where((service) => service.isActive).isEmpty) {
      showAppSnack(
        'Belum ada layanan',
        'Tambahkan layanan aktif dulu di menu Layanan.',

        type: AppSnackType.info,
      );
      return;
    }

    final nameController = TextEditingController();
    final selectedServices = <String>{data.services.first.id};
    final result = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Walk-in $time'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nama customer'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Layanan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                ...data.services
                    .where((service) => service.isActive)
                    .map(
                      (service) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedServices.contains(service.id),
                        title: Text(
                          '${service.name} • ${formatRupiah(service.price)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onChanged: (value) => setState(() {
                          if (value == true) {
                            selectedServices.add(service.id);
                          } else if (selectedServices.length > 1) {
                            selectedServices.remove(service.id);
                          }
                        }),
                      ),
                    ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Batal')),
            FilledButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    final name = nameController.text.trim();
    nameController.dispose();
    if (result != true) return;
    if (name.isEmpty) {
      showAppSnack(
        'Nama kosong',
        'Isi nama customer walk-in.',
        type: AppSnackType.error,
      );
      return;
    }

    final day = days[selectedDay.value];
    final parts = time.split('.');
    final scheduledAt = DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    try {
      await data.addWalkIn(
        scheduledAt: scheduledAt,
        customerName: name,
        serviceIds: selectedServices.toList(),
      );
      showAppSnack('Walk-in ditambahkan', '$name masuk ke jadwal $time.');
    } catch (_) {
      showAppSnack(
        'Gagal menambah',
        'Slot $time mungkin sudah terisi.',
        type: AppSnackType.error,
      );
    }
  }

  Future<void> editOpeningHours(BuildContext context) =>
      showOpeningHoursEditor(context, data);
}
