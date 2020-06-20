import 'package:flutter/material.dart';

class AlertDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  AlertDetailChip(this.iconData, this.label);

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.bodyText2,
      avatar: Icon(
        iconData,
        size: 14.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }
}
