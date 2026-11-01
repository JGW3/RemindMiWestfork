import 'package:get/get.dart';
import 'package:remindmi/app/modules/terms_and_condition/terms_and_condition_controller.dart';

class TermsAndConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TermsAndConditionController>(TermsAndConditionController());
  }
}
