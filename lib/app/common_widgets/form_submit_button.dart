import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/common_widgets/custom_rasied_button.dart';

class FormSubmitButton extends CustomRasiedButton {
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            height: 44.0,
            color: Colors.indigo,
            borderRadius: 4.0,
            onPressed: onPressed);
}
