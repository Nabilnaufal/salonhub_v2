import 'package:get/get.dart';

import '../controllers/mitra_reviews_controller.dart';

class MitraReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraReviewsController>(() => MitraReviewsController());
  }
}
