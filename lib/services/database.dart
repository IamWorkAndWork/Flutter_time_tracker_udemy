import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/fire_store_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPath.job(uid, "job_cba"),
        data: job.toMap(),
      );

  // Future<void> _setData({String path, Map<String, dynamic> data}) async {
  //   final reference = FirebaseFirestore.instance.doc(path);
  //   print("_setData = : $path : $data");
  //   await reference.set(data);
  // }

  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));
  // {
  //   final path = APIPath.jobs(uid);
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   // snapshots.listen((snapshot) {
  //   //   snapshot.docs.forEach((item) {
  //   //     print("readJobs : ${item.id} | ${item.data()}");
  //   //   });
  //   // });
  //   return snapshots.map(
  //     (snapshot) => snapshot.docs
  //         .map(
  //           (snapshot) => Job.fromMap(snapshot.data()),
  //         )
  //         .toList(),
  //   );
  // }

  // Stream<List<T>> _collectionStream<T>({
  //   @required String path,
  //   @required T Function(Map<String, dynamic> data) builder,
  // }) {
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map(
  //     (snapshot) => snapshot.docs
  //         .map(
  //           (snapshot) => builder(
  //             snapshot.data(),
  //           ),
  //         )
  //         .toList(),
  //   );
  // }
}
