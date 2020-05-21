import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}

class DistressAlertDialog extends PlatformWidget {
  DistressAlertDialog({
    @required this.title,
    @required this.alert,
    @required this.schoolId,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(schoolId != null),
        assert(defaultActionText != null);

  final String title;
  final String alert;
  final String schoolId;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (BuildContext context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Initiate ' + title + '?'),
      content: Text(
        "Are you sure you want to initiate the " + title + " alert?",
      ),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text('Initiate ' + title + '?'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: Text(
        "Are you sure you want to initiate the " + title + " alert?",
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        DistressAlertDialogAction(
          child: Text(
            cancelActionText,
            key: Key('alertCancel'),
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      DistressAlertDialogAction(
        child: Text(
          defaultActionText,
          key: Key('alertDefault'),
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () async {
          Navigator.of(context).pop(true);
        },
      ),
    );
    return actions;
  }
}

class DistressAlertDialogAction extends PlatformWidget {
  DistressAlertDialogAction({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
