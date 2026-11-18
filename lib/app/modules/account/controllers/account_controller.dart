import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:salonhub_v2/app/services/auth_service.dart';

class AccountController extends GetxController {
  final auth = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final avatarUrl = ''.obs;
  final isBusy = false.obs;

  @override
  void onInit() {
    final profile = auth.profile.value;
    if (profile != null) {
      nameController.text = profile.fullName;
      emailController.text = profile.email ?? '';
      phoneController.text = profile.phone ?? '';
      avatarUrl.value = profile.avatarUrl ?? '';
    }
    super.onInit();
  }

  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    isBusy.value = true;
    try {
      final Uint8List bytes = await picked.readAsBytes();
      final extension = picked.name.split('.').last.toLowerCase();
      final url = await auth.uploadAvatar(
        bytes,
        extension: extension == 'png' ? 'png' : 'jpg',
      );
      avatarUrl.value = url;
      Get.snackbar(
        'Foto diperbarui',
        'Avatar baru tersimpan di Supabase.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      _showError('Upload foto gagal. Coba lagi.');
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> saveAccount() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _showError('Nama tidak boleh kosong.');
      return;
    }

    isBusy.value = true;
    try {
      await auth.updateProfile(
        fullName: name,
        phone: phoneController.text.trim(),
      );
      Get.snackbar(
        'Akun',
        'Perubahan akun berhasil disimpan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (_) {
      _showError('Perubahan gagal disimpan.');
    } finally {
      isBusy.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Akun',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFFF1F2),
      colorText: const Color(0xFF9F1239),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
