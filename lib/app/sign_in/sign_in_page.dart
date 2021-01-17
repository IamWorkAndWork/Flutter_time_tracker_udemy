import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: "Sign In Falied",
      exception: exception,
    );
  }

  Future<void> _signInWithAnonymous(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
      // print("userCredential = ${userCredential.user.uid}");

    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } catch (e) {
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } catch (e) {
      // print(e.toString());
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => EmailSignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return Center(
              child: SingleChildScrollView(
                child: _buildContainer(
                  context,
                  snapshot.data,
                ),
              ),
            );
          }),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: _buildHeader(isLoading),
            ),
            SizedBox(
              height: 48.0,
            ),
            SocialSignInButton(
              assetName: 'assets/images/facebook-logo.png',
              text: "Sign In With Facebook",
              textColor: Colors.white,
              color: Color(0xff334d92),
              onPressed: isLoading ? null : () => _signInWithFacebook(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            SocialSignInButton(
              assetName: 'assets/images/google-logo.png',
              text: "Sign In With Google",
              textColor: Colors.black,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            SignInButton(
              text: "Sign In With Email",
              textColor: Colors.white,
              color: Colors.green,
              onPressed: isLoading ? null : () => _signInWithEmail(context),
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
              onPressed: isLoading ? null : () => _signInWithAnonymous(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
