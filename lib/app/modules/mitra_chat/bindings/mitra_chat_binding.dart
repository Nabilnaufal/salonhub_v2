import 'package:get/get.dart';

import '../controllers/mitra_chat_controller.dart';

class MitraChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraChatController>(() => MitraChatController());
  }
}
