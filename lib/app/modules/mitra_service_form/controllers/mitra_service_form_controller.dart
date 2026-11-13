import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraServiceFormController extends GetxController {
  final data = Get.find<MitraDataService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  MitraService? editingService;

  bool get isEditing => editingService != null;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is MitraService) {
      editingService = arguments;
      nameController.text = arguments.name;
      descriptionController.text = arguments.description;
      priceController.text = arguments.price.toString();
      durationController.text = arguments.durationMinutes.toString();
    }
    super.onInit();
  }

  void save() {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = int.tryParse(priceController.text.trim()) ?? 0;
    final duration = int.tryParse(durationController.text.trim()) ?? 0;

    if (name.isEmpty) {
      _showError('Nama layanan wajib diisi.');
      return;
    }

    if (price <= 0) {
      _showError('Harga layanan harus lebih dari 0.');
      return;
    }

    if (duration <= 0) {
      _showError('Durasi layanan harus lebih dari 0 menit.');
      return;
    }

    if (isEditing) {
      data.updateService(
        editingService!.copyWith(
          name: name,
          description: description,
          price: price,
          durationMinutes: duration,
        ),
      );
      Get.back();
      Get.snackbar(
        'Layanan diperbarui',
        '$name berhasil disimpan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    data.addService(
      MitraService(
        id: 'svc-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description.isEmpty ? 'Layanan barbershop' : description,
        price: price,
        durationMinutes: duration,
        image: 'lib/assets/barbershop_haircut_3.jpg',
        isActive: true,
        totalBookings: 0,
      ),
    );

    Get.back();
    Get.snackbar(
      'Layanan ditambahkan',
      '$name sudah tampil di halaman customer.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Lengkapi data',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFFF1F2),
      colorText: const Color(0xFF9F1239),
    );
  }

  void back() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
