import 'package:remindmi/app/components/task_badges.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/components/home_page_user_avatar.dart';
import 'package:remindmi/constants/images.dart';
import 'package:remindmi/constants/priorityColor.dart';

class TaskListCard extends StatelessWidget {
  final row;

  final int index;
  final getStorge = GetStorage();

  TaskListCard({Key? key, required this.index, required this.row})
    : super(key: key);

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
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        dueText(row),
                        style: TextStyle(
                          color: prioritySubTitle(row.priority),
                          fontSize: 14,
                        ),
                      ),
                      OverdueBadge(row: row),
                      RepeatBadge(row: row),
                    ],
                  ),
                  LastDone(row: row),
                  SizedBox(height: 6),
                  Text(
                    row.name,
                    style: TextStyle(
                      color: priorityTitile(row.priority),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    row.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: prioritySubTitle(row.priority),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (getStorge.read('role') == 'dependent') ...[
                    Row(
                      children: [
                        Text(
                          'Assigned By:',
                          style: TextStyle(color: priorityTitile(row.priority)),
                        ),
                        Text(
                          row.parentName,
                          style: TextStyle(color: priorityTitile(row.priority)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "(" +
                                (row.priority == 1
                                    ? ('High')
                                    : (row.priority == 2 ? 'Medium' : 'Low')) +
                                ")",
                            style: TextStyle(
                              color: priorityTitile(row.priority),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    if (row.dependent == 1) ...[
                      Row(
                        children: [
                          HomePageUserAvatar(
                            uid: row.dependentList.isEmpty
                                ? null
                                : row.dependentList.first.dep,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(
                              "(" +
                                  (row.priority == 1
                                      ? ('High')
                                      : (row.priority == 2
                                            ? 'Medium'
                                            : 'Low')) +
                                  ")",
                              style: TextStyle(
                                color: priorityTitile(row.priority),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              HomePageUserAvatar(
                                uid: row.dependentList.isEmpty
                                    ? null
                                    : row.dependentList.first.dep,
                              ),
                              new Positioned(
                                left: 15.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    color: Colors.blue,
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          101,
                                          152,
                                          254,
                                        ),
                                        radius: 30,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 11,
                                          child: Text(row.dependent.toString()),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "(" +
                                  (row.priority == 1
                                      ? ('High')
                                      : (row.priority == 2
                                            ? 'Medium'
                                            : 'Low')) +
                                  ")",
                              style: TextStyle(
                                color: priorityTitile(row.priority),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: priorityBorder(row.priority), width: 4),
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
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
