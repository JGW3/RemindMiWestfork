import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/notification_service.dart';

// Signs out of Firebase and clears everything this phone cached for the user.
// `unregisterPush` is false when the account was just deleted (its profile,
// where push tokens live, is already gone).
Future<void> signOut({bool unregisterPush = true}) async {
  if (unregisterPush) {
    await NotificationService.unregister();
  } else {
    await NotificationService.cancelAll();
  }
  await FirebaseAuth.instance.signOut();
  GetStorage().erase();
  Get.deleteAll();
  Get.offAllNamed(Routes.LANDINGPAGE);
}
