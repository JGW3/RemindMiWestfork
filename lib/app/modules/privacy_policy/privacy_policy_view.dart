import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/components/privacy_policy.dart';
import 'package:remindmi/app/modules/privacy_policy/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

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
            PrivacyPolicy(),
          ],
        ),
        //
      ),
    );
  }
}
