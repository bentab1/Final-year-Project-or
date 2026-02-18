import 'package:flutter/material.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';

class PatientAccountSettingScreen extends StatelessWidget {
  const PatientAccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const CustomBackButton(),
                const SizedBox(height: 30),
                Center(child: HeadingText(text: "Account Settings")),
                const SizedBox(height: 30),

                /// ---------------- Security ---------------- ///
                QButton(
                  text: "Security",
                  buttonType: QButtonType.social,
                  onPressed: () {
                    _showDialog(context, "Security", "Security settings information.");
                  },
                ),
                const SizedBox(height: 10),

                /// ---------------- Personal Information ---------------- ///
                QButton(
                  text: "Personal Information",
                  buttonType: QButtonType.social,
                  onPressed: () {
                    _showDialog(context, "Personal Information",
                        "Your personal details can be updated here.");
                  },
                ),
                const SizedBox(height: 10),

                /// ---------------- Address ---------------- ///
                QButton(
                  text: "Address",
                  buttonType: QButtonType.social,
                  onPressed: () {
                    _showDialog(context, "Address", "Here you can update your address.");
                  },
                ),
                const SizedBox(height: 10),

                /// ---------------- Close Account ---------------- ///
                QButton(
                  text: "Close Account",
                  buttonType: QButtonType.secondary,
                  onPressed: () {
                    _showDialog(
                      context,
                      "Close Account?",
                      "Are you sure you want to close your account? This cannot be undone.",
                      isCloseAction: true,
                    );
                  },
                ),

                const SizedBox(height: 230),

                Text(
                  "QuickMed user since 6 Feb 2025",
                  style: TAppTextStyle.inter(
                    color: isDark ? QColors.lightBackground : Colors.black,
                    fontSize: 20,
                    weight: FontWeight.w400,
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

/// --------------------------------------------------------------
/// Reusable Dialog Function for All Buttons
/// --------------------------------------------------------------
void _showDialog(BuildContext context, String title, String message,
    {bool isCloseAction = false}) {
  bool isDark = TDeviceUtils.isDarkMode(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        title: Text(
          title,
          style: TAppTextStyle.inter(
            fontSize: 16,
            weight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          message,
          style: TAppTextStyle.inter(
            fontSize: 16,
            color: isDark ? Colors.white70 : Colors.black87, weight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TAppTextStyle.inter(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87, weight: FontWeight.w600,
              ),

            ),
          ),

          /// If Close Account → show an extra action button
          if (isCloseAction)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account closure request submitted."),
                  ),
                );
              },
              child: const Text(
                "Close Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      );
    },
  );
}
