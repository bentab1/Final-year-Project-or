import 'package:flutter/material.dart';
import '../colors/q_color.dart';
class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: QColors.lightGray400.withOpacity(0.4), // Disabled color for light mode
    labelStyle: const TextStyle(color: QColors.lightGray700), // Label style for light mode
    selectedColor: QColors.accent500, // Pink coral for selected chips
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12), // Padding for chips
    checkmarkColor: QColors.lightGray100, // White checkmark for light mode
    backgroundColor: QColors.lightGray100, // Background for unselected chips
    deleteIconColor: QColors.lightGray600, // Delete icon color
    brightness: Brightness.light,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: QColors.darkGray400.withOpacity(0.4), // Disabled color for dark mode
    labelStyle: const TextStyle(color: QColors.darkGray100), // Label style for dark mode
    selectedColor: QColors.accent400, // Lighter pink for dark mode selected chips
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12), // Padding for chips
    checkmarkColor: QColors.darkGray900, // Dark checkmark for better contrast
    backgroundColor: QColors.darkGray800, // Background for unselected chips
    deleteIconColor: QColors.darkGray300, // Delete icon color
    brightness: Brightness.dark,
  );
}