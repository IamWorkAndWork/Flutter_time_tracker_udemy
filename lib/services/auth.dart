import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;
  Stream<User> authStateChanges();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    final googleSignIn = GoogleSignIn();
    googleSignIn.signOut();

    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));

        print("sign in with google success : " + userCredential.user.uid);
        return userCredential.user;
      }
    } else {
      throw FirebaseAuthException(
          message: "sign in aborted by user", code: 'ERROR_ABORTED_BY_USER');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            message: "Sign In aborted by user", code: "ERROR_ABORTED_BY_USER");
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            message: response.error.developerMessage,
            code: 'ERROR_FACEBOOK_LOGIN_FAILED');
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }
}
