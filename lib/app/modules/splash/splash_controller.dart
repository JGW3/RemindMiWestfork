import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final getStorge = GetStorage();
  @override
  void onInit() {
    super.onInit();
  }

//Here time for splash screen is fixed
  @override
  void onReady() {
    super.onReady();
    // Both a Firebase session and the cached profile are needed; if either is
    // missing, send the user back through login.
    if (FirebaseAuth.instance.currentUser != null &&
        getStorge.read("id") != null &&
        getStorge.read("role") != null) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offAllNamed(Routes.BOTTOMNAVIGATIION);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offAllNamed(Routes.LANDINGPAGE);
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
