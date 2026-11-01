import 'package:remindmi/app/components/task_badges.dart';
import 'package:remindmi/app/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindmi/app/modules/edit_task/edit_task_controller.dart';
import 'package:remindmi/app/modules/edit_task/edit_task_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:get_storage/get_storage.dart';

class TaskViewCard extends StatelessWidget {
  final int indexNo;
  final row;
  final String from;
  final getStorge = GetStorage();

  TaskViewCard({
    Key? key,
    required this.indexNo,
    required this.row,
    required this.from,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(18, 16, 0, 17),
                    child: Text(
                      row.name,
                      style: GoogleFonts.dmSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: new IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (getStorge.read('role') == 'parent') ...[
              Container(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(16, 14, 0, 0),
                      child: Text(
                        'Assign to',
                        style: GoogleFonts.dmSans(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: List.generate(row.dependent, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          UserAvatar(uid: row.dependentList[index].dep),
                          SizedBox(width: 16),
                          Align(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.dependentList[index].depName,
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  padding: EdgeInsets.fromLTRB(17, 5, 15, 5),
                                  child: Text(
                                    (row.dependentList[index].status
                                        ? ('Completed')
                                        : ('Pending')),
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 56, 167),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    color: Color.fromARGB(255, 237, 243, 255),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 14, 0, 0),
              child: Text(
                'Assign From',
                style: GoogleFonts.dmSans(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            //parents list start
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    UserAvatar(uid: row.parent),
                    SizedBox(width: 16),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.parentName,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            width: 120,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            padding: EdgeInsets.fromLTRB(17, 5, 15, 5),
                            child: Text(
                              'Assigner',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 56, 167),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Color.fromARGB(255, 237, 243, 255),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 14, 0, 6),
              child: Text(
                'Task Description',
                style: GoogleFonts.dmSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 79, 89, 107),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                row.description,
                style: GoogleFonts.dmSans(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(16, 0, 0, 6),
              child: Text(
                'Task Time',
                style: GoogleFonts.dmSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 79, 89, 107),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                dueText(row, separator: ', '),
                style: GoogleFonts.dmSans(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            CompletionHistory(row: row),
            if (from == 'home') ...[
              Container(
                margin: EdgeInsets.fromLTRB(16, 47, 16, 43),
                child: Row(
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        fillColor: Color.fromRGBO(27, 28, 54, 1.0),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          Get.delete<EditTaskController>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditTaskView(row: row);
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_note_outlined, color: Colors.white),
                            Container(
                              height: 52,
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  " Edit",
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
                    SizedBox(height: 52, width: 12),
                    Expanded(
                      child: RawMaterialButton(
                        fillColor: Color.fromRGBO(255, 75, 75, 1.0),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(row.id)
                                .delete();
                            Get.back();
                          } catch (e) {
                            showCustomSnackBar(e.toString(), title: "Error");
                          }
                          // addTaskController.de
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, color: Colors.white),
                            Container(
                              height: 52,
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  " Delete",
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
                  ],
                ),
              ),
            ] else ...[
              SizedBox(height: 52),
            ],
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }
}
