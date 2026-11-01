import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final getStorge = GetStorage();
  final _auth = FirebaseAuth.instance;

  var emailError = "".obs;

  var passwordVisibility = true.obs;
  var cPasswordVisibility = true.obs;
  var isLoading = false.obs;
  var termChecked = false.obs;
  var isSuccess = false.obs;

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

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

  TogglePasswordVisibility() {
    if (passwordVisibility.value == true) {
      passwordVisibility.value = false;
    } else {
      passwordVisibility.value = true;
    }
  }

  ToggleCPasswordVisibility() {
    if (cPasswordVisibility.value == true) {
      cPasswordVisibility.value = false;
    } else {
      cPasswordVisibility.value = true;
    }
  }

  ToggleTermChecked() {
    if (termChecked.value == true) {
      termChecked.value = false;
    } else {
      termChecked.value = true;
    }
  }

  void signUp(String fullName, String email, String password, String CPassword,
      String role) async {
    //here this functions creats the user id and password by firebase auth package
    isLoading.value = true;

    if (termChecked.value == true) {
      if (fullName != '') {
        if (password == CPassword) {
          if (pass_valid.hasMatch(password)) {
            await _auth
                .createUserWithEmailAndPassword(
                    email: email,
                    password: password.trim().replaceAll(RegExp(r' \s+'), ' '))
                .then(
                    (value) => {postDetailsToFirestore(fullName, email, role)})
                .catchError((e) {
              if (e.code == 'email-already-in-use') {
                isLoading.value = false;

                showCustomSnackBar("User Already Registered", title: "Email");
              } else if (e.code == 'unknown') {
                isLoading.value = false;
                showCustomSnackBar("Please fill all the fields",
                    title: "Error");
              } else {
                isLoading.value = false;
                showCustomSnackBar(e.code, title: "Error");
              }
              return <dynamic>{};
            });
          } else {
            isLoading.value = false;
            showCustomSnackBar(
                "Password should contain Capital, small letter, Number & special character!",
                title: "Error");
          }
        } else {
          isLoading.value = false;
          showCustomSnackBar("Confirm Password didn't matched !",
              title: "Error");
        }
      } else {
        isLoading.value = false;
        showCustomSnackBar("Please fill all the fields", title: "Error");
      }
    } else {
      isLoading.value = false;
      showCustomSnackBar("Please accept the terms and condition first! ",
          title: "Terms & Condition");
    }
  }

  postDetailsToFirestore(String fullName, String email, String role) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    isLoading.value = false;
    showCustomSnackBarSuccess("Account created successfully", title: "success");

    await ref.doc(user!.uid).set(
        {'parent': '', 'fullName': fullName, 'email': email, 'role': role});

    isSuccess.value = true;
    Get.offAllNamed(Routes.LOGIN);
  }
}
