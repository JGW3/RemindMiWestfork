import 'package:get/get.dart';
import 'package:remindmi/app/modules/addDependent/add_depedent_controller.dart';

class AddDependentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDependentController>(() => AddDependentController());
  }
}
