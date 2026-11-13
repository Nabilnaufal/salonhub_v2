import 'package:get/get.dart';

import '../controllers/mitra_shop_profile_controller.dart';

class MitraShopProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraShopProfileController>(() => MitraShopProfileController());
  }
}
