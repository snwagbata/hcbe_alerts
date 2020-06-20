import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/models.dart';
import 'package:hcbe_alerts/services/services.dart';
import 'package:hcbe_alerts/ui/components/components.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsUI extends StatefulWidget {
  @override
  _SettingsUIState createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  bool textAlerts;
  String uid;
  String school;
  var version;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);

    setState(() {
      textAlerts = user?.textAlerts;
      uid = user?.uid;
      school = user?.school;
    });

    Future<void> _signOut(BuildContext context) async {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Signed out")));
      AuthService().signOut();
    }

    Future<void> _confirmSignOut(BuildContext context) async {
      final bool didRequestSignOut = await PAlertDialog(
        title: 'Sign Out',
        content: 'Are you sure you want to sign out?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Sign Out',
      ).show(context);
      if (didRequestSignOut == true) {
        Navigator.pop(context);
        PushNotificationService().unsubscribeToNotification(school);
        _signOut(context);
      }
    }

    Future<void> _changeTheme() async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose theme'),
            children: <Widget>[
              RadioListTile(
                title: Text("Light"),
                value: 'light',
                groupValue: Provider.of<ThemeProvider>(context).getTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .updateTheme(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text("Dark"),
                value: 'dark',
                groupValue: Provider.of<ThemeProvider>(context).getTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .updateTheme(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text('System'),
                value: 'system',
                groupValue: Provider.of<ThemeProvider>(context).getTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .updateTheme(value);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 5.0,
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            /*
              SettingsSection(
                title: 'Common',
                tiles: [
                  SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),  will implement spanish later
                onTap: () {
                  Navigator.of(context);
                },
              ),
                ],
              ),*/
            SettingsSection(
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: 'Email',
                  leading: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color),
                ),
                //Remember to unsuscribe from school fcm notifcation if user changes school
                SettingsTile(
                  title: 'Update school',
                  leading: Icon(Icons.school,
                      color: Theme.of(context).iconTheme.color),
                ),
                SettingsTile.switchTile(
                  title: 'TextAlerts',
                  leading: Icon(Icons.textsms,
                      color: Theme.of(context).iconTheme.color),
                  switchValue: textAlerts,
                  onToggle: (bool enabled) {
                    AuthService().updateTextAlerts(uid, enabled);
                  },
                ),
                SettingsTile(
                  title: 'Sign out',
                  leading: Icon(Icons.exit_to_app,
                      color: Theme.of(context).iconTheme.color),
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
                  leading: Icon(Icons.location_on,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    AppSettings.openAppSettings();
                  },
                ),
                SettingsTile(
                  title: 'Change password',
                  leading: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color),
                ),
              ],
            ),
            Platform.isAndroid
                ? SettingsSection(
                    title: 'Theme',
                    tiles: [
                      SettingsTile(
                        title: 'Choose Theme',
                        leading: Icon(Icons.brightness_medium,
                            color: Theme.of(context).iconTheme.color),
                        subtitle: Provider.of<ThemeProvider>(context)
                                .getTheme
                                .substring(0, 1)
                                .toUpperCase() +
                            Provider.of<ThemeProvider>(context)
                                .getTheme
                                .substring(1),
                        onTap: () {
                          _changeTheme();
                        },
                      ),
                    ],
                  )
                : null,
            SettingsSection(
              title: 'Misc',
              tiles: [
                SettingsTile(
                    title: 'Terms of Service',
                    leading: Icon(Icons.description,
                        color: Theme.of(context).iconTheme.color)),
                SettingsTile(
                  title: 'About HCBE Alerts',
                  leading: Icon(Icons.info_outline,
                      color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AppAboutDialog();
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
