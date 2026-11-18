import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class HelpController extends GetxController {
  final auth = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    final profile = auth.profile.value;
    nameController.text = profile?.fullName ?? '';
    emailController.text = profile?.email ?? '';
    super.onInit();
  }

  final catalog = Get.find<CatalogService>();

  Future<void> sendHelpRequest() async {
    final body = descriptionController.text.trim();
    if (body.isEmpty) {
      Get.snackbar(
        'Pesan kosong',
        'Tulis dulu kendala yang kamu alami.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      await catalog.sendSupportMessage(
        name: nameController.text.trim().isEmpty
            ? 'Pengguna'
            : nameController.text.trim(),
        email: emailController.text.trim(),
        body: body,
      );
      descriptionController.clear();
      Get.snackbar(
        'Bantuan',
        'Pesan bantuan berhasil dikirim.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      Get.snackbar(
        'Gagal mengirim',
        'Pesan belum terkirim. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
