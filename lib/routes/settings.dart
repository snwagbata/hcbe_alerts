import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/services/state_widget.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StateModel appState;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return LandingPage();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 5.0,
          title: Text('Settings'),
        ),
        backgroundColor: Colors.white,
        body: CircularProgressIndicator(),
      );
    }
  }
}
