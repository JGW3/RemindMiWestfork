import 'package:flutter_test/flutter_test.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';

Task task(DateTime? dueAt, Map<String, bool> statuses) => Task(
  id: 't',
  name: 'Dishes',
  description: '',
  date: '',
  time: '',
  dependent: statuses.length,
  priority: 1,
  parent: 'mom',
  parentName: 'Mom',
  depenListString: const [],
  dependentList: [
    for (final e in statuses.entries)
      DependentList(dep: e.key, depName: e.key, status: e.value),
  ],
  dueAt: dueAt,
);

void main() {
  final past = DateTime.now().subtract(const Duration(hours: 1));
  final future = DateTime.now().add(const Duration(hours: 1));

  test('parent sees overdue while anyone is unfinished', () {
    expect(task(past, {'sam': true, 'ali': false}).isOverdueFor(null), isTrue);
    expect(task(past, {'sam': true, 'ali': true}).isOverdueFor(null), isFalse);
  });

  test('child only sees overdue for their own part', () {
    final t = task(past, {'sam': true, 'ali': false});
    expect(t.isOverdueFor('sam'), isFalse);
    expect(t.isOverdueFor('ali'), isTrue);
  });

  test('not overdue before due time or without one', () {
    expect(task(future, {'sam': false}).isOverdueFor(null), isFalse);
    expect(task(null, {'sam': false}).isOverdueFor(null), isFalse);
  });
}
