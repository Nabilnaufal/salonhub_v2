import 'dart:async';

import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

class SplashScreeController extends GetxController {
  final auth = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();

    Timer(const Duration(seconds: 1), () async {
      if (!auth.isLoggedIn) {
        Get.offNamed(Routes.INTRO_SCREEN);
        return;
      }

      final profile = await auth.loadProfile();
      Get.offNamed(profile?.isMitra == true ? Routes.MITRA_MAIN : Routes.HOME);
    });
  }
}
