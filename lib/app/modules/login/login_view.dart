import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/modules/login/login_controller.dart';
import 'package:remindmi/app/routes/app_pages.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginController MyLoginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController(text: "");
    TextEditingController _passwordController = TextEditingController(text: '');

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
                'Sign in to',
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
                controller: _emailController,
                onChanged: ((value) {
                  MyLoginController.changeEmailText();
                }),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email ID",
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
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordController,
                  obscureText: (MyLoginController.passwordVisible.value),
                  onChanged: ((value) {
                    MyLoginController.changePasswordText();
                  }),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    prefixIcon: Container(child: Icon(Icons.key_outlined)),
                    suffixIcon: InkWell(
                      child: Icon(
                        MyLoginController.passwordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onTap: () {
                        MyLoginController.passwordVisible.value =
                            !MyLoginController.passwordVisible.value;
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
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
                    MyLoginController.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (MyLoginController.isLoading.value == true) ...[
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ),
                      ],
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign in",
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
            SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.FORGOTPASSWORD);
                },
                child: Text(
                  'Forgot Password',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color.fromRGBO(84, 94, 111, 1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 36),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have account? ',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(157, 163, 173, 1),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
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
