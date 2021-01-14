import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_rasied_button.dart';

class SocialSignInButton extends CustomRasiedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(
                    image: AssetImage(assetName),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.0,
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Image(
                      image: AssetImage(assetName),
                    ),
                  )
                ]),
            borderRadius: 8.0,
            color: color,
            height: 42.0,
            onPressed: onPressed);
}
