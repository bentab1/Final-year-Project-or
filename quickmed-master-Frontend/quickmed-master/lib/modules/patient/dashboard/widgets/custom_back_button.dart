import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Row(
          children: [
            Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
            const SizedBox(width: 6),
            Text(
              "Go Back",
              style: TAppTextStyle.inter(
                color: isDark ? Colors.white : QColors.lightGray800,
                fontSize: 16,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
