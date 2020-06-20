import 'package:flutter/material.dart';

class CodeButton extends StatelessWidget {
  CodeButton({this.labelText, this.color, this.onPressed});
  
  final String labelText;
  final Color color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      elevation: 5,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(vertical: 6),
      color: color,
      child: Text(labelText),
    );
  }
}