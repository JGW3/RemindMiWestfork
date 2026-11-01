import 'package:get/get.dart';
import 'package:remindmi/app/modules/forgotpassword/forgotpassword_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}
