import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

import '../../../routes/app_routes.dart';

class AccountCreationSuccessScreen extends StatelessWidget {
  const AccountCreationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// ---------------- SUCCESS ICON ----------------
                Icon(
                  Icons.check_circle_outline,
                  size: 120,
                  color: Colors.green,
                ),

                const SizedBox(height: 26),

                /// ---------------- TITLE ----------------
                Text(
                  "Account Creation Successful",
                  style: TAppTextStyle.inter(
                    fontSize: 20,
                    weight: FontWeight.w700,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                /// ---------------- DESCRIPTION ----------------
                Text(
                  "Your patient account has been\nverified and created",
                  style: TAppTextStyle.inter(
                    fontSize: 16,
                    weight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                /// ---------------- GO TO LOGIN ----------------
                RichText(
                  text: TextSpan(
                    text: "Go to Login",
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to login screen
                        AppRouter.router.go('/loginScreen');

                      },
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
