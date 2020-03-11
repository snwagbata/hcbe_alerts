import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/flushbar.dart';
import 'package:hcbe_alerts/widgets/platform_alert_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StateModel appState;
  bool textAlertsEnabled = false;
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
      Future<void> _signOut(BuildContext context) async {
        try {
          bar("Signed out", 2, context);
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

      return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          title: Text('Settings'),
        ),
        body: SafeArea(
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'Common',
                tiles: [
                  /*SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),  will implement spanish later
                onTap: () {
                  Navigator.of(context);
                },
              ),*/
                ],
              ),
              SettingsSection(
                title: 'Account',
                tiles: [
                  SettingsTile(title: 'Email', leading: Icon(Icons.email)),
                  SettingsTile.switchTile(
                    title: 'TextAlerts',
                    leading: Icon(Icons.textsms),
                    switchValue: textAlertsEnabled,
                    onToggle: (bool enabled) {
                      setState(() {
                        //TODO update db value before flipping switch
                        textAlertsEnabled = enabled;
                      });
                    },
                  ),
                  SettingsTile(
                    title: 'Sign out',
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      _confirmSignOut(context);
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Security',
                tiles: [
                  SettingsTile(
                    title: 'Location permission',
                    leading: Icon(Icons.lock),
                    onTap: () {
                      AppSettings.openLocationSettings();
                    },
                  ),
                  SettingsTile(
                    title: 'Change password',
                    leading: Icon(Icons.lock),
                  ),
                ],
              ),
              SettingsSection(
                title: 'Misc',
                tiles: [
                  SettingsTile(
                      title: 'Terms of Service',
                      leading: Icon(Icons.description)),
                  SettingsTile(
                      title: 'Open source licenses',
                      leading: Icon(Icons.collections_bookmark)),
                ],
              )
            ],
          ),
          /*child: ListView(
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
          ),*/
        ),
      );
    }
  }
}
