import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const HeadingText({required this.text, super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        text,
        style: TAppTextStyle.inter(
          color: textColor != null
              ? textColor!
              : (isDark ? QColors.lightBackground : Colors.black),
          fontSize: 20,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
