import 'package:get/get.dart';
import 'package:remindmi/app/modules/all_task_list/all_task_list_controller.dart';

class AllTaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllTaskListController>(() => AllTaskListController());
  }
}
