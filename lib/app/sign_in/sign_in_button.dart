import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/common_widgets/custom_rasied_button.dart';

class SignInButton extends CustomRasiedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
              ),
            ),
            borderRadius: 8.0,
            color: color,
            height: 42.0,
            onPressed: onPressed);
}
