import 'package:get/get.dart';

import '../controllers/mitra_team_form_controller.dart';

class MitraTeamFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MitraTeamFormController>(() => MitraTeamFormController());
  }
}
