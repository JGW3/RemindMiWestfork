import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/task_list_card.dart';
import 'package:remindmi/app/components/task_view.dart';
import 'package:remindmi/app/helper/utils.dart';
import 'package:remindmi/app/modules/addtask/add_task_view.dart';
import 'package:remindmi/app/modules/home_task_list_page/home_task_list_controller.dart';
//_________________IT IS PARENT'S HOME TASK LIST PAGE ____________________//

class HomeTaskListViews extends StatefulWidget {
  @override
  State<HomeTaskListViews> createState() => _HomeTaskListViewsState();
}

class _HomeTaskListViewsState extends State<HomeTaskListViews> {
  final home_task_controller = Get.put(HomeTaskListController(taskStatus: ParentTaskStatus.incomplete));
  final home_task_controller2 = Get.put(HomeTaskListController(taskStatus: ParentTaskStatus.complete), tag: 'completed');
  final getStorge = GetStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 32,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Hi ',
                        style: GoogleFonts.dmSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Text(
                        GetFirtsName(
                          getStorge.read('fullName'),
                        ),
                        style: GoogleFonts.dmSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Image.asset(
                        'assets/images/emoji.png',
                        height: 35,
                        width: 35,
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 11,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/chotu.png',
                        height: 39,
                        width: 39,
                      ),
                      Text(
                        'Running Tasks',
                        style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 69, 69, 209),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (home_task_controller.tasks.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                                  row: home_task_controller.tasks[index],
                                  from: 'home');
                            },
                          );
                        },
                        child: TaskListCard(
                          index: index,
                          row: home_task_controller.tasks[index],
                        ),
                      );
                    },
                    childCount: home_task_controller.tasks.length,
                  ),
                ),
              if (home_task_controller.tasks.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 56,
                  ),
                ),
              if (home_task_controller.tasks.isEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'You do not have any assigned tasks',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 69, 69, 209),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/chotu.png',
                        height: 39,
                        width: 39,
                      ),
                      Text(
                        'Completed Tasks',
                        style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 69, 69, 209),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                                row: home_task_controller2.tasks[index],
                                from: 'home');
                          },
                        );
                      },
                      child: TaskListCard(
                        index: index,
                        row: home_task_controller2.tasks[index],
                      ),
                    );
                  },
                  childCount: home_task_controller2.tasks.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 3, 163, 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: Icon(Icons.add_circle_outlined),
          label: Text(
            'Add Task',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Get.to(AddTaskView());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
