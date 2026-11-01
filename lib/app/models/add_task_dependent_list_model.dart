import 'package:cloud_firestore/cloud_firestore.dart';

class Dependent {
  final String name;
  final String id;

  const Dependent({required this.name, required this.id});

  static Dependent fromSnapshot(DocumentSnapshot snap) {
    Dependent dependent = Dependent(
      // model of id and name of depedent is created here
      id: snap.reference.id,
      name: snap['fullName'],
    );
    return dependent;
  }
}
