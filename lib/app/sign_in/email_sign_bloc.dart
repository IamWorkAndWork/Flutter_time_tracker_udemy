import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelController =
      StreamController();
  final AuthBase auth;

  EmailSignInBloc({@required this.auth});

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void updateWith(
      {String email,
      String password,
      EmailSiginFormType formType,
      bool isLoading,
      bool submitted}) {
    //update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    //add updated model to _modelController
    _modelController.add(_model);
  }

  void toggleFromType() {
    final formType = _model.formType == EmailSiginFormType.signIn
        ? EmailSiginFormType.register
        : EmailSiginFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false);
  }

  void updatreEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (_model.formType == EmailSiginFormType.signIn) {
        await auth.signWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      // print("error _submit : ${e.toString()}");
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
