import 'package:flutter/material.dart';
import '../colors/q_color.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: QColors.lightTextPrimary
    ),
    headlineMedium: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: QColors.lightTextPrimary
    ),
    headlineSmall: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: QColors.lightTextPrimary
    ),

    titleLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: QColors.lightTextPrimary
    ),
    titleMedium: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: QColors.lightTextSecondary
    ),
    titleSmall: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: QColors.lightTextSecondary
    ),

    bodyLarge: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: QColors.lightTextPrimary
    ),
    bodyMedium: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: QColors.lightTextSecondary
    ),
    bodySmall: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: QColors.lightTextTertiary
    ),

    labelLarge: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: QColors.lightTextSecondary
    ),
    labelMedium: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: QColors.lightTextTertiary
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: QColors.darkTextPrimary
    ),
    headlineMedium: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: QColors.darkTextPrimary
    ),
    headlineSmall: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: QColors.darkTextPrimary
    ),

    titleLarge: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: QColors.darkTextPrimary
    ),
    titleMedium: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: QColors.darkTextSecondary
    ),
    titleSmall: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: QColors.darkTextSecondary
    ),

    bodyLarge: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: QColors.darkTextPrimary
    ),
    bodyMedium: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: QColors.darkTextSecondary
    ),
    bodySmall: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: QColors.darkTextTertiary
    ),

    labelLarge: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: QColors.darkTextSecondary
    ),
    labelMedium: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: QColors.darkTextTertiary
    ),
  );
}