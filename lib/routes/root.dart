import 'package:flutter/material.dart';

import 'package:hcbe_alerts/models/state.dart';
import 'package:hcbe_alerts/routes/default.dart';
import 'package:hcbe_alerts/routes/district_admin.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/routes/school_admin.dart';

import 'package:hcbe_alerts/services/state_widget.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  StateModel appState;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return LandingPage();
    } else if (appState?.user?.userType == 'schoolAdmin') {
      return SchoolAdminPage();
    } else if (appState?.user?.userType == 'districtAdmin') {
      return DistrictAdminPage();
    } else {
      return DefaultPage();
    }
  }
}
