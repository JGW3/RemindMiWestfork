import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindmi/app/helper/due_date.dart';

class Task {
  final String name;
  final String description;
  final String date;
  final String time;
  final int priority;
  final String parentName;
  final String id;
  final String parent;
  // Exact due moment; null if the stored date/time can't be parsed
  final DateTime? dueAt;
  // Minutes before dueAt for an early reminder; 0 = none
  final int remindBefore;
  // 'none' | 'daily' | 'weekdays' | 'weekly' (see helper/task_options.dart)
  final String repeat;
  // Turn order for 'Take turns' tasks (uids); empty when everyone does it
  final List<String> rotation;
  // Most recent check-offs, newest first (kept to the last 10)
  final List<Completion> history;

  final List depenListString;
  int dependent = 0;
  final List<DependentList> dependentList;

  Task({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.dependent,
    required this.priority,
    required this.dependentList,
    required this.parentName,
    required this.parent,
    required this.depenListString,
    required this.id,
    this.dueAt,
    this.remindBefore = 0,
    this.repeat = 'none',
    this.rotation = const [],
    this.history = const [],
  });

  // depId == null checks whether anyone assigned is still unfinished
  bool isOverdueFor(String? depId) =>
      dueAt != null &&
      dueAt!.isBefore(DateTime.now()) &&
      dependentList.any(
        (element) => !element.status && (depId == null || element.dep == depId),
      );

  static Task fromSnapshot(DocumentSnapshot snap) {
    if (snap.data().toString().contains('dependent')) {}

    List<dynamic> depList = snap['dependent'];
    final data = snap.data() as Map<String, dynamic>;
    final dueAt = data['dueAt'] is Timestamp
        ? (data['dueAt'] as Timestamp).toDate()
        : parseDue(snap['date'], snap['time']);

    Task task = Task(
      //Modal of task is created here which contains all the information related to taska
      id: snap.reference.id,
      name: snap['name'],
      description: snap['description'],
      time: snap['time'],
      priority: snap['priority'],
      parentName: snap['parentName'],
      parent: snap['parent'],
      dependent: (snap.data().toString().contains('dependent')
          ? snap['dependent'].length
          : 0),
      date: snap['date'],
      dependentList: depList
          .map((doc) => DependentList.fromdepListModal(doc))
          .toList(),
      depenListString: depList,
      dueAt: dueAt,
      remindBefore: (data['remindBefore'] as num?)?.toInt() ?? 0,
      repeat: data['repeat'] as String? ?? 'none',
      rotation: List<String>.from(data['rotation'] ?? const []),
      history: [
        for (final entry in (data['history'] as List? ?? const []))
          Completion.fromMap(entry),
      ],
    );
    return task;
  }
}

class DependentList {
  final String dep;
  final String depName;
  final bool status;

  DependentList({
    required this.dep,
    required this.depName,
    required this.status,
  });

  static DependentList fromdepListModal(var snap) {
    DependentList dependentList = DependentList(
      // modal of dependent list is created here which contains the details of dependent
      dep: snap['dep'],
      depName: snap['depName'],
      status: snap['status'],
    );
    return dependentList;
  }
}

class Completion {
  final String dep;
  final String depName;
  final DateTime? at;

  const Completion({required this.dep, required this.depName, this.at});

  static Completion fromMap(dynamic map) => Completion(
    dep: map['dep'] ?? '',
    depName: map['depName'] ?? '',
    at: map['at'] is Timestamp ? (map['at'] as Timestamp).toDate() : null,
  );
}
