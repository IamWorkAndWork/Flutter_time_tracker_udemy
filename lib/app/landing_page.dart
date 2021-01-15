import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        print("snapshot.connectionState = ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return HomePage();
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
