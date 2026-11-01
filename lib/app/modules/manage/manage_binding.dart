import 'package:get/get.dart';
import 'package:remindmi/app/modules/manage/manage_controller.dart';

class ManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageController>(() => ManageController());
  }
}
