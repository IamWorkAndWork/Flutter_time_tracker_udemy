import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  final AuthBase auth;
  const SignInPage({
    Key key,
    @required this.auth,
  }) : super(key: key);

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInAnonymously();
      // print("userCredential = ${userCredential.user.uid}");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContainer(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            SocialSignInButton(
              assetName: 'assets/images/facebook-logo.png',
              text: "Sign In With Facebook",
              textColor: Colors.white,
              color: Color(0xff334d92),
              onPressed: () {},
            ),
            SizedBox(
              height: 8.0,
            ),
            SocialSignInButton(
              assetName: 'assets/images/google-logo.png',
              text: "Sign In With Google",
              textColor: Colors.black,
              color: Colors.white,
              onPressed: () {},
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
              text: "Sign In With Email",
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () {},
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "or",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
              text: "Go Annonymous",
              textColor: Colors.black,
              color: Colors.lime[300],
              onPressed: _signInWithGoogle,
            )
          ],
        ),
      ),
    );
  }
}
