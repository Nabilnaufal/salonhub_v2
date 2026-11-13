import 'package:get/get.dart';

import '../controllers/mitra_earnings_controller.dart';

class MitraEarningsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraEarningsController>(() => MitraEarningsController());
  }
}
