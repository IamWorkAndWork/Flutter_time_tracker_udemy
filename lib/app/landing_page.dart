import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        print("snapshot.connectionState = ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: JobsPage());
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Home Page"),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
