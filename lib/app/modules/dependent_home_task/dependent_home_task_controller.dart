import 'dart:async';

import 'package:get/get.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';
import 'package:remindmi/app/services/firestore_db.dart';
import 'package:remindmi/app/services/notification_service.dart';

enum TaskStatus { incomplete, complete }

class DependentHomeTaskListController extends GetxController {
  final tasks = <Task>[].obs;
  final TaskStatus taskStatus;

  DependentHomeTaskListController({this.taskStatus = TaskStatus.incomplete});

  // Redraws once a minute so Overdue tags appear when the due time passes
  Timer? _minuteTick;

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
    _minuteTick = Timer.periodic(
      const Duration(minutes: 1),
      (_) => tasks.refresh(),
    );
  }

  @override
  void onClose() {
    _minuteTick?.cancel();
    super.onClose();
  }

  void _loadTasks() {
    switch (taskStatus) {
      case TaskStatus.incomplete:
        tasks.bindStream(FireStoreDB().dependentHomeGetIncompleteTasks());
        // Keep this phone's scheduled reminders in step with the task list
        ever(tasks, NotificationService.syncReminders);
        break;
      case TaskStatus.complete:
        tasks.bindStream(FireStoreDB().dependentHomeGetCompleteTasks());
        break;
    }
  }
}
