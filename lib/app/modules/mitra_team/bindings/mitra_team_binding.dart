import 'package:get/get.dart';

import '../controllers/mitra_team_controller.dart';

class MitraTeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraTeamController>(() => MitraTeamController());
  }
}
