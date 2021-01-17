import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_bloc.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_error_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, child) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  EmailSignInFormBlocBased({@required this.bloc});

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSiginFormType _formType = EmailSiginFormType.signIn;

  _submit() async {
    try {
      await widget.bloc.submit();
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

  void _emailEditingCompleted(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFromType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return <Widget>[
      _buildEmailTextField(model),
      SizedBox(
        height: 10,
      ),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: (password) => widget.bloc.updatePassword(password),
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
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
        onEditingComplete: () => _emailEditingCompleted(model),
        onChanged: (email) => widget.bloc.updatreEmail(email));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<EmailSignInModel>(
          stream: widget.bloc.modelStream,
          initialData: EmailSignInModel(),
          builder: (context, snapshot) {
            final EmailSignInModel model = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(model),
              ),
            );
          }),
    );
  }
}
