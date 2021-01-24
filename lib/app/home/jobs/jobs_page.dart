import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import '../models/job.dart';
import 'job_list_tile.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key key}) : super(key: key);

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: "Operation Failed", exception: e);
    }
  }

  // Future<void> _createJob(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     var job = Job(name: "Blogging", ratePerHour: 10);
  //     await database.createJob(
  //       job,
  //     );
  //   } on FirebaseException catch (e) {
  //     showExceptionAlertDialog(context,
  //         title: "Operation failed", exception: e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
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
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              EditJobPage.show(context, database: database);
            },
          ),
        ],
      ),
      body: _buildContent(context),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () => EditJobPage.show(context, database: database),
      // ),
    ));
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            key: Key('job-${job.id}'),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          ),
        );

        // if (snapshot.hasData) {
        //   final jobs = snapshot.data;

        //   if (jobs.isEmpty) {
        //     return EmptyContent();
        //   } else {
        //     final childrens = jobs.map((job) {
        //       // print("job data = ${job.name}");
        //       return JobListTile(
        //         job: job,
        //         onTap: () => EditJobPage.show(
        //           context,
        //           job: job,
        //         ),
        //       );
        //     }).toList();
        //     return ListView(
        //       children: childrens,
        //     );
        //   }
        // }
        // if (snapshot.hasError) {
        //   return Center(
        //     child: Text("Some error occurred"),
        //   );
        // }
        // return Center(
        //   child: CircularProgressIndicator(),
        // );
      },
    );
  }
}
