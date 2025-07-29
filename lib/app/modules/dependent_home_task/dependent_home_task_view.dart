import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/components/dependent_task_view.dart';
import 'package:remindmi/app/components/task_list_card.dart';
import 'package:remindmi/app/components/dependent_task_card_with_checkbox.dart';
import 'package:remindmi/app/helper/utils.dart';
import 'package:remindmi/app/modules/dependent_home_task/dependent_home_task_controller.dart';

//______IT IS DEPENDENT'S HOME PAGE____________//
class DependentHomeTaskListViews extends StatelessWidget {
  DependentHomeTaskListViews({super.key});
  final getStorge = GetStorage();

  final dependent_home_task_controller =
      Get.put(DependentHomeTaskListController(taskStatus: TaskStatus.incomplete));
  final dependent_home_task_controller2 = Get.put(DependentHomeTaskListController(taskStatus: TaskStatus.complete), tag: 'completed');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (dependent_home_task_controller.tasks.isNotEmpty)
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
                          return DependentTaskViewCard(
                            indexNo: index,
                            row: dependent_home_task_controller.tasks[index],
                          );
                        },
                      );
                    },
                    child: DependentTaskCardWithCheckbox(
                      index: index,
                      row: dependent_home_task_controller.tasks[index],
                    ),
                  );
                },
                childCount: dependent_home_task_controller.tasks.length,
              ),
            ),
          if (dependent_home_task_controller.tasks.isEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 56,
              ),
            ),
          if (dependent_home_task_controller.tasks.isEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Yay! you have completed all your task',
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
                        return DependentTaskViewCard(
                          indexNo: index,
                          row: dependent_home_task_controller2.tasks[index],
                        );
                      },
                    );
                  },
                  child: TaskListCard(
                    index: index,
                    row: dependent_home_task_controller2.tasks[index],
                  ),
                );
              },
              childCount: dependent_home_task_controller2.tasks.length,
            ),
          ),
        ],
      ),
    ));
  }
}
