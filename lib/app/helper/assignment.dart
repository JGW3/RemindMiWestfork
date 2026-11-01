import 'package:remindmi/app/models/add_task_dependent_list_model.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';

// Builds a task's assignment fields from the children checked on the add/edit
// form. With takeTurns, only one child holds the task at a time and `rotation`
// keeps the order; completing it passes it on (FireStoreDB.completeTask).
Map<String, dynamic> assignmentFields({
  required List selected,
  required List<Dependent> dependents,
  required bool takeTurns,
  Task? existing,
}) {
  final entries = selected.map((element) {
    final id = element['dep'] as String;
    final known = dependents.where((d) => d.id == id).firstOrNull;
    final before = existing?.dependentList
        .where((d) => d.dep == id)
        .firstOrNull;
    return {
      'dep': id,
      'depName': known?.name ?? element['depName'] ?? before?.depName ?? '',
      // Editing shouldn't undo a child's checkmark
      'status': before?.status ?? false,
    };
  }).toList();
  final ids = entries.map((e) => e['dep'] as String).toList();

  if (!takeTurns || entries.length < 2) {
    return {'dependent': entries, 'dependentIds': ids, 'rotation': <String>[]};
  }
  // Keep whoever currently has the turn, if they're still in the rotation
  final holder = existing?.dependentList.firstOrNull?.dep;
  final current = entries.firstWhere(
    (e) => e['dep'] == holder,
    orElse: () => entries.first,
  );
  return {
    'dependent': [current],
    'dependentIds': [current['dep']],
    'rotation': ids,
  };
}
