import 'package:flutter/material.dart';

class CustomRasiedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  const CustomRasiedButton({
    this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50,
    this.onPressed,
  }) : assert(borderRadius != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          borderRadius,
        )),
        onPressed: onPressed,
      ),
    );
  }
}
