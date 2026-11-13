import 'package:get/get.dart';

import '../controllers/mitra_login_controller.dart';

class MitraLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraLoginController>(() => MitraLoginController());
  }
}
