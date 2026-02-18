import 'package:flutter/material.dart';
import '../../sizes.dart';
import '../colors/q_color.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: QColors.buttonSecondary, // Pink coral for outlined button text
      backgroundColor: Colors.transparent, // Transparent background
      disabledForegroundColor: QColors.lightGray500, // Disabled text color
      side: const BorderSide(color: QColors.buttonSecondary, width: 1.5), // Pink coral border
      textStyle: const TextStyle(
          fontSize: 16,
          color: QColors.buttonSecondary, // Pink coral text
          fontWeight: FontWeight.w600
      ),
      padding: const EdgeInsets.symmetric(
          vertical: QSizes.buttonHeight,
          horizontal: 20
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QSizes.buttonRadius)
      ),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: QColors.accent400, // Lighter pink for dark mode
      backgroundColor: Colors.transparent, // Transparent background
      disabledForegroundColor: QColors.darkGray500, // Disabled text color
      side: const BorderSide(color: QColors.accent400, width: 1.5), // Lighter pink border
      textStyle: const TextStyle(
          fontSize: 16,
          color: QColors.accent400, // Lighter pink text for dark mode
          fontWeight: FontWeight.w600
      ),
      padding: const EdgeInsets.symmetric(
          vertical: QSizes.buttonHeight,
          horizontal: 20
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QSizes.buttonRadius)
      ),
    ),
  );
}