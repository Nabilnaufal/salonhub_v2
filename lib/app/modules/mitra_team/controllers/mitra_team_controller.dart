import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraTeamController extends GetxController {
  final data = Get.find<MitraDataService>();

  /// 0 = semua, 1 = aktif, 2 = nonaktif.
  final selectedFilter = 0.obs;

  List<MitraTeamMember> get filteredMembers {
    switch (selectedFilter.value) {
      case 1:
        return data.team.where((member) => member.isActive).toList();
      case 2:
        return data.team.where((member) => !member.isActive).toList();
      default:
        return data.team.toList();
    }
  }

  int get activeCount => data.team.where((member) => member.isActive).length;

  double get averageRating {
    if (data.team.isEmpty) {
      return 0;
    }
    final total = data.team.fold<double>(
      0,
      (sum, member) => sum + member.rating,
    );
    return total / data.team.length;
  }

  void selectFilter(int index) {
    selectedFilter.value = index;
  }

  void toggleMember(String id) {
    data.toggleTeamMemberStatus(id);
  }

  void openAddMember() {
    Get.toNamed(Routes.MITRA_TEAM_FORM);
  }

  void openEditMember(MitraTeamMember member) {
    Get.toNamed(Routes.MITRA_TEAM_FORM, arguments: member);
  }

  Future<void> deleteMember(MitraTeamMember member) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus barber?'),
        content: Text('${member.name} akan dihapus dari tim barbershop.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      data.removeTeamMember(member.id);
    }
  }
}
