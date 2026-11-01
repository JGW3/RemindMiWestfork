import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//code for snackbar is here
void showCustomSnackBar(
  String message, {
  bool isError = true,
  String title = "Errors",
}) {
  Get.snackbar(
    title,
    message,
    titleText: Text(title),
    messageText: Text(message, style: TextStyle(color: Colors.white)),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.redAccent,
  );
}

void showCustomSnackBarSuccess(
  String message, {
  bool isError = false,
  String title = "Success",
}) {
  Get.snackbar(
    title,
    message,
    titleText: Text(title),
    messageText: Text(message, style: GoogleFonts.dmSans(color: Colors.white)),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
  );
}
