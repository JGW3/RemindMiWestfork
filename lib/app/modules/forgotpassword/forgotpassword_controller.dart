import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';

class ForgotPasswordController extends GetxController {
  final getStorge = GetStorage();
  final _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // sendResetLink provides the link from firebase inorder to change password
  sendResetLink(String email) async {
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      isLoading.value = false;
      showCustomSnackBarSuccess(
        "Password reset link is sent to email !",
        title: "success",
      );
    } on FirebaseAuthException {
      isLoading.value = false;
      showCustomSnackBar("Something went wrong !", title: "Error");
    }
  }
}
