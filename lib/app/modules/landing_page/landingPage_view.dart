import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage_view extends StatefulWidget {
  const LandingPage_view({super.key});

  @override
  State<LandingPage_view> createState() => _LandingPage_viewState();
}

class _LandingPage_viewState extends State<LandingPage_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),

          Container(
            child: Text(
              "Let's Go",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 41,
              ),
            ),
          ),
          Spacer(),
          Align(
            child: Image.asset(
              'assets/images/landing.png',
              height: 300,
              width: 390,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),

                  height: 60,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(24, 90, 219, 1.0),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    child: Text(
                      "Sign in",
                      style: GoogleFonts.dmSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color.fromRGBO(24, 90, 219, 1.0)),
                  ),
                  child: RawMaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.SIGNUP);
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.dmSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(24, 90, 219, 1.0),
                      ),

                      // style: TextStyle(
                      //     color: Color.fromRGBO(24, 90, 219, 1.0),
                      //     fontSize: 20.0,
                      //     fontFamily: 'DM Sans',
                      //     fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
