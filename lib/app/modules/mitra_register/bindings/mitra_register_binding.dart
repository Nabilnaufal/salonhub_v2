import 'package:get/get.dart';

import '../controllers/mitra_register_controller.dart';

class MitraRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraRegisterController>(() => MitraRegisterController());
  }
}
