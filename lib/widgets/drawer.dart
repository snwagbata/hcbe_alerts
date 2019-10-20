import 'package:flutter/material.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/flushbar.dart';
import 'package:hcbe_alerts/widgets/platform_alert_dialog.dart';
import 'package:flutter/services.dart';

class NavDrawer extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      StateWidget.of(context).logOutUser();
    } on PlatformException {
      bar('Sign Out failed', 5, context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'Sign Out',
      content: 'Are you sure you want to sign out?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Sign Out',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  ///Drawer Header with HCBE logo
  final header = DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/bg.jpg"),
        fit: BoxFit.contain,
        repeat: ImageRepeat.repeatX,
      ),
    ),
    child: Center(
      child: Hero(
        tag: 'logo',
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: CircleAvatar(
            radius: 300,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          header,
          Divider(),
          ListTile(
            // leading: Icon(LineIcons.user_times),
            title: Text('Sign Out'),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
