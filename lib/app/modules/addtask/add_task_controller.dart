import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/models/add_task_dependent_list_model.dart';
import 'package:remindmi/app/helper/assignment.dart';
import 'package:remindmi/app/helper/due_date.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindmi/app/services/firestore_db.dart';

class AddTaskController extends GetxController {
  final getStorge = GetStorage();
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var selectedPriority = 'Select Priority'.obs;
  var remindBefore = 0.obs;
  var repeat = 'none'.obs;
  var takeTurns = false.obs;
  List<String> priorityList = ['Select Priority', 'High', 'Medium', 'Low'];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController selectedDate = TextEditingController();
  TextEditingController selectedTime = TextEditingController();
  final dependents = <Dependent>[].obs;
  List selectedDependents = [].obs;
  @override
  void onInit() {
    // Existing Dependent list is showm by getAllDependentAddTask() function which which is called on oninit().
    dependents.bindStream(FireStoreDB().getAllDependentAddTask());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    //after closing all data are erased by reset function
    reset();
    super.onClose();
  }

  reset() {
    selectedDependents = [].obs;
  }

  void onAddTask(
    //this function stores or add's the data from view to collection 'tasks' on firestore
    String taskName,
    String taskDescription,
  ) async {
    isLoading.value = true;
    if (taskName != '') {
      if (taskDescription != '') {
        if (selectedPriority.value != 'Select Priority') {
          if (selectedDate.text != '' || repeat.value == 'asNeeded') {
            if (selectedTime.text != '' || repeat.value == 'asNeeded') {
              if (selectedDependents.isNotEmpty) {
                try {
                  var finalPriority;
                  if (selectedPriority.value == 'High') {
                    finalPriority = 1;
                  } else if (selectedPriority.value == 'Medium') {
                    finalPriority = 2;
                  } else {
                    finalPriority = 3;
                  }
                  CollectionReference ref = FirebaseFirestore.instance
                      .collection('tasks');
                  await ref.add({
                    'parent': getStorge.read('id'),
                    'parentName': getStorge.read('fullName'),
                    'name': taskName,
                    'description': taskDescription,
                    'date': selectedDate.text,
                    ...assignmentFields(
                      selected: selectedDependents,
                      dependents: dependents,
                      takeTurns: takeTurns.value && repeat.value != 'none',
                      existing: null,
                    ),
                    'time': selectedTime.text,
                    'dueAt': _dueAt(),
                    'remindBefore': remindBefore.value,
                    'repeat': repeat.value,
                    'priority': finalPriority,
                  });
                  isLoading.value = false;
                  showCustomSnackBarSuccess(
                    "Task added successfully",
                    title: "success",
                  );
                  isSuccess.value = true;
                  reset();
                  Get.offAllNamed(Routes.BOTTOMNAVIGATIION);
                } catch (e) {
                  isLoading.value = false;
                  showCustomSnackBar(
                    'Unexpected error occured',
                    title: "Error",
                  );
                }
              } else {
                isLoading.value = false;
                showCustomSnackBar('Dependent is required', title: "Error");
              }
            } else {
              isLoading.value = false;
              showCustomSnackBar('Time is required', title: "Error");
            }
          } else {
            isLoading.value = false;
            showCustomSnackBar('Date is required', title: "Error");
          }
        } else {
          isLoading.value = false;
          showCustomSnackBar('Priority is required', title: "Error");
        }
      } else {
        isLoading.value = false;
        showCustomSnackBar('Description is required', title: "Error");
      }
    } else {
      isLoading.value = false;
      showCustomSnackBar('Task Name is required', title: "Error");
    }
  }

  Timestamp? _dueAt() {
    final due = parseDue(selectedDate.text, selectedTime.text);
    return due == null ? null : Timestamp.fromDate(due);
  }

  void setSelectedPriority(String Value) {
    selectedPriority.value = Value;
  }
}
