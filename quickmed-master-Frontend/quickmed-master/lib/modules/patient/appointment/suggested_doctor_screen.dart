import 'package:flutter/material.dart';
import 'package:quickmed/modules/patient/appointment/widgets/doctor_card.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';

class SuggestedDoctorScreen extends StatefulWidget {
  const SuggestedDoctorScreen({super.key});

  @override
  State<SuggestedDoctorScreen> createState() => _SuggestedDoctorScreenState();
}

class _SuggestedDoctorScreenState extends State<SuggestedDoctorScreen> {
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

              /// Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      "Go Back",
                      style: TAppTextStyle.inter(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Title
              Center(
                child: Text(
                  "Book Appointment",
                  style: TAppTextStyle.inter(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Center(
                child: Text(
                  "Suggested Doctor",
                  style: TAppTextStyle.inter(
                    fontSize: 15,
                    weight: FontWeight.w400,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              /// Doctor Card 1
              Center(
                child: DoctorCard(
                  name: "Dr Sara John",
                  speciality: "Cardiology",
                  miles: "1.8 miles",
                  onDirectionTap: () {  },
                ),
              ),

              const SizedBox(height: 40),

              /// Doctor Card 2
              Center(
                child: DoctorCard(
                  name: "Dr Benjamin Ogbonna",
                  speciality: "Cardiology",
                  miles: "2 miles",
                  onDirectionTap: () {  },
                ),
              ),

              const Spacer(),

              /// Continue button
              QButton(
                text: "Continue",
                onPressed: () {},
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


}
