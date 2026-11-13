import 'package:get/get.dart';

import '../controllers/mitra_orders_controller.dart';

class MitraOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraOrdersController>(() => MitraOrdersController());
  }
}
