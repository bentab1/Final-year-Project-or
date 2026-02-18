import 'package:flutter/material.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

class QuickMedLogo extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final bool isDark;

  /// NEW: customizable sizes
  final double logoSize;       // Default: 120
  final double barThickness;   // Default: 30
  final double dotSize;        // Default: 20
  final double textSize;       // Default: 56

  const QuickMedLogo({
    super.key,
    required this.fadeAnimation,
    required this.isDark,
    this.logoSize = 120,
    this.barThickness = 30,
    this.dotSize = 20,
    this.textSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          _buildCrossLogo(),
          const SizedBox(height: 12),
          Text(
            'QuickMed',
            style: TextStyle(
              color: isDark ? Colors.white : QColors.primary,
              fontSize: textSize,
              letterSpacing: 1.9,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossLogo() {
    final double verticalBarHeight = logoSize - 20;
    final double horizontalBarWidth = logoSize - 20;

    return SizedBox(
      width: logoSize,
      height: logoSize,
      child: Stack(
        children: [
          // Vertical bar
          Positioned(
            left: (logoSize - barThickness) / 2,
            top: 10,
            child: Container(
              width: barThickness,
              height: verticalBarHeight,
              decoration: BoxDecoration(
                color: QColors.primary,
                borderRadius: BorderRadius.circular(barThickness / 2),
              ),
            ),
          ),

          // Horizontal bar
          Positioned(
            left: 10,
            top: (logoSize - barThickness) / 2,
            child: Container(
              width: horizontalBarWidth,
              height: barThickness,
              decoration: BoxDecoration(
                color: QColors.primary,
                borderRadius: BorderRadius.circular(barThickness / 2),
              ),
            ),
          ),

          // Dot
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: QColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
