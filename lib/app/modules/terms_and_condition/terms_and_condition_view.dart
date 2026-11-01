import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/components/terms&condition.dart';
import 'package:remindmi/app/modules/terms_and_condition/terms_and_condition_controller.dart';

class TermsAndConditionView extends GetView<TermsAndConditionController> {
  const TermsAndConditionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            TermsAndCondtions(),
          ],
        ),
        //
      ),
    );
  }
}
