import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ChildListCard extends StatelessWidget {
  final int index;
  final row;
  final String from;
  final getStorge = GetStorage();

  ChildListCard({
    Key? key,
    required this.index,
    required this.row,
    required this.from,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (from == 'add') {
      return Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: CheckboxListTile(
            checkboxShape: CircleBorder(),
            side: BorderSide(
              color: Color.fromARGB(255, 24, 90, 219),
              width: 1.5,
            ),
            activeColor: Color.fromARGB(255, 24, 90, 219),
            controlAffinity: ListTileControlAffinity.leading,
            value: !row.selectedDependents
                .where((element) => element['dep'] == row.dependents[index].id)
                .isEmpty,
            onChanged: (value) {
              if (value == true) {
                row.selectedDependents.add({
                  'dep': row.dependents[index].id,
                  'depName': row.dependents[index].name,
                  'status': false,
                });
              } else {
                row.selectedDependents.removeWhere(
                  (element) => element['dep'] == row.dependents[index].id,
                );
              }
            },
            title: Container(
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
                            row.dependents[index].name,
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
        ),
      );
    } else {
      return Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: CheckboxListTile(
            checkboxShape: CircleBorder(),
            side: BorderSide(
              color: Color.fromARGB(255, 24, 90, 219),
              width: 1.5,
            ),
            activeColor: Color.fromARGB(255, 24, 90, 219),
            controlAffinity: ListTileControlAffinity.leading,
            value: !row.selectedDependents
                .where((element) => element['dep'] == row.dependents[index].id)
                .isEmpty,
            onChanged: (value) {
              if (value == true) {
                row.selectedDependents.add({
                  'dep': row.dependents[index].id,
                  'depName': row.dependents[index].name,
                  'status': false,
                });
              } else {
                row.selectedDependents.removeWhere(
                  (element) => element['dep'] == row.dependents[index].id,
                );
              }
            },
            title: Container(
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
                            row.dependents[index].name,
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
        ),
      );
    }
  }
}
