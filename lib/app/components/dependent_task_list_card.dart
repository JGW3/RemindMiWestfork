import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/modules/home_task_list_page/home_task_list_controller.dart';
import 'package:remindmi/app/components/home_page_user_avatar.dart';
import 'package:remindmi/constants/images.dart';
import 'package:remindmi/constants/priorityColor.dart';

class DependentTaskListCard extends StatelessWidget {
  final HomeTaskListController home_task_list_controller = Get.find();

  final int index;

  DependentTaskListCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              Images.remindmiIcon,
              height: 42,
              width: 42,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    home_task_list_controller.tasks[index].time +
                        ' ' +
                        home_task_list_controller.tasks[index].date,
                    style: TextStyle(
                      color: prioritySubTitle(
                        home_task_list_controller.tasks[index].priority,
                      ),
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    home_task_list_controller.tasks[index].name,
                    style: TextStyle(
                      color: priorityTitile(
                        home_task_list_controller.tasks[index].priority,
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    home_task_list_controller.tasks[index].description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: prioritySubTitle(
                        home_task_list_controller.tasks[index].priority,
                      ),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  HomePageUserAvatar(),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: priorityBorder(
              home_task_list_controller.tasks[index].priority,
            ),
            // width: 2,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 218, 218, 218),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
