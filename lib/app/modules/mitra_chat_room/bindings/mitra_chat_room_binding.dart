import 'package:get/get.dart';

import '../controllers/mitra_chat_room_controller.dart';

class MitraChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraChatRoomController>(() => MitraChatRoomController());
  }
}
