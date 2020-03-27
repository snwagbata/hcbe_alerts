import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/constants/theme.dart';
import 'package:hcbe_alerts/routes/forgot_password.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/routes/login.dart';
import 'package:hcbe_alerts/routes/register.dart';
import 'package:hcbe_alerts/routes/root.dart';
import 'package:hcbe_alerts/routes/settings.dart';
import 'package:hcbe_alerts/services/state_widget.dart';

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'HCBE Alerts',
      theme: buildTheme(),
      darkTheme: buildDarkTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => Root(),
        '/settings': (context) => SettingsPage(),
        '/landing': (context) => LandingPage(),
        '/signin': (context) => LoginPage(),
        '/signup': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
      },
    );
  }
}

void main() {
  StateWidget stateWidget = StateWidget(
    child: MyApp(),
  );
  runApp(stateWidget);
}
