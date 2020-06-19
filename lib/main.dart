import 'package:flutter/material.dart';
import 'package:hcbe_alerts/router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcbe_alerts/services/services.dart';
import 'package:hcbe_alerts/constants/constants.dart';
import 'package:hcbe_alerts/ui/auth/auth.dart';
//import 'dart:js' as js;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotificationService().initialise();
  }

  @override
  Widget build(BuildContext context) {
    // js.context.callMethod("alert", <String>["Your debug message"]);
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        //{context, data, child}
        return AuthWidgetBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> userSnapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "HCBE Alerts",
              routes: Routes.routes,
              theme: buildTheme(),
              darkTheme: buildDarkTheme(),
              themeMode: themeProviderRef.isDarkModeOn
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: (userSnapshot?.data?.uid != null)
                  ? UserRouter()
                  : LandingUI(),
            );
          },
        );
      },
    );
  }
}
