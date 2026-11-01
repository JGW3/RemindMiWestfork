import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
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
  // composite Firestore indexes.
  List<Task> _sorted(QuerySnapshot snapshot) {
    final tasks = snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    tasks.sort((a, b) => a.priority.compareTo(b.priority));
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

  bool _myStatus(Task task, bool status) => task.dependentList
      .any((element) => element.dep == _uid && element.status == status);

  Stream<List<Task>> getAllTasks() {
    //all incomplete and completed tasks are fetched from firebase to all task page
    if (getStorge.read('role') == 'dependent') {
      return _dependentTasks();
    }
    return _parentTasks();
  }

  Stream<List<Task>> parentGetInCompleteTasks() {
    //tasks where at least one assigned dependent hasn't finished yet
    return _parentTasks().map((tasks) => tasks
        .where((task) =>
            task.dependentList.any((element) => element.status == false))
        .toList());
  }

  Stream<List<Task>> parentGetCompleteTasks() {
    //tasks every assigned dependent has finished
    return _parentTasks().map((tasks) => tasks
        .where((task) =>
            task.dependentList.isNotEmpty &&
            task.dependentList.every((element) => element.status == true))
        .toList());
  }

  Stream<List<Dependent>> getAllDependentAddTask() {
    // In add task page there lies list of dependent which is fetched by this function
    // Here names of depedendent are stored in collection 'user' where they are filtered by their role
    return _firebaseFirestore
        .collection('users')
        .where('parent', isEqualTo: _uid)
        .where('role', isEqualTo: 'dependent')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Dependent.fromSnapshot(doc)).toList());
  }

  Stream<List<Task>> dependentHomeGetIncompleteTasks() {
    // Here the task list of depedndent on their respective home screen are fetched from collection 'tasks'
    return _dependentTasks()
        .map((tasks) => tasks.where((task) => _myStatus(task, false)).toList());
  }

  Stream<List<Task>> dependentHomeGetCompleteTasks() {
    return _dependentTasks()
        .map((tasks) => tasks.where((task) => _myStatus(task, true)).toList());
  }

  Future<void> completeTask(String taskId) async {
    // Marks the current dependent's entry as done. Runs in a transaction so two
    // children finishing the same task at once don't overwrite each other.
    final ref = _firebaseFirestore.collection('tasks').doc(taskId);
    final uid = _uid;
    await _firebaseFirestore.runTransaction((transaction) async {
      final snap = await transaction.get(ref);
      final List deps = List.from(snap.get('dependent'));
      final updated = deps
          .map((element) => element['dep'] == uid
              ? {...Map<String, dynamic>.from(element), 'status': true}
              : element)
          .toList();
      transaction.update(ref, {'dependent': updated});
    });
  }

  static List<String> dependentIdsOf(List selectedDependents) =>
      selectedDependents.map((element) => element['dep'] as String).toList();

  Future<void> createDependent(
      String fullName, String email, String password) async {
    // Creating a user with the default FirebaseAuth instance would sign the
    // parent out and sign the new child in. A throwaway secondary app keeps
    // the parent's session intact.
    final parentUid = FirebaseAuth.instance.currentUser!.uid;
    final secondary = await Firebase.initializeApp(
        name: 'dependent-signup-${DateTime.now().millisecondsSinceEpoch}',
        options: Firebase.app().options);
    try {
      final credential = await FirebaseAuth.instanceFor(app: secondary)
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseFirestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'parent': parentUid,
        'fullName': fullName,
        'email': email,
        'role': 'dependent'
      });
      await FirebaseAuth.instanceFor(app: secondary).signOut();
    } finally {
      await secondary.delete();
    }
  }
}
