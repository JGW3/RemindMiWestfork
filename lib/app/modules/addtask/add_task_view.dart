import 'package:remindmi/app/components/remind_before_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/modules/addtask/add_task_controller.dart';
import 'package:remindmi/app/components/child_list_card.dart';

//___________IT IS ADD TASK PAGE___________//

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  AddTaskController addTaskController = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    TextEditingController _taskNameController = TextEditingController(text: '');
    TextEditingController _taskDescriptionController = TextEditingController(
      text: '',
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 48),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: new IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'Add Task',
                style: GoogleFonts.dmSans(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.text,
                controller: _taskNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 17,
                    horizontal: 19,
                  ),
                  isDense: true,
                  hintText: "Task Name",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 101, 152, 254),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 101, 152, 254),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 156,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: _taskDescriptionController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 17,
                    horizontal: 19,
                  ),
                  isDense: true,
                  hintText: "Task Description",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 101, 152, 254),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 101, 152, 254),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: EdgeInsets.symmetric(),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(8.0),
                  iconEnabledColor: Color.fromARGB(255, 101, 152, 254),
                  iconDisabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  value: addTaskController.selectedPriority.value,
                  items: [
                    for (var data in addTaskController.priorityList)
                      DropdownMenuItem(
                        child: new Text(
                          '    ' + data,
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: data,
                      ),
                  ],
                  onChanged: (newValue) {
                    addTaskController.setSelectedPriority(newValue!);
                  },
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 101, 152, 254)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      readOnly: true,
                      controller: addTaskController.selectedDate,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 101, 152, 254),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 101, 152, 254),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        if (pickedDate != null) {
                          addTaskController.selectedDate.text =
                              '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      readOnly: true,
                      controller: addTaskController.selectedTime,
                      decoration: InputDecoration(
                        hintText: "Time",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 101, 152, 254),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 101, 152, 254),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          addTaskController.selectedTime.text = pickedTime
                              .format(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            RemindBeforeDropdown(value: addTaskController.remindBefore),
            SizedBox(height: 25),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                'Assign to',
                style: GoogleFonts.dmSans(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  itemCount: addTaskController.dependents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChildListCard(
                      index: index,
                      row: addTaskController,
                      from: 'add',
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 38),
              height: 60,
              child: Align(
                child: Obx(
                  () => RawMaterialButton(
                    fillColor: Color.fromRGBO(24, 90, 219, 1.0),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      addTaskController.onAddTask(
                        _taskNameController.text,
                        _taskDescriptionController.text,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (addTaskController.isLoading.value == true) ...[
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.5,
                          ),
                        ],
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Add Task",
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
