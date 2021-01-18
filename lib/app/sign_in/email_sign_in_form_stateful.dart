import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validator.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormStateFul extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStateFulState createState() =>
      _EmailSignInFormStateFulState();
}

class _EmailSignInFormStateFulState extends State<EmailSignInFormStateFul> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _isLoading = false;

  EmailSiginFormType _formType = EmailSiginFormType.signIn;

  @override
  void dispose() {
    print("dispose call");
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingCompleted() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSiginFormType.signIn
          ? EmailSiginFormType.register
          : EmailSiginFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      // await Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSiginFormType.signIn) {
        await auth.signWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // print("error _submit : ${e.toString()}");
      showExceptionAlertDialog(context,
          title: "Sign In Failed", content: e.message, exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSiginFormType.signIn
        ? 'Sign In'
        : 'Create An Account';

    final secondaryText = _formType == EmailSiginFormType.signIn
        ? "Need An Account? Register"
        : "Have An Account? Sign in";

    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return <Widget>[
      _buildEmailTextField(),
      SizedBox(
        height: 10,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 16,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(
        height: 10.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Test@test.com",
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingCompleted,
      onChanged: (email) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
