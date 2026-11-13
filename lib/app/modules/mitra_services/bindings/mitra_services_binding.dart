import 'package:get/get.dart';

import '../controllers/mitra_services_controller.dart';

class MitraServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraServicesController>(() => MitraServicesController());
  }
}
