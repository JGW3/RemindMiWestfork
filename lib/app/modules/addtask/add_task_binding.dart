import 'package:get/get.dart';
import 'package:remindmi/app/modules/addtask/add_task_controller.dart';

class AddTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskController>(() => AddTaskController());
  }
}
