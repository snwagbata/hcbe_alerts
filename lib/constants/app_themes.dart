import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Merriweather',
        color: const Color(0xFF101010),
      ),
      headline5: base.headline5.copyWith(
        fontFamily: 'Merriweather',
        color: const Color(0xFF101010),
      ),
      caption: base.caption.copyWith(
        color: const Color(0xFF101010),
      ),
      bodyText1: base.bodyText1.copyWith(
        color: const Color(0x8A000000),
      ),
      bodyText2: base.bodyText2.copyWith(
        color: const Color(0xFF101010),
      ),
      subtitle2: base.subtitle2.copyWith(
        color: const Color(0xFF101010),
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      primaryColor: const Color(0xff00457c),
      accentColor: const Color(0xff006fc7),
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: const Color(0xFF000000),
      ),
      buttonColor: Colors.white,
      toggleableActiveColor: const Color(0xff006fc7),
      indicatorColor: const Color(0xff006fc7),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ));
}

ThemeData buildDarkTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Merriweather',
        color: const Color(0xFFFFFFFF),
      ),
      headline5: base.headline5.copyWith(
        fontFamily: 'Merriweather',
        color: const Color(0xFFFFFFFF),
      ),
      caption: base.caption.copyWith(
        color: const Color(0xFFFFFFFF),
      ),
      bodyText1: base.bodyText1.copyWith(
        color: const Color(0xFFFFFFFF),
      ),
      bodyText2: base.bodyText2.copyWith(
        color: const Color(0xFFFFFFFF),
      ),
      subtitle2: base.subtitle2.copyWith(
        color: const Color(0x8AFFFFFF),
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.dark();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xff00457c),
    accentColor: const Color(0xff006fc7),
    brightness: Brightness.dark,
    buttonColor: Colors.white,
    toggleableActiveColor: const Color(0xff006fc7),
    indicatorColor: const Color(0xff006fc7),
    iconTheme: IconThemeData(
      color: const Color(0xffffffff),
    ),
    dividerColor: const Color(0xffaaaaaa),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );
}
