import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:location_permissions/location_permissions.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StateModel appState;
  PermissionStatus _status;
  @override
  void initState() {
    super.initState();
    LocationPermissions().checkPermissionStatus().then(_updateStatus);
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  void _askPermission() async {
    await LocationPermissions().requestPermissions().then(_onStatusRequested);
  }

  void _onStatusRequested(PermissionStatus value) {
    if (value != PermissionStatus.granted) {
      LocationPermissions().openAppSettings();
    } else {
      _updateStatus(value);
    }
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
          elevation: 5.0,
          title: Text('Settings'),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Account"),
                subtitle: Text("Privacy, security, change school code."),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Location"),
                subtitle: Text("Location access permissions"),
                onTap: () async {
                  await LocationPermissions().openAppSettings();
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Help"),
                subtitle: Text("FAQ, contact us, privacy policy"),
              ),
              Divider(),
              ListTile(
                //use aboutDialog ontap
                title: Text("Copyright ©2020 NS Tech"),
                subtitle: Text("Somtochukwu Nwagbata"),
              ),
              Divider(),
            ],
          ),
        ),
      );
    }
  }
}
