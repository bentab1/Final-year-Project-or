import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class CurrentDateTimeWidget extends StatelessWidget {
  final String date;
  final String time;

  const CurrentDateTimeWidget({
    super.key,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Today: $date | $time",
        style: TAppTextStyle.inter(
          color: isDark ? QColors.lightBackground : Colors.black,
          fontSize: 20,
          weight: FontWeight.w400,
        ),
      ),
    );
  }
}
