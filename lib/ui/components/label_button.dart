import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  LabelButton({this.labelText, this.onPressed});
  final String labelText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        labelText,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      onPressed: onPressed,
    );
  }
}
