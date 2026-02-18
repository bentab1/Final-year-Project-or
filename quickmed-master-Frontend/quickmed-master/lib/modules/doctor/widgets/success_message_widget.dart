import 'package:flutter/material.dart';

import '../../../utils/app_text_style.dart';

class SuccessMessageWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String iconPath;

  const SuccessMessageWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),

        /// Success Icon
        Image.asset(
          iconPath,
          height: 70,
          width: 70,
        ),

        const SizedBox(height: 30),

        /// Main Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: TAppTextStyle.inter(
            color: Colors.green,
            fontSize: 20,
            weight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 30),

        /// Subtitle
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TAppTextStyle.inter(
            color: Colors.black87,
            fontSize: 20,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
