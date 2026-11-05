import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final notificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void openAccount() {
    Get.toNamed(Routes.ACCOUNT);
  }

  void openSecurity() {
    Get.toNamed(Routes.SECURITY);
  }

  void openHelp() {
    Get.toNamed(Routes.HELP);
  }

  void openAbout() {
    Get.toNamed(Routes.ABOUT);
  }

  void changeNavigation(int index) {
    switch (index) {
      case 0:
        Get.offNamed(Routes.HOME);
      case 1:
        Get.offNamed(Routes.ORDERS);
      case 2:
        Get.offNamed(Routes.CHAT);
    }
  }
}
