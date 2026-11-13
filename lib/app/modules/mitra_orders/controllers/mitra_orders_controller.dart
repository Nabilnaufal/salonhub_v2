import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/models/mitra.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraOrdersController extends GetxController {
  final data = Get.find<MitraDataService>();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = Rxn<MitraOrderStatus>();

  List<MitraOrder> get filteredOrders {
    var result = data.orders.toList();
    final status = selectedStatus.value;

    if (status != null) {
      result = result.where((order) => order.status == status).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where(
            (order) =>
                order.customerName.toLowerCase().contains(query) ||
                order.id.toLowerCase().contains(query) ||
                order.serviceSummary.toLowerCase().contains(query),
          )
          .toList();
    }

    return result;
  }

  int countForStatus(MitraOrderStatus status) {
    return data.orders.where((order) => order.status == status).length;
  }

  void selectStatus(MitraOrderStatus? status) {
    selectedStatus.value = status;
  }

  void changeQuery(String value) {
    searchQuery.value = value;
  }

  void openOrder(MitraOrder order) {
    Get.toNamed(Routes.MITRA_ORDER_DETAIL, arguments: order.id);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
