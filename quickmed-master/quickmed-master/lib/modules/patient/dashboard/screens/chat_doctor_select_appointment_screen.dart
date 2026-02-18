// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
// import 'package:quickmed/utils/app_text_style.dart';
// import 'package:quickmed/utils/device_utility.dart';
// import 'package:quickmed/utils/image_path.dart';
// import 'package:quickmed/utils/theme/colors/q_color.dart';
// import 'package:quickmed/utils/widgets/TButton.dart';
// import 'package:quickmed/utils/widgets/text_input_widget.dart';
//
// class ChatDoctorSelectAppointmentScreen extends StatelessWidget {
//   const ChatDoctorSelectAppointmentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = TDeviceUtils.isDarkMode(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 10),
//                 CustomBackButton(),
//                 SizedBox(height: 20),
//                 TextInputWidget(
//                   dark: isDark,
//                   hintText: "Search Appointments",
//                   fillColor: Colors.transparent,
//                   radius: BorderRadius.circular(24),
//                   suffixSvgPath: QImagesPath.search,
//                   controller: TextEditingController(),
//                 ),
//                 SizedBox(height: 20),
//                 Center(child: HeadingText(text: "Chat Doctor")),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     "Select Appointment",
//                     style: TAppTextStyle.inter(
//                       color: isDark ? QColors.lightBackground : Colors.black,
//                       fontSize: 20,
//                       weight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 AppointmentWidget(
//                   date: "10 October 2025",
//                   time: "10:30 AM",
//                   status: Status.accepted,
//                   onTap: () => context.push('/chatDoctorScreen'),
//                 ),
//                 AppointmentWidget(
//                   date: "9 October 2025",
//                   time: "9:30 AM",
//                   status: Status.rejected,
//                 ),
//                 AppointmentWidget(
//                   date: "1 October 2025",
//                   time: "10:30 AM",
//                   status: Status.complete,
//                 ),
//                 AppointmentWidget(
//                   date: "2 October 2025",
//                   time: "10:30 AM",
//                   status: Status.noShow,
//                 ),
//                 QButton(
//                   text: "View All",
//                   buttonType: QButtonType.text,
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//     ;
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';

class ChatDoctorSelectAppointmentScreen extends StatefulWidget {
  const ChatDoctorSelectAppointmentScreen({super.key});

  @override
  State<ChatDoctorSelectAppointmentScreen> createState() => _ChatDoctorSelectAppointmentScreenState();
}

class _ChatDoctorSelectAppointmentScreenState extends State<ChatDoctorSelectAppointmentScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                SizedBox(height: 10),
                CustomBackButton(),
                SizedBox(height: 20),
                TextInputWidget(
                  dark: isDark,
                  hintText: "Search Appointments",
                  fillColor: Colors.transparent,
                  radius: BorderRadius.circular(24),
                  suffixSvgPath: QImagesPath.search,
                  controller: _searchController,
                ),
                SizedBox(height: 20),
                Center(child: HeadingText(text: "Chat Doctor")),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Select Appointment",
                    style: TAppTextStyle.inter(
                      color: isDark ? QColors.lightBackground : Colors.black,
                      fontSize: 20,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Accepted appointment - can chat
                AppointmentWidget(
                  date: "10 October 2025",
                  time: "10:30 AM",
                  status: Status.accepted,
                  doctorName: "Dr. John Smith",
                  specialization: "Cardiologist",
                  location: "City Hospital",
                  latitude: 35.9208,
                  longitude: 74.3089,
                  onAppointmentTap: () => context.push('/chatDoctorScreen'),
                  onDirectionsTap: () {
                    // Handle directions if needed
                    _navigateToDirections(
                      context,
                      35.9208,
                      74.3089,
                      "City Hospital",
                      "Dr. John Smith",
                      "Cardiologist",
                    );
                  },
                ),

                // Rejected appointment
                AppointmentWidget(
                  date: "9 October 2025",
                  time: "9:30 AM",
                  status: Status.rejected,
                  doctorName: "Dr. Sarah Lee",
                  specialization: "Dermatologist",
                  location: "Medical Center",
                  latitude: 35.9208,
                  longitude: 74.3089,
                  onAppointmentTap: () {
                    // Show message that rejected appointments can't be accessed
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This appointment was rejected'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  onDirectionsTap: () {
                    _navigateToDirections(
                      context,
                      35.9208,
                      74.3089,
                      "Medical Center",
                      "Dr. Sarah Lee",
                      "Dermatologist",
                    );
                  },
                ),

                // Completed appointment
                AppointmentWidget(
                  date: "1 October 2025",
                  time: "10:30 AM",
                  status: Status.complete,
                  doctorName: "Dr. Mike Johnson",
                  specialization: "General Physician",
                  location: "Health Clinic",
                  latitude: 35.9208,
                  longitude: 74.3089,
                  onAppointmentTap: () => context.push('/chatDoctorScreen'),
                  onDirectionsTap: () {
                    _navigateToDirections(
                      context,
                      35.9208,
                      74.3089,
                      "Health Clinic",
                      "Dr. Mike Johnson",
                      "General Physician",
                    );
                  },
                ),

                // No-show appointment
                AppointmentWidget(
                  date: "2 October 2025",
                  time: "10:30 AM",
                  status: Status.noShow,
                  doctorName: "Dr. Emily Brown",
                  specialization: "Neurologist",
                  location: "Specialty Hospital",
                  latitude: 35.9208,
                  longitude: 74.3089,
                  onAppointmentTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You missed this appointment'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  onDirectionsTap: () {
                    _navigateToDirections(
                      context,
                      35.9208,
                      74.3089,
                      "Specialty Hospital",
                      "Dr. Emily Brown",
                      "Neurologist",
                    );
                  },
                ),

                QButton(
                  text: "View All",
                  buttonType: QButtonType.text,
                  onPressed: () {
                    // Navigate to view all appointments
                    context.push('/viewAllAppointments');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigate to DirectionOptionsScreen with location data
  void _navigateToDirections(
      BuildContext context,
      double? latitude,
      double? longitude,
      String location,
      String? doctorName,
      String? specialization,
      ) {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location coordinates not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (latitude <= 0 || longitude <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid location coordinates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'doctorName': doctorName,
      'specialization': specialization,
    };

    print('📍 Navigating to directions with data: $locationData');
    context.push('/directionOptions', extra: locationData);
  }
}