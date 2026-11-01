import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/notification_service.dart';
import 'package:remindmi/app/services/storage_service.dart';

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

// After any kind of sign-in (password or code): cache the profile on the
// phone, set up notifications, and go to the home screen.
Future<void> completeSignIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get();
  if (documentSnapshot.exists) {
    StorageService.setUserId(user.uid);
    StorageService.setUserName(documentSnapshot.get('fullName'));
    StorageService.setUserEmail(user.email);
    StorageService.setUserType(documentSnapshot.get('role'));
    StorageService.setLoggedIn(true);
    showCustomSnackBarSuccess("login successfull", title: "success");
    NotificationService.requestPermissions().then(
      (_) => NotificationService.registerPush(),
    );
    Get.offAllNamed(Routes.BOTTOMNAVIGATIION);
  } else {
    // Auth account exists but no profile doc (e.g. signup was interrupted)
    await FirebaseAuth.instance.signOut();
    showCustomSnackBar("No profile found for this account", title: "Error");
  }
}
