import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';
import 'package:salonhub_v2/app/widgets/location_picker.dart';

class MitraShopProfileController extends GetxController {
  final data = Get.find<MitraDataService>();
  final auth = Get.find<AuthService>();
  final isUploading = false.obs;

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

  Future<void> addGalleryPhoto() async {
    if (isUploading.value) return;

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 80,
    );
    if (picked == null) return;

    isUploading.value = true;
    try {
      final bytes = await picked.readAsBytes();
      final url = await auth.uploadPhoto(bytes, folder: 'shops');
      await data.updateShop(shop.copyWith(gallery: [...shop.gallery, url]));
    } catch (_) {
      Get.snackbar(
        'Gagal mengunggah',
        'Foto galeri belum tersimpan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> removeGalleryPhoto(int index) async {
    if (index < 0 || index >= shop.gallery.length) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus foto?'),
        content: const Text('Foto ini akan dihapus dari galeri toko.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final gallery = [...shop.gallery]..removeAt(index);
    await data.updateShop(shop.copyWith(gallery: gallery));
  }

  Future<void> editProfile() async {
    final nameController = TextEditingController(text: shop.name);
    final descriptionController = TextEditingController(text: shop.description);
    final addressController = TextEditingController(text: shop.address);
    final phoneController = TextEditingController(text: shop.phone);
    final facilitiesController = TextEditingController(
      text: shop.facilities.join(', '),
    );
    LatLng? picked = (shop.latitude != null && shop.longitude != null)
        ? LatLng(shop.latitude!, shop.longitude!)
        : null;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Edit profil toko'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
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
                TextField(
                  controller: facilitiesController,
                  decoration: const InputDecoration(
                    labelText: 'Fasilitas',
                    hintText: 'AC, WiFi, Parkir (pisahkan dengan koma)',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final location = await showLocationPicker(
                        context,
                        initial: picked,
                      );
                      if (location != null) {
                        setState(() => picked = location);
                      }
                    },
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text(
                      picked == null
                          ? 'Pilih lokasi di peta'
                          : '${picked!.latitude.toStringAsFixed(6)}, '
                                '${picked!.longitude.toStringAsFixed(6)}',
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lokasi dipakai tombol Maps customer & mitra.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ],
            ),
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
          facilities: facilitiesController.text
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList(),
          latitude: picked?.latitude ?? shop.latitude,
          longitude: picked?.longitude ?? shop.longitude,
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
    facilitiesController.dispose();
  }
}
