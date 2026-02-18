// updated_appbar_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    // Use pure white for app bar instead of lightGray100
    backgroundColor: Colors.white,
    foregroundColor: QColors.lightTextPrimary,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(
      color: QColors.lightGray800,
      size: 24.0,
    ),
    actionsIconTheme: const IconThemeData(
      color: QColors.lightGray800,
      size: 24.0,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: QColors.lightTextPrimary,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    // Use darkCard instead of darkGray900 for better contrast
    backgroundColor: QColors.darkCard,
    foregroundColor: QColors.darkTextPrimary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: QColors.darkGray100,
      size: 24.0,
    ),
    actionsIconTheme: IconThemeData(
      color: QColors.darkGray100,
      size: 24.0,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: QColors.darkTextPrimary,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: QColors.darkCard,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}