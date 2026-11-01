import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/task_list_card.dart';
import 'package:remindmi/app/components/task_view.dart';
import 'package:remindmi/app/modules/all_task_list/all_task_list_controller.dart';

//___________IT IS ALL TASK PAGE____________//

class AllTaskListView extends StatefulWidget {
  const AllTaskListView({super.key});
  @override
  State<AllTaskListView> createState() => _AllTaskListViewState();
}

class _AllTaskListViewState extends State<AllTaskListView> {
  final allTaskListController = Get.put(AllTaskListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
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
                  'All Tasks',
                  style: GoogleFonts.dmSans(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => Container(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: allTaskListController.tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onLongPress: () {
                            print(index);
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return TaskViewCard(
                                  indexNo: index,
                                  row: allTaskListController.tasks[index],
                                  from: 'allTask',
                                );
                              },
                            );
                          },
                          child: TaskListCard(
                            index: index,
                            row: allTaskListController.tasks[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
