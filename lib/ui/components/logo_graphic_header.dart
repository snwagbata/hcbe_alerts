import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hcbe_alerts/services/services.dart';

class LogoGraphicHeader extends StatelessWidget {
  LogoGraphicHeader();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String _imageLogo = 'assets/images/logo.png';
    if (themeProvider.isDarkModeOn == true) {
      _imageLogo = 'assets/images/logo.png';
    }
    return Hero(
      tag: 'App logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 36.0,
          child: Image.asset(_imageLogo),
        ),
      ),
    );
  }
}
