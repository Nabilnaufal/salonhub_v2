import 'package:get/get.dart';

import '../controllers/mitra_profile_controller.dart';

class MitraProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraProfileController>(() => MitraProfileController());
  }
}
