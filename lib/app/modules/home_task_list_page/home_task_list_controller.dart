import 'package:get/get.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';
import 'package:remindmi/app/services/firestore_db.dart';

enum ParentTaskStatus { incomplete, complete }

class HomeTaskListController extends GetxController {
  final tasks = <Task>[].obs;
  final ParentTaskStatus taskStatus;
  
  HomeTaskListController({this.taskStatus = ParentTaskStatus.incomplete});

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }
  
  void _loadTasks() {
    switch (taskStatus) {
      case ParentTaskStatus.incomplete:
        tasks.bindStream(FireStoreDB().parentGetInCompleteTasks());
        break;
      case ParentTaskStatus.complete:
        tasks.bindStream(FireStoreDB().parentGetCompleteTasks());
        break;
    }
  }
}
