import 'package:remindmi/app/components/overdue_badge.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/show_custome_snack_bar.dart';
import 'package:remindmi/app/services/firestore_db.dart';
import 'package:remindmi/constants/images.dart';
import 'package:remindmi/constants/priorityColor.dart';

class DependentTaskCardWithCheckbox extends StatefulWidget {
  final row;
  final int index;
  final getStorge = GetStorage();

  DependentTaskCardWithCheckbox({
    Key? key,
    required this.index,
    required this.row,
  }) : super(key: key);

  @override
  State<DependentTaskCardWithCheckbox> createState() => _DependentTaskCardWithCheckboxState();
}

class _DependentTaskCardWithCheckboxState extends State<DependentTaskCardWithCheckbox> {
  bool isCompleting = false;

  Future<void> completeTask() async {
    if (isCompleting) return;
    
    setState(() {
      isCompleting = true;
    });

    try {
      await FireStoreDB().completeTask(widget.row.id);

      showCustomSnackBarSuccess("Task completed successfully!", title: "Great job!");
    } catch (e) {
      showCustomSnackBar('Error completing task: ${e.toString()}', title: "Error");
    } finally {
      if (mounted) {
        setState(() {
          isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Checkbox for task completion
            GestureDetector(
              onTap: completeTask,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleting ? Colors.grey : Colors.green,
                    width: 2,
                  ),
                  color: isCompleting ? Colors.grey[200] : Colors.transparent,
                ),
                child: isCompleting
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20,
                      ),
              ),
            ),
            SizedBox(width: 12),
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
                  Row(children: [
                    Text(
                      widget.row.time + ' ' + widget.row.date,
                      style: TextStyle(
                        color: prioritySubTitle(widget.row.priority),
                        fontSize: 14,
                      ),
                    ),
                    OverdueBadge(row: widget.row),
                  ]),
                  SizedBox(height: 6),
                  Text(
                    widget.row.name,
                    style: TextStyle(
                      color: priorityTitile(widget.row.priority),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.row.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: prioritySubTitle(widget.row.priority),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(children: [
                    Text(
                      'Assigned By: ',
                      style: TextStyle(
                        color: priorityTitile(widget.row.priority),
                      ),
                    ),
                    Text(
                      widget.row.parentName,
                      style: TextStyle(
                        color: priorityTitile(widget.row.priority),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "(" +
                            (widget.row.priority == 1
                                ? ('High')
                                : (widget.row.priority == 2 ? 'Medium' : 'Low')) +
                            ")",
                        style: TextStyle(
                          color: priorityTitile(widget.row.priority),
                        ),
                      ),
                    )
                  ])
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: priorityBorder(widget.row.priority),
            width: 4,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 218, 218, 218),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
      ),
    );
  }
}