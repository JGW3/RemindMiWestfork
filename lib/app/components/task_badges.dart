import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/task_options.dart';
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

// Small "↻ Daily" style label for repeating tasks.
class RepeatBadge extends StatelessWidget {
  final Task row;

  const RepeatBadge({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label = repeatShortLabels[row.repeat];
    if (label == null) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.repeat,
            size: 14,
            color: Color.fromARGB(255, 101, 152, 254),
          ),
          SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 101, 152, 254),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// "6:00 PM 11/3/2026", or a placeholder for as-needed tasks with no due time.
String dueText(Task row, {String separator = ' '}) =>
    row.date.isEmpty && row.time.isEmpty
    ? 'Whenever needed'
    : row.time + separator + row.date;

String _shortDate(DateTime at) =>
    '${at.month}/${at.day} ${at.hour}:${at.minute.toString().padLeft(2, '0')}';

// "Last done by Sam · 11/3 18:05" on cards for repeating tasks.
class LastDone extends StatelessWidget {
  final Task row;

  const LastDone({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isRepeating(row.repeat) || row.history.isEmpty) {
      return SizedBox.shrink();
    }
    final last = row.history.first;
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text(
        'Last done by ${last.depName}'
        '${last.at == null ? '' : ' · ${_shortDate(last.at!)}'}',
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }
}

// Who did it, newest first, for the task detail sheets. Settles arguments.
class CompletionHistory extends StatelessWidget {
  final Task row;

  const CompletionHistory({Key? key, required this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (row.history.isEmpty) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Done by',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          for (final entry in row.history)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '${entry.depName}'
                '${entry.at == null ? '' : '  ·  ${_shortDate(entry.at!)}'}',
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),
              ),
            ),
        ],
      ),
    );
  }
}

// What "Read aloud" says for a task.
String spokenTask(Task row) {
  final due = dueText(row, separator: ', ');
  return [
    row.name,
    if (row.description.isNotEmpty) row.description,
    due == 'Whenever needed' ? due : 'Due $due',
  ].join('. ');
}
