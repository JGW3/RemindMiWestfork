import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remindmi/app/helper/due_date.dart';
import 'package:remindmi/app/helper/task_options.dart';
import 'package:remindmi/app/models/add_task_dependent_list_model.dart';
import 'package:remindmi/app/models/home_task_list_model.dart';

class FireStoreDB {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final getStorge = GetStorage();

  // The signed-in user's uid. Prefer Firebase Auth over local storage so
  // queries always match what the security rules see.
  String? get _uid =>
      FirebaseAuth.instance.currentUser?.uid ?? getStorge.read('id');

  // Tasks are sorted on the client so the queries below don't need
  // composite Firestore indexes: soonest due first, then by priority.
  List<Task> _sorted(QuerySnapshot snapshot) {
    final tasks = snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    tasks.sort((a, b) {
      if (a.dueAt != b.dueAt) {
        if (a.dueAt == null) return 1;
        if (b.dueAt == null) return -1;
        return a.dueAt!.compareTo(b.dueAt!);
      }
      return a.priority.compareTo(b.priority);
    });
    return tasks;
  }

  Stream<List<Task>> _parentTasks() {
    // tasks are in collection named as 'tasks' in firebase
    return _firebaseFirestore
        .collection('tasks')
        .where('parent', isEqualTo: _uid)
        .snapshots()
        .map(_sorted);
  }

  Stream<List<Task>> _dependentTasks() {
    // 'dependentIds' mirrors the dep ids inside 'dependent' so children can
    // query only the tasks assigned to them
    return _firebaseFirestore
        .collection('tasks')
        .where('dependentIds', arrayContains: _uid)
        .snapshots()
        .map(_sorted);
  }

  bool _myStatus(Task task, bool status) => task.dependentList.any(
    (element) => element.dep == _uid && element.status == status,
  );

  Stream<List<Task>> getAllTasks() {
    //all incomplete and completed tasks are fetched from firebase to all task page
    if (getStorge.read('role') == 'dependent') {
      return _dependentTasks();
    }
    return _parentTasks();
  }

  Stream<List<Task>> parentGetInCompleteTasks() {
    //tasks where at least one assigned dependent hasn't finished yet
    return _parentTasks().map(
      (tasks) => tasks
          .where(
            (task) =>
                task.dependentList.any((element) => element.status == false),
          )
          .toList(),
    );
  }

  Stream<List<Task>> parentGetCompleteTasks() {
    //tasks every assigned dependent has finished
    return _parentTasks().map(
      (tasks) => tasks
          .where(
            (task) =>
                task.dependentList.isNotEmpty &&
                task.dependentList.every((element) => element.status == true),
          )
          .toList(),
    );
  }

