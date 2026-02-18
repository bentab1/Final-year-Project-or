import 'package:flutter/material.dart';

import '../../../utils/app_text_style.dart';
import '../../../utils/theme/colors/q_color.dart';

class StatusActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool showArrow;

  const StatusActionTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.showArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: borderRadius,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TAppTextStyle.inter(
                  fontSize: 14,
                  weight: FontWeight.w500,
                  color: QColors.iconColorDark,
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
