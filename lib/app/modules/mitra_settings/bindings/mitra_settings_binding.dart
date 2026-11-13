import 'package:get/get.dart';

import '../controllers/mitra_settings_controller.dart';

class MitraSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraSettingsController>(() => MitraSettingsController());
  }
}
