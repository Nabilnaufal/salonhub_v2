import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';

class MitraShopProfileController extends GetxController {
  final data = Get.find<MitraDataService>();
  final auth = Get.find<AuthService>();

  MitraShop get shop => data.shop.value;
  bool get isShopOpen => data.isShopOpen.value;

  @override
  void onInit() {
    data.load();
    super.onInit();
  }

  void toggleShop() {
    data.toggleShop();
  }

  Future<void> openMap() async {
    final lat = shop.latitude;
    final lng = shop.longitude;
    if (lat == null || lng == null) {
      Get.snackbar(
        'Lokasi barbershop',
        shop.address.isEmpty ? 'Koordinat toko belum diatur.' : shop.address,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    try {
      await openMapLocation(lat, lng, shop.name);
    } catch (_) {
      Get.snackbar(
        'Lokasi barbershop',
        'Tidak bisa membuka aplikasi peta.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void openChat() {
    Get.toNamed(Routes.MITRA_CHAT);
  }

  Future<void> pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();
    final url = await auth.uploadPhoto(bytes, folder: 'shops');
    await data.updateShop(shop.copyWith(image: url));
  }

  Future<void> editProfile() async {
    final nameController = TextEditingController(text: shop.name);
    final descriptionController = TextEditingController(text: shop.description);
    final addressController = TextEditingController(text: shop.address);
    final phoneController = TextEditingController(text: shop.phone);
    final latitudeController = TextEditingController(
      text: shop.latitude?.toString() ?? '',
    );
    final longitudeController = TextEditingController(
      text: shop.longitude?.toString() ?? '',
    );

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Edit profil toko'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama toko'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Nomor telepon'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Latitude'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: longitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Longitude'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Koordinat dipakai tombol Maps customer & mitra.',
                style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
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
    );

    if (result == true) {
      await data.updateShop(
        shop.copyWith(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          address: addressController.text.trim(),
          phone: phoneController.text.trim(),
          latitude:
              double.tryParse(latitudeController.text.trim()) ?? shop.latitude,
          longitude:
              double.tryParse(longitudeController.text.trim()) ??
              shop.longitude,
        ),
      );
      Get.snackbar(
        'Profil diperbarui',
        'Perubahan sudah tersimpan di Supabase.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }

    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }
}
