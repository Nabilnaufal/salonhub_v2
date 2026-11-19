import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salonhub_v2/app/constant/prefs.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';

/// Sesi login menang; kalau belum login, intro hanya sekali.
String resolveStartRoute({
  required bool hasSession,
  required bool seenIntro,
  required bool isMitra,
}) {
  if (hasSession) return isMitra ? Routes.MITRA_MAIN : Routes.HOME;
  return seenIntro ? Routes.LOGIN_SCREEN : Routes.INTRO_SCREEN;
}

class SplashScreeController extends GetxController {
  final auth = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();

    Timer(const Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      final profile = auth.isLoggedIn ? await auth.loadProfile() : null;

      Get.offNamed(
        resolveStartRoute(
          hasSession: auth.isLoggedIn,
          seenIntro: prefs.getBool(introSeenKey) ?? false,
          isMitra: profile?.isMitra == true,
        ),
      );
    });
  }
}
