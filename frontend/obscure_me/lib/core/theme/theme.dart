import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static _border([Color color = Colors.black12]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  static final lightThemeMode = ThemeData.dark().copyWith(
    textTheme: Typography().black.apply(
      fontFamily: 'Outfit',
      bodyColor: AppPalette.whiteColor,
    ),
    scaffoldBackgroundColor: AppPalette.darkBackgroundColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppPalette.darkBackgroundColor,
      color: AppPalette.darkBackgroundColor,
    ),
    buttonTheme: ButtonThemeData(splashColor: Colors.grey.withAlpha(50)),
    // dialogTheme: DialogTheme(
    //   surfaceTintColor: AppPalette.darkBackgroundColor,
    //   backgroundColor: AppPalette.darkBackgroundColor,
    // ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppPalette.primaryColor,
      selectionColor: AppPalette.greyOpacityColor,
      selectionHandleColor: AppPalette.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      focusedBorder: _border(AppPalette.primaryColor),
      errorBorder: _border(AppPalette.redColor),
      enabledBorder: _border(),
    ),
  );
}
