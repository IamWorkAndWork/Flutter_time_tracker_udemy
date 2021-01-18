import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validator.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  EmailSiginFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSiginFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  String get primaryButtonText {
    return formType == EmailSiginFormType.signIn
        ? 'Sign In'
        : 'Create An Account';
  }

  String get secondaryButtonText {
    return formType == EmailSiginFormType.signIn
        ? "Need An Account? Register"
        : "Have An Account? Sign in";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    var text = showErrorText ? invalidPasswordErrorText : null;
    return text;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    var text = showErrorText ? invalidEmailErrorText : null;
    return text;
  }

  void updateWith({
    String email,
    String password,
    EmailSiginFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void toggleFromType() {
    final formType = this.formType == EmailSiginFormType.signIn
        ? EmailSiginFormType.register
        : EmailSiginFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (this.formType == EmailSiginFormType.signIn) {
        await this.auth.signWithEmailAndPassword(this.email, this.password);
      } else {
        await this
            .auth
            .createUserWithEmailAndPassword(this.email, this.password);
      }
    } catch (e) {
      // print("error _submit : ${e.toString()}");
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) => updateWith(password: password);
}
