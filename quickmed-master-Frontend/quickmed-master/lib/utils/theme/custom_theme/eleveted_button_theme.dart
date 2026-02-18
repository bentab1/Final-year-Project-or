import 'package:flutter/material.dart';
import '../../sizes.dart';
import '../colors/q_color.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: QColors.buttonText,  // White text on buttons
      backgroundColor: QColors.buttonPrimary,  // Teal primary button color
      disabledForegroundColor: QColors.lightGray500,  // Disabled foreground color
      disabledBackgroundColor: QColors.lightGray300,  // Disabled background color
      side: const BorderSide(color: QColors.buttonPrimary),  // Teal border color
      padding: const EdgeInsets.symmetric(vertical: QSizes.buttonHeight),  // Vertical padding
      textStyle: const TextStyle(
          fontSize: 16,  // Font size set to 16
          color: QColors.buttonText, // White text color
          fontWeight: FontWeight.w600
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QSizes.buttonRadius)
      ),  // Button radius
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: QColors.buttonText,  // White text on buttons
      backgroundColor: QColors.buttonPrimary,  // Teal primary button color (same as light)
      disabledForegroundColor: QColors.darkGray500,  // Disabled foreground for dark mode
      disabledBackgroundColor: QColors.darkGray300,  // Disabled background for dark mode
      side: const BorderSide(color: QColors.buttonPrimary),  // Teal border color
      padding: const EdgeInsets.symmetric(vertical: QSizes.buttonHeight),  // Vertical padding
      textStyle: const TextStyle(
          fontSize: 16,  // Font size set to 16
          color: QColors.buttonText, // White text color
          fontWeight: FontWeight.w600
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QSizes.buttonRadius)
      ),  // Button radius
    ),
  );
}