import 'package:get/get.dart';

import '../controllers/mitra_dashboard_controller.dart';

class MitraDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraDashboardController>(() => MitraDashboardController());
  }
}
