import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/storage_service.dart';

class LoginController extends GetxController {

  var emailError = "".obs;
  var passwordError = "".obs;
  var extraError = "".obs;
  var isEmailError = false.obs;
  var isPasswordError = false.obs;
  var isExtraError = false.obs;

  var passwordVisible = true.obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }


  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  changeEmailText() {
    isEmailError.value = false;
    isExtraError.value = false;
  }

  changePasswordText() {
    isPasswordError.value = false;
    isExtraError.value = false;
  }

  login(String email, String password) {
    // here data from  view is passed into this function and this function further passes those arguments to
    // another function for further authentication process
    loginUsingEmailPassword(email, password);
    isLoading.value = true;
  }

  Future<User?> loginUsingEmailPassword(
    String email,
    String password,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth);
    try {
      // Core authentication process is done here
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password.trim().replaceAll(RegExp(r' \s+'), ' '));
      isLoading.value = false;
      route(); // Route is called here . in route the page is directed to bottom navigation home aka home page ...
      //and data of user is saved in get storage
      showCustomSnackBarSuccess("login successfull", title: "success");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        emailError.value = "User not found !";
        showCustomSnackBar("User not found", title: "Email");
        isEmailError.value = true;
      } else if (e.code == "invalid-email") {
        isEmailError.value = true;
        showCustomSnackBar("Format error", title: "Email");
        emailError.value = 'format error !';
      } else if (e.code == 'wrong-password') {
        isPasswordError.value = true;
        showCustomSnackBar("Incorrect Password", title: "Password");
        passwordError.value = 'Incorrect password';
      } else if (e.code == 'unknown') {
        isExtraError.value = true;
        showCustomSnackBar("Please fill all the fields", title: "Error");
        extraError.value = 'Please fill all the fields';
      } else {
        isExtraError.value = true;
        showCustomSnackBar(e.code, title: "Error");
        extraError.value = e.code;
      }
      isLoading.value = false;
    }
    return null;
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        StorageService.setUserId(user.uid);
        StorageService.setUserName(documentSnapshot.get('fullName'));
        StorageService.setUserEmail(user.email);
        StorageService.setUserType(documentSnapshot.get('role'));
        StorageService.setLoggedIn(true);
        Get.offAllNamed(Routes.BOTTOMNAVIGATIION);
      } else {
        print('Something went wrong');
      }
    });
  }
}
