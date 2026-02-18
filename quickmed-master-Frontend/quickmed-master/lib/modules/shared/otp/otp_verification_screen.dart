import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';
import '../../../utils/widgets/text_input_widget.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- BACK BUTTON ----------------
              ///
              SizedBox(height: 6),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black),
                    SizedBox(width: 6),
                    Text(
                      "Go Back",
                      style: TAppTextStyle.inter(
                        color: isDark ? Colors.white : QColors.lightGray800,
                        fontSize: 16,
                        weight: FontWeight.w500,
                        shouldUnderline: false,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              /// ---------------- TITLE ----------------
              Center(
                child: Text(
                  "OTP Verification",
                  style: TAppTextStyle.inter(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : QColors.lightGray800,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  "Verify Your Account",
                  style: TAppTextStyle.inter(
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: isDark ? Colors.white : QColors.lightGray800,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              /// ---------------- SUB TEXT ----------------
              Center(
                child: Text(
                  "Please check your email and enter the\nOTP below to verify your account",
                  textAlign: TextAlign.center,
                  style: TAppTextStyle.inter(
                    fontSize: 14,
                    height: 1.3,
                    weight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Enter Otp",
                isEmail: true,
              ),

              const SizedBox(height: 18),

              /// ---------------- RESEND OTP ----------------
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "I did not receive the OTP ? ",
                    style: TAppTextStyle.inter(
                      color: isDark ? Colors.white : QColors.lightGray800,
                      fontSize: 15,
                      weight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "Resend OTP",
                        style: TAppTextStyle.inter(
                          shouldUnderline: true,
                          color: isDark ? QColors.primary : QColors.primary,
                          fontSize: 15,
                          weight: FontWeight.w600,
                        ),

                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // TODO: Handle resend logic
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
                QButton(
                  text: 'Verify Your Account',
                  onPressed: () {
                    AppRouter.router.push('/accountCreationSuccessScreen');
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
