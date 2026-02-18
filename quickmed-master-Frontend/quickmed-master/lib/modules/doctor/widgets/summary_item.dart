import 'package:flutter/material.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';

class SummaryItem extends StatelessWidget {
  final Color textColor1;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const SummaryItem({
    super.key,
     this.textColor1   = QColors.fillDark,
    this.icon,
    this.color,
    required this.title,
     this.value,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ---- LEFT SIDE (ICON + TITLE)
            if (icon != null) ...[
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
            ],

            Text(
              '$title ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),


            SizedBox(width: 8,),

            /// ---- RIGHT SIDE (VALUE)
            if (value != null)
              Text(
                value!,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TAppTextStyle.inter(
                  fontSize: 15,
                  weight: FontWeight.bold,
                  color: textColor1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
