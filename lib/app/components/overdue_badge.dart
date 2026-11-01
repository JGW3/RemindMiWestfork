import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';

// Red "Overdue" pill shown next to a task's due time. Children see it for
// their own unfinished part of the task; parents see it if anyone is unfinished.
class OverdueBadge extends StatelessWidget {
  final Task row;

  const OverdueBadge({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final forDependent = storage.read('role') == 'dependent'
        ? storage.read('id')
        : null;
    if (!row.isOverdueFor(forDependent)) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.only(left: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 75, 75, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Overdue',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
