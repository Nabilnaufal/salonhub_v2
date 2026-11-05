import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpController extends GetxController {
  final nameController = TextEditingController(text: 'Naufal Nabil');
  final emailController = TextEditingController(text: 'naufalnabil@gmail.com');
  final descriptionController = TextEditingController();

  void sendHelpRequest() {
    Get.snackbar(
      'Bantuan',
      'Pesan bantuan berhasil dikirim.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
