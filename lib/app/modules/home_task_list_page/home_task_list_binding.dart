import 'package:get/get.dart';
import 'package:remindmi/app/modules/home_task_list_page/home_task_list_controller.dart';

class HomeTaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTaskListController>(() => HomeTaskListController());
  }
}
