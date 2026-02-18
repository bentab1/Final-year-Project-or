import 'package:flutter/material.dart';
import 'package:quickmed/modules/doctor/widgets/action_buttons_row.dart';
import 'package:quickmed/modules/doctor/widgets/appointment_card.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/theme/colors/q_color.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
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
                Container(
                  width: 384,

                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionButtonsRow(
                        onAccept: () {},
                        onAddNote: () {
                          AppRouter.router.push('/acceptAppointment');
                        },
                        onReject: () {
                          AppRouter.router.push('/rejectAppointment');
                        },
                      ),
                    ],
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
                  distance: "2 miles",
                  onDirectionTap: () {
                    print("Direction clicked");
                    AppRouter.router.push('/updateAvailabilityScreen');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
