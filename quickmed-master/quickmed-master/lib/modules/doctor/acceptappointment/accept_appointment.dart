import 'package:flutter/material.dart';
import 'package:quickmed/modules/doctor/widgets/appointment_card.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';

class AcceptAppointment extends StatefulWidget {
  const AcceptAppointment({super.key});

  @override
  State<AcceptAppointment> createState() => _AcceptAppointmentState();
}

class _AcceptAppointmentState extends State<AcceptAppointment> {
  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Go Back",
                          style: TAppTextStyle.inter(
                            color: isDark ? Colors.white : QColors.lightGray800,
                            fontSize: 16,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Are you Sure You want to Accept this Appointment ?',
                  textAlign: TextAlign.center,
                  style: TAppTextStyle.inter(
                    color: QColors.lightTextColor,
                    fontSize: 20,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
                AppointmentCard1(
                  name: "Mary Okpe",
                  status: "Pending",
                  date: "08 Oct 2025",
                  time: "09:30 AM",
                  medicalHistory: "Hypertension",
                  symptoms: "Chest Pain, Shortness of Breath",
                  imagePath: QImagesPath.profile,
                  // your image
                  distance: "2 miles",
                  onDirectionTap: () {
                    print("Direction clicked");
                  },
                ),
                SizedBox(
                  height: 200,
                ),

                QButton(
                  text: 'Confirm',
                  onPressed: () {
                    AppRouter.router.push('/appointmentAcceptedScreen');

                    print("Confirm");
                  },
                ),

                /// ---------------- VERIFY BUTTON ----------------
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
