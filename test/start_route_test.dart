import 'package:flutter_test/flutter_test.dart';
import 'package:salonhub_v2/app/modules/splash_scree/controllers/splash_scree_controller.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

void main() {
  test('rute awal mengikuti sesi, intro, dan role', () {
    expect(
      resolveStartRoute(hasSession: true, seenIntro: false, isMitra: false),
      Routes.HOME,
    );
    expect(
      resolveStartRoute(hasSession: true, seenIntro: true, isMitra: true),
      Routes.MITRA_MAIN,
    );
    expect(
      resolveStartRoute(hasSession: false, seenIntro: false, isMitra: false),
      Routes.INTRO_SCREEN,
    );
    expect(
      resolveStartRoute(hasSession: false, seenIntro: true, isMitra: false),
      Routes.LOGIN_SCREEN,
    );
  });
}
