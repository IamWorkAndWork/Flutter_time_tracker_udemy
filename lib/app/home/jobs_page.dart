import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'models/job.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key key}) : super(key: key);

  Future<void> _signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure you want to logouy?",
        defaultActionText: "Logout",
        cancelActionText: "Cancel");
    if (didRequestSignOut) {
      _signout(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      var job = Job(name: "Blogging", ratePerHour: 10);
      await database.createJob(
        job,
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: "Operation failed", exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              "Log out",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    ));
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;

          if (jobs.isEmpty) {
            return Center(
              child: Text("No Data"),
            );
          }

          final childrens = jobs.map((job) {
            // print("job data = ${job.name}");
            return Text(job.name);
          }).toList();
          return ListView(
            children: childrens,
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Some error occurred"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
