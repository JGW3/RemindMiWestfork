import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/firestore_db.dart';

class AddDependentController extends GetxController {
  final getStorge = GetStorage();
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
    //used for eyebutton on textfield
    if (passwordVisibility.value == true) {
      passwordVisibility.value = false;
    } else {
      passwordVisibility.value = true;
    }
  }

  ToggleCPasswordVisibility() {
    //used for eyebutton on textfield

    if (cPasswordVisibility.value == true) {
      cPasswordVisibility.value = false;
    } else {
      cPasswordVisibility.value = true;
    }
  }

  ToggleTermChecked() {
    //used for checked box button on terms and conditions
    if (termChecked.value == true) {
      termChecked.value = false;
    } else {
      termChecked.value = true;
    }
  }

  void addDependent(
    String fullName,
    String email,
    String password,
    String CPassword,
    String role,
  ) async {
    // takes data from view and create account with role 'dependent'

    isLoading.value = true;

    if (termChecked.value == true) {
      if (fullName != '') {
        if (password == CPassword) {
          if (pass_valid.hasMatch(password)) {
            try {
              await FireStoreDB().createDependent(
                fullName,
                email.trim(),
                password,
              );
              isLoading.value = false;
              showCustomSnackBarSuccess(
                "Account created successfully",
                title: "success",
              );
              isSuccess.value = true;
              Get.offAllNamed(Routes.BOTTOMNAVIGATIION);
              //after all process page is navigated to home of parent
            } on FirebaseAuthException catch (e) {
              if (e.code == 'email-already-in-use') {
                isLoading.value = false;

                showCustomSnackBar("User Already Registered", title: "Email");
              } else if (e.code == 'unknown') {
                isLoading.value = false;
                showCustomSnackBar(
                  "Please fill all the fields",
                  title: "Error",
                );
              } else {
                isLoading.value = false;
                showCustomSnackBar(e.code, title: "Error");
              }
            } catch (e) {
              isLoading.value = false;
              showCustomSnackBar(e.toString(), title: "Error");
            }
          } else {
            isLoading.value = false;
            showCustomSnackBar(
              "Password should contain Capital, small letter, Number & special character!",
              title: "Error",
            );
          }
        } else {
          isLoading.value = false;
          showCustomSnackBar(
            "Confirm Password didn't matched !",
            title: "Error",
          );
        }
      } else {
        isLoading.value = false;
        showCustomSnackBar("Please fill all the fields", title: "Error");
      }
    } else {
      isLoading.value = false;
      showCustomSnackBar(
        "Please accept the terms and condition first! ",
        title: "Terms & Condition",
      );
    }
  }
}
