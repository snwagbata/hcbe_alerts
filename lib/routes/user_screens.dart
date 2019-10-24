import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';
import 'package:hcbe_alerts/widgets/loading.dart';

class UserHomePages {
  StateModel appState;

  /// teacher's home screen for HCBE Alerts. also the default home screen
  Widget teacher(BuildContext context, bool loadingVisible) {
    appState = StateWidget.of(context).state;
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );

    final signOutButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          StateWidget.of(context).logOutUser();
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/forgot-password');
      },
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
    );

    final signInLabel = FlatButton(
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signin');
      },
    );
//check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final name = appState?.user?.name ?? '';
    final settingsId = appState?.settings?.settingsId ?? '';
    final userIdLabel = Text('App Id: ');
    final emailLabel = Text('Email: ');
    final nameLabel = Text('Name: ');
    final settingsIdLabel = Text('SetttingsId: ');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        title: Text('HCBE Alerts'),
        actions: <Widget>[
          IconButton(
            icon: Platform.isIOS
                ? Icon(
                    CupertinoIcons.settings,
                  )
                : Icon(
                    Icons.settings,
                  ), // icon is 48px widget.
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    logo,
                    SizedBox(height: 48.0),
                    userIdLabel,
                    Text(userId, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.0),
                    emailLabel,
                    Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.0),
                    nameLabel,
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.0),
                    settingsIdLabel,
                    Text(settingsId,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.0),
                    signOutButton,
                    signInLabel,
                    signUpLabel,
                    forgotLabel
                  ],
                ),
              ),
            ),
          ),
          inAsyncCall: loadingVisible),
    );
  }

  Widget schoolAdmin(BuildContext context, bool loadingVisible, String school) {
    return null;
  }
}