  Stream<List<Dependent>> getAllDependentAddTask() {
    // In add task page there lies list of dependent which is fetched by this function
    // Here names of depedendent are stored in collection 'user' where they are filtered by their role
    return _firebaseFirestore
        .collection('users')
        .where('parent', isEqualTo: _uid)
        .where('role', isEqualTo: 'dependent')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Dependent.fromSnapshot(doc)).toList(),
        );
  }

  Stream<List<Task>> dependentHomeGetIncompleteTasks() {
    // Here the task list of depedndent on their respective home screen are fetched from collection 'tasks'
    return _dependentTasks().map(
      (tasks) => tasks.where((task) => _myStatus(task, false)).toList(),
    );
  }

  Stream<List<Task>> dependentHomeGetCompleteTasks() {
    return _dependentTasks().map(
      (tasks) => tasks.where((task) => _myStatus(task, true)).toList(),
    );
  }

  // Marks the current dependent's entry as done. Runs in a transaction so two
  // children finishing the same task at once don't overwrite each other.
  // For a repeating task, the last child to finish rolls it over: scheduled
  // repeats move to their next date (returned), and turn-taking tasks pass to
  // the next child in the rotation; otherwise everyone resets to not done.
  Future<DateTime?> completeTask(String taskId) async {
    final ref = _firebaseFirestore.collection('tasks').doc(taskId);
    final uid = _uid;
    return _firebaseFirestore.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final data = snap.data()!;
      final List deps = List.from(data['dependent']);
      var updated = deps
          .map(
            (element) => element['dep'] == uid
                ? {...Map<String, dynamic>.from(element), 'status': true}
                : element,
          )
          .toList();
      final mine = deps.firstWhere((element) => element['dep'] == uid,
          orElse: () => null);
      final completion = {
        'dep': uid,
        'depName': mine?['depName'] ?? getStorge.read('fullName'),
        // serverTimestamp isn't allowed inside arrays, so use the phone's clock
        'at': Timestamp.now(),
      };
      final update = <String, dynamic>{
        // The Cloud Function watches this to tell the parent who finished
        'lastCompletion': completion,
        'history': [completion, ...List.from(data['history'] ?? const [])]
            .take(10)
            .toList(),
      };

      final repeat = data['repeat'] as String? ?? 'none';
      final due = data['dueAt'] is Timestamp
          ? (data['dueAt'] as Timestamp).toDate()
          : parseDue('${data['date']}', '${data['time']}');
      DateTime? next;
      final everyoneDone =
          updated.every((element) => element['status'] == true);
      if (isRepeating(repeat) && everyoneDone) {
        if (hasSchedule(repeat) && due != null) {
          next = nextOccurrence(due, repeat, DateTime.now());
          update['dueAt'] = Timestamp.fromDate(next);
          update['date'] = formatTaskDate(next);
        }
        final rotation = List<String>.from(data['rotation'] ?? const []);
        if (rotation.length > 1) {
          // Pass the task to whoever is next in line
          final at = rotation.indexOf(uid ?? '');
          final nextId = rotation[(at + 1) % rotation.length];
          final nextUser =
              await transaction.get(_firebaseFirestore.collection('users').doc(nextId));
          updated = [
            {
              'dep': nextId,
              'depName': nextUser.data()?['fullName'] ?? '',
              'status': false,
            }
          ];
          update['dependentIds'] = [nextId];
        } else {
          updated = updated
              .map((element) =>
                  {...Map<String, dynamic>.from(element), 'status': false})
              .toList();
        }
      }

      update['dependent'] = updated;
      transaction.update(ref, update);
      return next;
    });
  }

  Future<void> backfillParentTasks() async {
    // Tasks saved before dependentIds/dueAt existed are invisible to children
    // and have no exact due time; fill those fields in from the old ones.
    final snapshot = await _firebaseFirestore
        .collection('tasks')
        .where('parent', isEqualTo: _uid)
        .get();
    final batch = _firebaseFirestore.batch();
    var changed = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final update = <String, dynamic>{};
      if (data['dependentIds'] == null) {
        update['dependentIds'] = dependentIdsOf(data['dependent'] ?? []);
      }
      if (data['dueAt'] == null) {
        final due = parseDue('${data['date']}', '${data['time']}');
        if (due != null) update['dueAt'] = Timestamp.fromDate(due);
      }
      if (update.isNotEmpty) {
        batch.update(doc.reference, update);
        changed++;
      }
    }
    if (changed > 0) await batch.commit();
  }

  static List<String> dependentIdsOf(List selectedDependents) =>
      selectedDependents.map((element) => element['dep'] as String).toList();

  Future<void> createDependent(
    String fullName,
    String email,
    String password,
  ) async {
    // Creating a user with the default FirebaseAuth instance would sign the
    // parent out and sign the new child in. A throwaway secondary app keeps
    // the parent's session intact.
    final parentUid = FirebaseAuth.instance.currentUser!.uid;
    final secondary = await Firebase.initializeApp(
      name: 'dependent-signup-${DateTime.now().millisecondsSinceEpoch}',
      options: Firebase.app().options,
    );
    try {
      final credential = await FirebaseAuth.instanceFor(
        app: secondary,
      ).createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseFirestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'parent': parentUid,
            'fullName': fullName,
            'email': email,
            'role': 'dependent',
          });
      await FirebaseAuth.instanceFor(app: secondary).signOut();
    } finally {
      await secondary.delete();
    }
  }
}
