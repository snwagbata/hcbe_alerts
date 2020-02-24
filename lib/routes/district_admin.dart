import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/services/firebase.dart';
import 'package:hcbe_alerts/services/state_widget.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';
import 'package:location_permissions/location_permissions.dart';

class DistrictAdminPage extends StatefulWidget {
  @override
  _DistrictAdminPageState createState() => _DistrictAdminPageState();
}

class _DistrictAdminPageState extends State<DistrictAdminPage> {
  StateModel appState;
  PermissionStatus _status;
  bool _loadingVisible = false;
  

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (appState.isLoading) {
      _loadingVisible = true;
    } else {
      _loadingVisible = false;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5.0,
        // title: Text('HCBE Alerts'),
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
    );
  }

  @override
  void initState() {
    super.initState();
    LocationPermissions().checkPermissionStatus().then(_updateStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) => _askPermission());
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
}
