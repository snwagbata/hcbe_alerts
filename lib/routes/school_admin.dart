import 'package:flutter/material.dart';
import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/widgets/drawer.dart';
import 'package:location_permissions/location_permissions.dart';

class SchoolAdminPage extends StatefulWidget {
  @override
  _SchoolAdminPageState createState() => _SchoolAdminPageState();
}

class _SchoolAdminPageState extends State<SchoolAdminPage> {
  StateModel appState;
  PermissionStatus _status;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("school admin"),
      ),
      drawer: NavDrawer(),
      body: Container(),
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
