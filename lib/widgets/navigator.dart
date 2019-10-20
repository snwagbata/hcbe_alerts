import 'package:flutter/material.dart';

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void popPushPage(BuildContext context, Widget page) {
  Navigator.of(context).pop();
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

void pushReplacement(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute<void>(builder: (_) => page),
  );
}
