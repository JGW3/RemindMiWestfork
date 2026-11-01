import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remindmi/app/modules/addtask/add_task_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class NoCheckboxChildList extends StatelessWidget {
  final AddTaskController child_list_controller = Get.find();

  final int index;

  NoCheckboxChildList({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 101, 152, 254),
                  radius: 32,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset(
                      'assets/images/child.png',
                      height: 57,
                      width: 35,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        child_list_controller.dependents[index].name,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
