import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

class MitraTeamFormController extends GetxController {
  final data = Get.find<MitraDataService>();
  final auth = Get.find<AuthService>();

  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final shiftController = TextEditingController(text: '09.00 - 17.00');
  final image = ''.obs;
  final isBusy = false.obs;

  MitraTeamMember? editingMember;

  bool get isEditing => editingMember != null;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();
    image.value = await auth.uploadPhoto(bytes, folder: 'barbers');
  }

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is MitraTeamMember) {
      editingMember = arguments;
      nameController.text = arguments.name;
      roleController.text = arguments.role;
      shiftController.text = arguments.shift;
      image.value = arguments.image;
    }
    super.onInit();
  }

  Future<void> save() async {
    final name = nameController.text.trim();
    final role = roleController.text.trim();
    final shift = shiftController.text.trim();

    if (name.isEmpty || role.isEmpty) {
      showAppSnack(
        'Lengkapi data',
        'Nama dan spesialisasi barber wajib diisi.',
        type: AppSnackType.error,
      );
      return;
    }

    isBusy.value = true;
    try {
      final member =
          (editingMember ??
                  const MitraTeamMember(
                    id: '',
                    name: '',
                    role: '',
                    rating: 5,
                    image: '',
                    isActive: true,
                    todayBookings: 0,
                    shift: '',
                  ))
              .copyWith(
                name: name,
                role: role,
                shift: shift.isEmpty ? '09.00 - 17.00' : shift,
                image: image.value,
              );

      if (isEditing) {
        await data.updateTeamMember(member);
      } else {
        await data.addTeamMember(member);
      }

      Get.back();
      showAppSnack(
        isEditing ? 'Barber diperbarui' : 'Barber ditambahkan',
        '$name berhasil disimpan.',
      );
    } catch (_) {
      showAppSnack(
        'Gagal menyimpan',
        'Data barber belum tersimpan. Coba lagi.',

        type: AppSnackType.error,
      );
    } finally {
      isBusy.value = false;
    }
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
