import 'package:get/get.dart';
import 'package:remindmi/app/modules/privacy_policy/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PrivacyPolicyController>(PrivacyPolicyController());
  }
}
