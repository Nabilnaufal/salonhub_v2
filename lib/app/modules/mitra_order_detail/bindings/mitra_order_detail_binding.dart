import 'package:get/get.dart';

import '../controllers/mitra_order_detail_controller.dart';

class MitraOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraOrderDetailController>(() => MitraOrderDetailController());
  }
}
