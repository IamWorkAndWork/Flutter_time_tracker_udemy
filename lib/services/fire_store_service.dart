import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  //make singleton object
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    // print("_setData = : $path : $data");
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required
        T Function(@required Map<String, dynamic> data,
                @required String documentId)
            builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => builder(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteJob({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }
}
