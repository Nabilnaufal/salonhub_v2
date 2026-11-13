import 'package:get/get.dart';

import '../controllers/mitra_service_form_controller.dart';

class MitraServiceFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraServiceFormController>(() => MitraServiceFormController());
  }
}
