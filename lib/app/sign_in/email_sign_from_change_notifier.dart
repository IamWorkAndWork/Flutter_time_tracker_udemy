import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_change_model.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, child) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  EmailSignInFormChangeNotifier({@required this.model});

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSiginFormType _formType = EmailSiginFormType.signIn;

  EmailSignInChangeModel get model => widget.model;

  _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign In Failed",
        exception: e,
      );
    }
  }

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
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.model.toggleFromType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
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
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 10.0,
      ),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => widget.model.updatePassword(password),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Test@test.com",
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingCompleted(),
        onChanged: (email) => widget.model.updateEmail(email));
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
}
