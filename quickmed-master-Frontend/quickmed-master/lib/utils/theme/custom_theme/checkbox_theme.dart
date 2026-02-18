import 'package:flutter/material.dart';
import '../../sizes.dart';
import '../colors/q_color.dart';


class TCheckBoxTheme {
  TCheckBoxTheme._();

  /// Customizable Light Checkbox Theme
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QSizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return QColors.lightGray100; // White check mark for selected state
      } else {
        return QColors.lightGray700; // Check color for unselected state
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return QColors.checkboxSelected; // Pink coral for selected state
      } else {
        return Colors.transparent; // Transparent for unselected state
      }
    }),
    // side: WidgetStateProperty!.resolveWith((states) {
    //   if (states.contains(WidgetState.selected)) {
    //     return null; // No border when selected
    //   } else {
    //     return BorderSide(
    //       color: TColors.checkboxUnselected, // Gray border for unselected
    //       width: 2,
    //     );
    //   }
    // }),
  );

  /// Customizable Dark Checkbox Theme
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(QSizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return QColors.darkGray900; // Dark check mark for better contrast
      } else {
        return QColors.darkGray300; // Check color for unselected state
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return QColors.checkboxSelectedDark; // Lighter pink for dark mode
      } else {
        return Colors.transparent; // Transparent for unselected state
      }
    }),
    // side: WidgetStateProperty!.resolveWith((states) {
    //   if (states.contains(WidgetState.selected)) {
    //     return null; // No border when selected
    //   } else {
    //     return BorderSide(
    //       color: TColors.checkboxUnselectedDark, // Gray border for unselected
    //       width: 2,
    //     );
    //   }
    // }),
  );
}