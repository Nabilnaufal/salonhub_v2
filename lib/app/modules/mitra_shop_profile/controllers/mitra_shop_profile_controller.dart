import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraShopProfileController extends GetxController {
  final data = Get.find<MitraDataService>();

  MitraShop get shop => data.shop.value;
  bool get isShopOpen => data.isShopOpen.value;

  void toggleShop() {
    data.toggleShop();
  }

  void openMap() {
    Get.snackbar(
      'Lokasi barbershop',
      'Peta lokasi akan dibuka di sini.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void openChat() {
    Get.snackbar(
      'Hubungi customer',
      'Fitur chat ada di menu Pesan.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> editProfile() async {
    final nameController = TextEditingController(text: shop.name);
    final descriptionController = TextEditingController(text: shop.description);
    final addressController = TextEditingController(text: shop.address);
    final phoneController = TextEditingController(text: shop.phone);

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
      data.updateShop(
        shop.copyWith(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          address: addressController.text.trim(),
          phone: phoneController.text.trim(),
        ),
      );
      Get.snackbar(
        'Profil diperbarui',
        'Perubahan sudah tersimpan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }

    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
  }
}
