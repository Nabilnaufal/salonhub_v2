import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

class MitraTeamFormController extends GetxController {
  final data = Get.find<MitraDataService>();

  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final shiftController = TextEditingController(text: '09.00 - 17.00');

  MitraTeamMember? editingMember;

  bool get isEditing => editingMember != null;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is MitraTeamMember) {
      editingMember = arguments;
      nameController.text = arguments.name;
      roleController.text = arguments.role;
      shiftController.text = arguments.shift;
    }
    super.onInit();
  }

  void save() {
    final name = nameController.text.trim();
    final role = roleController.text.trim();
    final shift = shiftController.text.trim();

    if (name.isEmpty || role.isEmpty) {
      Get.snackbar(
        'Lengkapi data',
        'Nama dan spesialisasi barber wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFFFF1F2),
        colorText: const Color(0xFF9F1239),
      );
      return;
    }

    if (isEditing) {
      data.updateTeamMember(
        editingMember!.copyWith(name: name, role: role, shift: shift),
      );
      Get.back();
      Get.snackbar(
        'Barber diperbarui',
        '$name berhasil disimpan.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    data.addTeamMember(
      MitraTeamMember(
        id: 'tm-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        role: role,
        rating: 5.0,
        image: 'lib/assets/barbershop_interior_1.jpg',
        isActive: true,
        todayBookings: 0,
        shift: shift.isEmpty ? '09.00 - 17.00' : shift,
      ),
    );

    Get.back();
    Get.snackbar(
      'Barber ditambahkan',
      '$name sudah masuk ke tim barbershop.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void back() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    roleController.dispose();
    shiftController.dispose();
    super.onClose();
  }
}
