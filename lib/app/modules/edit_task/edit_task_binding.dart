import 'package:get/get.dart';

import 'package:remindmi/app/modules/edit_task/edit_task_controller.dart';

class EditTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTaskController>(() => EditTaskController(null));
  }
}
