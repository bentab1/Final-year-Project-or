import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';

class GeneralErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String buttonText;
  final VoidCallback onRetry;

  const GeneralErrorScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.buttonText,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ---------- ICON ----------
                Icon(
                  icon,
                  size: 120,
                  color: Colors.grey.shade500,
                ),

                const SizedBox(height: 20),

                /// ---------- TITLE ----------
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TAppTextStyle.inter(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------- MESSAGE ----------
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TAppTextStyle.inter(
                    fontSize: 16,
                    weight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 180),

                /// ---------- RETRY BUTTON ----------
                SizedBox(
                  width: double.infinity,
                  child: QButton(
                    text: buttonText,
                    onPressed: onRetry,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
