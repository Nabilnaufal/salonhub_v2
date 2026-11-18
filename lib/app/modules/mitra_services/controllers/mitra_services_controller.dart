import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraServicesController extends GetxController {
  final data = Get.find<MitraDataService>();

  /// 0 = semua, 1 = aktif, 2 = nonaktif.
  final selectedFilter = 0.obs;

  @override
  void onInit() {
    data.load();
    super.onInit();
  }

  List<MitraService> get filteredServices {
    switch (selectedFilter.value) {
      case 1:
        return data.services.where((service) => service.isActive).toList();
      case 2:
        return data.services.where((service) => !service.isActive).toList();
      default:
        return data.services.toList();
    }
  }

  int get activeCount =>
      data.services.where((service) => service.isActive).length;

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void toggleService(String id) {
    data.toggleServiceStatus(id);
  }

  void openAddService() {
    Get.toNamed(Routes.MITRA_SERVICE_FORM);
  }

  void openEditService(MitraService service) {
    Get.toNamed(Routes.MITRA_SERVICE_FORM, arguments: service);
  }

  Future<void> deleteService(MitraService service) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus layanan?'),
        content: Text(
          '${service.name} akan dihapus dari daftar layanan barbershop.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      data.removeService(service.id);
    }
  }
}
