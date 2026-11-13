import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_dashboard/views/mitra_dashboard_view.dart';
import 'package:salonhub_v2/app/modules/mitra_main/controllers/mitra_main_controller.dart';
import 'package:salonhub_v2/app/modules/mitra_orders/views/mitra_orders_view.dart';
import 'package:salonhub_v2/app/modules/mitra_profile/views/mitra_profile_view.dart';
import 'package:salonhub_v2/app/modules/mitra_schedule/views/mitra_schedule_view.dart';
import 'package:salonhub_v2/app/widgets/mitra_bottom_nav.dart';

class MitraMainView extends GetView<MitraMainController> {
  const MitraMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.blueGray50,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            MitraDashboardView(
              onOpenOrders: () => controller.changeTab(1),
              onOpenSchedule: () => controller.changeTab(2),
            ),
            const MitraOrdersView(),
            const MitraScheduleView(),
            const MitraProfileView(),
          ],
        ),
        bottomNavigationBar: MitraBottomNav(
          currentIndex: controller.currentIndex.value,
          orderBadge: controller.data.newOrdersCount,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
