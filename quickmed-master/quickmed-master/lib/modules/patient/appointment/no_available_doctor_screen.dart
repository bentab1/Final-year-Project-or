import 'package:flutter/material.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/widgets/TButton.dart';

class NoAvailableDoctorScreen extends StatefulWidget {
  const NoAvailableDoctorScreen({super.key});

  @override
  State<NoAvailableDoctorScreen> createState() =>
      _NoAvailableDoctorScreenState();
}

class _NoAvailableDoctorScreenState extends State<NoAvailableDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// Close button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.close, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      "Close",
                      style: TAppTextStyle.inter(
                        fontSize: 16,
                        weight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// Center Warning Icon + Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Opps no Doctor available at this time",
                      textAlign: TextAlign.center,
                      style: TAppTextStyle.inter(
                        fontSize: 15,
                        weight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Try again in few minutes",
                      textAlign: TextAlign.center,
                      style: TAppTextStyle.inter(
                        fontSize: 14,
                        weight: FontWeight.w400,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              /// Bottom Button
              QButton(
                text: "Try Again",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
