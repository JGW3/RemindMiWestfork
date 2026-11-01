import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/due_date.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/models/add_task_dependent_list_model.dart';
import 'package:remindmi/app/routes/app_pages.dart';
import 'package:remindmi/app/services/firestore_db.dart';

class EditTaskController extends GetxController {
  var row;

  EditTaskController(this.row);
  final getStorge = GetStorage();
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var selectedPriority = 'Select Priority'.obs;
  var remindBefore = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController selectedDate = TextEditingController();
  TextEditingController selectedTime = TextEditingController();
  final dependents = <Dependent>[].obs;
  List selectedDependents = [].obs;
  List<String> priorityList = ['Select Priority', 'High', 'Medium', 'Low'];

  @override
  void onInit() {
    super.onInit();

    // preloaded data while clicking edit is done on oninit ...
    dependents.bindStream(FireStoreDB().getAllDependentAddTask());
    nameController.text = row.name;
    descriptionController.text = row.description;
    selectedPriority.value = (row.priority == 1
        ? 'High'
        : (row.priority == 2 ? 'Medium' : 'Low'));
    selectedDate.text = row.date;
    selectedTime.text = row.time;
    remindBefore.value = row.remindBefore;
    selectedDependents.addAll(row.depenListString);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  reset() {
    selectedDependents = [].obs;
  }

  void onEditTask(
    //this function is used to edit the task
    String taskName,
    String taskDescription,
  ) async {
    isLoading.value = true;
    if (taskName != '') {
      if (taskDescription != '') {
        if (selectedPriority.value != 'Select Priority') {
          if (selectedDate.text != '') {
            if (selectedTime.text != '') {
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
                  final ref = FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(row.id);
                  await ref.set({
                    'parent': getStorge.read('id'),
                    'parentName': getStorge.read('fullName'),
                    'name': taskName,
                    'description': taskDescription,
                    'date': selectedDate.text,
                    'dependent': selectedDependents,
                    'dependentIds': FireStoreDB.dependentIdsOf(
                      selectedDependents,
                    ),
                    'time': selectedTime.text,
                    'dueAt': _dueAt(),
                    'remindBefore': remindBefore.value,
                    'priority': finalPriority,
                  });
                  isLoading.value = false;
                  showCustomSnackBarSuccess(
                    "Task edited successfully",
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
