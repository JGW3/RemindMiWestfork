import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';
import 'package:remindmi/app/services/firestore_db.dart';

enum ParentTaskStatus { incomplete, complete }

class HomeTaskListController extends GetxController {
  final tasks = <Task>[].obs;
  final ParentTaskStatus taskStatus;

  HomeTaskListController({this.taskStatus = ParentTaskStatus.incomplete});

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
      case ParentTaskStatus.incomplete:
        tasks.bindStream(FireStoreDB().parentGetInCompleteTasks());
        FireStoreDB().backfillParentTasks().catchError(
          (e) => debugPrint('Task backfill failed: $e'),
        );
        break;
      case ParentTaskStatus.complete:
        tasks.bindStream(FireStoreDB().parentGetCompleteTasks());
        break;
    }
  }
}
