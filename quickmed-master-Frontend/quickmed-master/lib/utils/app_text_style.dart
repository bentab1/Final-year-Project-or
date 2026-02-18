import 'package:flutter/material.dart';

class TAppTextStyle {
  static TextStyle inter({
    required Color color,
    required double fontSize,
    required FontWeight weight,
    double height = 1.0,
    bool shouldUnderline = false,
    double letterSpacing = 0.0,
    Color? underlineColor, // <-- new
  }) {
    return TextStyle(
      height: height,
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
      fontFamily: AppFontFamilies.inter,
      letterSpacing: letterSpacing,
      decoration: shouldUnderline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: underlineColor ?? color, // <-- applied here
    );
  }
}

class AppFontFamilies {
  static String inter = 'Inter';
}
