import 'package:flutter/material.dart';

import '../../sizes.dart';
import '../colors/q_color.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: QColors.lightGray600,  // Icon color for light mode
    suffixIconColor: QColors.lightGray600,  // Suffix icon color for light mode
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: QSizes.fontSizeMd,
        color: QColors.lightTextSecondary
    ),  // Label text color
    hintStyle: const TextStyle().copyWith(
        fontSize: QSizes.fontSizeSm,
        color: QColors.lightTextTertiary
    ),  // Hint text color
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
        color: QColors.newPrimary500  // Teal for focused floating label
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.lightGray300),  // Default border
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.lightGray300),  // Enabled border
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: QColors.newPrimary500),  // Teal focused border
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.error500),  // Error border
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: QColors.error500),  // Focused error border
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: QColors.darkGray400,  // Icon color for dark mode
    suffixIconColor: QColors.darkGray400,  // Suffix icon color for dark mode
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
        fontSize: QSizes.fontSizeMd,
        color: QColors.darkTextSecondary
    ),  // Label text color for dark mode
    hintStyle: const TextStyle().copyWith(
        fontSize: QSizes.fontSizeSm,
        color: QColors.darkTextTertiary
    ),  // Hint text color for dark mode
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
        color: QColors.newPrimary400  // Lighter teal for dark mode floating label
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.darkGray600),  // Default border for dark mode
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.darkGray600),  // Enabled border for dark mode
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: QColors.newPrimary400),  // Lighter teal focused border for dark mode
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: QColors.error500),  // Error border
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(QSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: QColors.error500),  // Focused error border
    ),
  );
}