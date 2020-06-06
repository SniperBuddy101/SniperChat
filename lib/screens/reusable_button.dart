import 'package:flutter/material.dart';
import 'package:sniper_chat/constants.dart';

class ReusableButton extends StatelessWidget {
  final Function onPressProperty;
  final String labelText;
  final Color colorProperty;
  ReusableButton({this.labelText, this.onPressProperty, this.colorProperty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorProperty,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressProperty,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            labelText,
            style: TextStyle(color: kSecondaryColor),
          ),
        ),
      ),
    );
  }
}