import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcbe_alerts/constants/theme.dart';
import 'package:hcbe_alerts/routes/forgot_password.dart';
import 'package:hcbe_alerts/routes/home.dart';
import 'package:hcbe_alerts/routes/landing.dart';
import 'package:hcbe_alerts/routes/login.dart';
import 'package:hcbe_alerts/routes/register.dart';
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
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
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
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}

/**
 * void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HCBE Alerts',
      theme: buildTheme(),
      home: RootPage(),
      routes: {
        '/': (context) => HomePage(),
        '/signin': (context) => LoginPage(),
        '/signup': (context) => RegisterPage(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
 */
