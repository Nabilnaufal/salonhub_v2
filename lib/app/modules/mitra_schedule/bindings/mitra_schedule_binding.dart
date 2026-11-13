import 'package:get/get.dart';

import '../controllers/mitra_schedule_controller.dart';

class MitraScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraScheduleController>(() => MitraScheduleController());
  }
}
