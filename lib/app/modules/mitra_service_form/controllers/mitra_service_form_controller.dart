import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class MitraServiceFormController extends GetxController {
  final data = Get.find<MitraDataService>();
  final auth = Get.find<AuthService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final image = ''.obs;
  final isBusy = false.obs;

  MitraService? editingService;

  bool get isEditing => editingService != null;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();
    image.value = await auth.uploadPhoto(bytes, folder: 'services');
  }

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is MitraService) {
      editingService = arguments;
      nameController.text = arguments.name;
      descriptionController.text = arguments.description;
      priceController.text = arguments.price.toString();
      durationController.text = arguments.durationMinutes.toString();
      image.value = arguments.image;
    }
    super.onInit();
  }

  Future<void> save() async {
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

    isBusy.value = true;
    try {
      final service =
          (editingService ??
                  const MitraService(
                    id: '',
                    name: '',
                    description: '',
                    price: 0,
                    durationMinutes: 0,
                    image: '',
                    isActive: true,
                    totalBookings: 0,
                  ))
              .copyWith(
                name: name,
                description: description.isEmpty
                    ? 'Layanan barbershop'
                    : description,
                price: price,
                durationMinutes: duration,
                image: image.value,
              );

      if (isEditing) {
        await data.updateService(service);
      } else {
        await data.addService(service);
      }

      Get.back();
      showAppSnack(
        isEditing ? 'Layanan diperbarui' : 'Layanan ditambahkan',
        '$name berhasil disimpan.',
      );
    } catch (_) {
      _showError('Layanan gagal disimpan.');
    } finally {
      isBusy.value = false;
    }
  }

  void _showError(String message) {
    showAppSnack('Lengkapi data', message, type: AppSnackType.error);
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
