import 'package:get/get.dart';

import '../../mitra_dashboard/controllers/mitra_dashboard_controller.dart';
import '../../mitra_orders/controllers/mitra_orders_controller.dart';
import '../../mitra_profile/controllers/mitra_profile_controller.dart';
import '../../mitra_schedule/controllers/mitra_schedule_controller.dart';
import '../controllers/mitra_main_controller.dart';

class MitraMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraMainController>(MitraMainController.new);
    Get.lazyPut<MitraDashboardController>(MitraDashboardController.new);
    Get.lazyPut<MitraOrdersController>(MitraOrdersController.new);
    Get.lazyPut<MitraScheduleController>(MitraScheduleController.new);
    Get.lazyPut<MitraProfileController>(MitraProfileController.new);
  }
}
