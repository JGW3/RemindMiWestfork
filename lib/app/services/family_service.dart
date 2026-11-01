import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// Live copy of every profile in the signed-in user's family (the parent and
// all their children), keyed by uid. Used for avatars so they update everywhere
// the moment anyone changes one.
class FamilyService extends GetxController {
  static FamilyService get to => Get.isRegistered<FamilyService>()
      ? Get.find<FamilyService>()
      : Get.put(FamilyService());

  final users = <String, Map<String, dynamic>>{}.obs;
  StreamSubscription? _self;
  final _family = <StreamSubscription>[];
  String? _root;

  @override
  void onInit() {
    super.onInit();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final db = FirebaseFirestore.instance.collection('users');

    _self = db.doc(uid).snapshots().listen((doc) {
      final data = doc.data();
      if (data == null) return;
      users[uid] = data;
      // The family is everyone whose parent is the root (the parent account)
      final root = data['role'] == 'parent' ? uid : data['parent'] as String?;
      if (root == null || root.isEmpty || root == _root) return;
      _root = root;
      _cancelFamily();
      if (root != uid) {
        _family.add(
          db.doc(root).snapshots().listen((parent) {
            if (parent.data() != null) users[root] = parent.data()!;
          }, onError: _logError),
        );
      }
      _family.add(
        db.where('parent', isEqualTo: root).snapshots().listen((snapshot) {
          for (final member in snapshot.docs) {
            users[member.id] = member.data();
          }
        }, onError: _logError),
      );
    }, onError: _logError);
  }

  void _logError(Object e) => debugPrint('Family profiles: $e');

  void _cancelFamily() {
    for (final sub in _family) {
      sub.cancel();
    }
    _family.clear();
  }

  @override
  void onClose() {
    _self?.cancel();
    _cancelFamily();
    super.onClose();
  }
}
