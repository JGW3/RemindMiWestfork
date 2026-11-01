import 'package:flutter_test/flutter_test.dart';
import 'package:remindmi/app/helper/assignment.dart';
import 'package:remindmi/app/helper/task_options.dart';
import 'package:remindmi/app/models/add_task_dependent_list_model.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';

void main() {
  group('nextOccurrence', () {
    // Monday 2 Nov 2026, 6 PM
    final due = DateTime(2026, 11, 2, 18);

    test('daily moves to the next day', () {
      expect(
        nextOccurrence(due, 'daily', DateTime(2026, 11, 2, 18, 30)),
        DateTime(2026, 11, 3, 18),
      );
    });

    test('skips missed days instead of piling up', () {
      expect(
        nextOccurrence(due, 'daily', DateTime(2026, 11, 5, 9)),
        DateTime(2026, 11, 5, 18),
      );
    });

    test('every 2 days skips a day', () {
      expect(
        nextOccurrence(due, 'everyOtherDay', DateTime(2026, 11, 2, 19)),
        DateTime(2026, 11, 4, 18),
      );
    });

    test('weekdays skips the weekend', () {
      final friday = DateTime(2026, 11, 6, 18);
      expect(
        nextOccurrence(friday, 'weekdays', DateTime(2026, 11, 6, 19)),
        DateTime(2026, 11, 9, 18),
      );
    });

    test('weekly keeps the weekday and wall-clock time across DST', () {
      // US DST ends 1 Nov 2026; 6 PM stays 6 PM
      final before = DateTime(2026, 10, 26, 18);
      expect(
        nextOccurrence(before, 'weekly', DateTime(2026, 10, 27)),
        DateTime(2026, 11, 2, 18),
      );
    });
  });

  group('assignmentFields', () {
    const kids = [
      Dependent(name: 'Sam', id: 'sam'),
      Dependent(name: 'Ali', id: 'ali'),
    ];
    final selected = [
      {'dep': 'sam', 'depName': '', 'status': false},
      {'dep': 'ali', 'depName': '', 'status': false},
    ];

    test('everyone does it: all assigned, no rotation', () {
      final f = assignmentFields(
        selected: selected,
        dependents: kids,
        takeTurns: false,
      );
      expect(f['dependentIds'], ['sam', 'ali']);
      expect(f['rotation'], isEmpty);
      expect((f['dependent'] as List).map((e) => e['depName']), ['Sam', 'Ali']);
    });

    test('take turns: first child holds it, rotation keeps order', () {
      final f = assignmentFields(
        selected: selected,
        dependents: kids,
        takeTurns: true,
      );
      expect(f['dependentIds'], ['sam']);
      expect(f['rotation'], ['sam', 'ali']);
    });

    test('editing a turn-taking task keeps the current holder', () {
      final existing = Task(
        id: 't',
        name: '',
        description: '',
        date: '',
        time: '',
        dependent: 1,
        priority: 1,
        parent: 'mom',
        parentName: '',
        depenListString: const [],
        dependentList: [
          DependentList(dep: 'ali', depName: 'Ali', status: false),
        ],
        rotation: const ['sam', 'ali'],
      );
      final f = assignmentFields(
        selected: selected,
        dependents: kids,
        takeTurns: true,
        existing: existing,
      );
      expect(f['dependentIds'], ['ali']);
    });
  });
}
