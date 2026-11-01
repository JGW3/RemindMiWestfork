//sign up  page
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/privacy_policy.dart';
import 'package:remindmi/app/components/terms&condition.dart';
import 'package:remindmi/app/modules/signup/signup_controller.dart';
import 'package:remindmi/app/routes/app_pages.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  SignupController MySignupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    TextEditingController _fullNameController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 48),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: new IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'Create',
                style: GoogleFonts.dmSans(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'your account',
                style: GoogleFonts.dmSans(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 36),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 239, 241, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 60,
              width: 398,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _fullNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nickname",
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 239, 241, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 60,
              width: 398,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email Address",
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 239, 241, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 60,
              width: 398,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Obx(
                () => TextField(
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: _passwordController,
                  obscureText: (MySignupController.passwordVisibility.value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    prefixIcon: Icon(Icons.key_outlined),
                    suffixIcon: InkWell(
                      child: Icon(
                        MySignupController.passwordVisibility.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onTap: () {
                        MySignupController.passwordVisibility.value =
                            !MySignupController.passwordVisibility.value;
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 239, 241, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 60,
              width: 398,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Obx(
                () => TextField(
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: _confirmPasswordController,
                  obscureText: (MySignupController.cPasswordVisibility.value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirm Password",
                    prefixIcon: Icon(Icons.key_outlined),
                    suffixIcon: InkWell(
                      child: Icon(
                        MySignupController.cPasswordVisibility.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onTap: () {
                        MySignupController.cPasswordVisibility.value =
                            !MySignupController.cPasswordVisibility.value;
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Obx(
              () => Container(
                alignment: Alignment.bottomLeft,
                child: CheckboxListTile(
                  checkboxShape: CircleBorder(),
                  title: RichText(
                    text: TextSpan(
                      text: 'I agree to ',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Privacy Policy ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Align(
                                        child: Column(
                                          children: <Widget>[PrivacyPolicy()],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            color: Color.fromRGBO(24, 90, 219, 1),
                          ),
                        ),
                        TextSpan(
                          text: '&',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        TextSpan(
                          text: ' Terms and Conditions ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Align(
                                        child: Column(
                                          children: <Widget>[
                                            TermsAndCondtions(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            color: Color.fromRGBO(24, 90, 219, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: MySignupController.termChecked.value,
                  onChanged: (term) {
                    MySignupController.ToggleTermChecked();
                  },
                ),
              ),
            ),
            SizedBox(height: 31),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: 398,
              height: 60,
              child: Obx(
                () => RawMaterialButton(
                  fillColor: Color.fromRGBO(24, 90, 219, 1.0),
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    MySignupController.signUp(
                      _fullNameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _confirmPasswordController.text,
                      'parent',
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (MySignupController.isLoading.value == true) ...[
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ),
                      ],
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(157, 163, 173, 1),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign In',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.LOGIN);
                        },
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(24, 90, 219, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
