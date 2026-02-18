import 'package:flutter/material.dart';
import 'package:quickmed/modules/doctor/widgets/appointment_card.dart';
import 'package:quickmed/utils/sizes.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';

class RejectAppointmentScreen extends StatefulWidget {
  const RejectAppointmentScreen({super.key});

  @override
  State<RejectAppointmentScreen> createState() => _RejectAppointmentScreenState();
}

class _RejectAppointmentScreenState extends State<RejectAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: QSizes.md,
              vertical: QSizes.md,
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
                        const SizedBox(width: QSizes.cardRadiusXs),
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
                SizedBox(height: QSizes.loadingIndicatorSize),
                Text(
                  'Are you Sure You want to Accept this Appointment ?',
                  textAlign: TextAlign.center,
                  style: TAppTextStyle.inter(
                    color: QColors.lightTextColor,
                    fontSize: 20,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: QSizes.fontSizeLgx),
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
                    AppRouter.router.push('/getDirectionScreen');

                  },
                ),
                SizedBox(
                  height: QSizes.imageCarouselHeight,
                ),

                QButton(
                  text: 'Confirm',
                  onPressed: () {
                    AppRouter.router.push('/appointmentRejectedScreen');

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
