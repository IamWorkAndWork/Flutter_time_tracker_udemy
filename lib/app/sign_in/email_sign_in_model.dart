import 'package:time_tracker_flutter_course/app/sign_in/validator.dart';

enum EmailSiginFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSiginFormType formType;
  bool isLoading;
  bool submitted;

  EmailSignInModel({
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

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSiginFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
