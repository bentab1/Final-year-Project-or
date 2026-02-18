// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
// // import 'package:quickmed/modules/patient/dashboard/widgets/current_date_time_widget.dart';
// // import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
// // import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
// // import 'package:quickmed/utils/device_utility.dart';
// // import 'package:quickmed/utils/image_path.dart';
// // import 'package:quickmed/utils/theme/colors/q_color.dart';
// // import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
// // import 'package:quickmed/utils/widgets/TButton.dart';
// // import 'package:quickmed/utils/widgets/text_input_widget.dart';
// //
// // import '../../../../routes/app_routes.dart';
// // import '../../../provider/BookingProvider.dart';
// //
// // class PatientDashboardScreen extends StatefulWidget {
// //   const PatientDashboardScreen({super.key});
// //
// //   @override
// //   State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
// // }
// //
// // class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch patient bookings when screen loads
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<BookingProvider>().fetchPatientBookings();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     bool isDark = TDeviceUtils.isDarkMode(context);
// //
// //     final now = DateTime.now();
// //     final formattedDate = DateFormat('EEE d MMM yyyy').format(now);
// //     final formattedTime = DateFormat('HH:mm').format(now);
// //
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
// //           child: Consumer<BookingProvider>(
// //             builder: (context, bookingProvider, child) {
// //               // Show loading indicator
// //               if (bookingProvider.isLoading) {
// //                 return Center(
// //                   child: CircularProgressIndicator(
// //                     color: QColors.newPrimary500,
// //                   ),
// //                 );
// //               }
// //
// //               // Show error message
// //               if (bookingProvider.hasError) {
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.error_outline, size: 60, color: Colors.red),
// //                       SizedBox(height: 16),
// //                       Text(
// //                         'Error loading appointments',
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Text(
// //                         bookingProvider.errorMessage ?? 'Unknown error',
// //                         textAlign: TextAlign.center,
// //                       ),
// //                       SizedBox(height: 16),
// //                       QButton(
// //                         text: "Retry",
// //                         onPressed: () {
// //                           bookingProvider.fetchPatientBookings();
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }
// //
// //               // Get bookings
// //               final allBookings = bookingProvider.patientBookings;
// //
// //               // Separate upcoming and recent appointments
// //               final upcomingBookings = allBookings.where((booking) {
// //                 // Filter logic: bookings in the future or today with pending/accepted status
// //                 return booking.status == 'pending' || booking.status == 'accepted';
// //               }).toList();
// //
// //               final recentBookings = allBookings.where((booking) {
// //                 // Filter logic: completed, rejected, or no-show bookings
// //                 return booking.status == 'completed' ||
// //                     booking.status == 'rejected' ||
// //                     booking.status == 'no-show';
// //               }).toList();
// //
// //               return SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: 12),
// //                     Row(
// //                       children: [
// //                         ProfilePic(
// //                           imagePath: QImagesPath.profileImg,
// //                           onTap: () => context.push('/patientProfileScreen'),
// //                         ),
// //                         SizedBox(width: 5),
// //
// //                         /// ---------------- SEARCH BAR WIDGET ---------------- ///
// //                         Expanded(
// //                           child: TextInputWidget(
// //                             dark: isDark,
// //                             height: 42,
// //                             hintText: "Search Appointments",
// //                             fillColor: Colors.transparent,
// //                             radius: BorderRadius.circular(24),
// //                             suffixSvgPath: QImagesPath.search,
// //                             controller: TextEditingController(),
// //                           ),
// //                         ),
// //
// //                         /// ---------------- NOTIFICATION BUTTON ---------------- ///
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 5),
// //                           child: Center(
// //                             child: IconButton(
// //                               onPressed: () {
// //                                 AppRouter.router.push('/notificationScreen');
// //                               },
// //                               icon: Icon(
// //                                 Icons.notifications_outlined,
// //                                 color: QColors.newPrimary500,
// //                                 size: 35,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     SizedBox(height: 20),
// //
// //                     CurrentDateTimeWidget(
// //                       date: formattedDate,
// //                       time: formattedTime,
// //                     ),
// //
// //                     SizedBox(height: 10),
// //
// //                     /// ---------------- UPCOMING APPOINTMENT ---------------- ///
// //                     HeadingText(text: "Upcoming Appointments"),
// //
// //                     if (upcomingBookings.isEmpty)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 20),
// //                         child: Text(
// //                           'No upcoming appointments',
// //                           style: TextStyle(
// //                             color: Colors.grey,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       )
// //                     else
// //                       ...upcomingBookings.take(2).map((booking) {
// //                         return GestureDetector(
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => PatientAppointmentDetailScreen(booking: booking),
// //                               ),
// //                             );
// //                           },
// //                           child: AppointmentWidget(
// //                             date: _formatDate(booking.date),
// //                             time: booking.time,
// //                             status: _mapStatus(booking.status),
// //
// //                           ),
// //                         );
// //                       }),
// //
// //                     Align(
// //                       alignment: Alignment.topRight,
// //                       child: QButton(
// //                         width: 100,
// //                         text: 'View All',
// //                         onPressed: () {
// //                           context.push('/viewAllAppointments', extra: {'filterType': 'upcoming'});
// //                         },
// //                         buttonType: QButtonType.text,
// //                       ),
// //                     ),
// //
// //                     /// ---------------- RECENT APPOINTMENT ---------------- ///
// //                     HeadingText(text: "Recent Appointments"),
// //
// //                     if (recentBookings.isEmpty)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 20),
// //                         child: Text(
// //                           'No recent appointments',
// //                           style: TextStyle(
// //                             color: Colors.grey,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       )
// //                     else
// //                       ...recentBookings.take(2).map((booking) {
// //                         return AppointmentWidget(
// //                           date: _formatDate(booking.date),
// //                           time: booking.time,
// //                           status: _mapStatus(booking.status),
// //                           doctorName: booking.doctorName,
// //                           specialization: null, // Not available in BookingResponse
// //                           location: booking.doctorName, // Using doctor name as location label
// //                           latitude: booking.doctorLatitude,
// //                           longitude: booking.doctorLongitude,
// //                           onTap: () {
// //
// //
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => PatientAppointmentDetailScreen(booking: booking),
// //                               ),
// //                             );
// //                             print('Appointment tapped: ${booking.id}');
// //                           },
// //                         );
// //                       }),
// //
// //                     Align(
// //                       alignment: Alignment.topRight,
// //                       child: QButton(
// //                         width: 100,
// //                         text: 'View All',
// //                         onPressed: () {
// //                           context.push('/viewAllAppointments', extra: {'filterType': 'recent'});
// //                         },
// //                         buttonType: QButtonType.text,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Format date from BookingResponse
// //   String _formatDate(dynamic date) {
// //     if (date == null) return 'Date not set';
// //
// //     try {
// //       DateTime dateTime;
// //       if (date is String) {
// //         dateTime = DateTime.parse(date);
// //       } else if (date is DateTime) {
// //         dateTime = date;
// //       } else {
// //         return 'Invalid date';
// //       }
// //
// //       return DateFormat('d MMMM yyyy').format(dateTime);
// //     } catch (e) {
// //       return 'Invalid date';
// //     }
// //   }
// //
// //   /// Map API status to Status enum
// //   Status _mapStatus(String? status) {
// //     if (status == null) return Status.pending;
// //
// //     switch (status.toLowerCase()) {
// //       case 'accepted':
// //       case 'confirmed':
// //         return Status.accepted;
// //       case 'rejected':
// //       case 'cancelled':
// //         return Status.rejected;
// //       case 'completed':
// //       case 'complete':
// //         return Status.complete;
// //       case 'no-show':
// //       case 'noshow':
// //         return Status.noShow;
// //       case 'pending':
// //       default:
// //         return Status.pending;
// //     }
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/current_date_time_widget.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
// import 'package:quickmed/utils/device_utility.dart';
// import 'package:quickmed/utils/image_path.dart';
// import 'package:quickmed/utils/theme/colors/q_color.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
// import 'package:quickmed/utils/widgets/TButton.dart';
// import 'package:quickmed/utils/widgets/text_input_widget.dart';
//
// import '../../../../routes/app_routes.dart';
// import '../../../provider/BookingProvider.dart';
//
// class PatientDashboardScreen extends StatefulWidget {
//   const PatientDashboardScreen({super.key});
//
//   @override
//   State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
// }
//
// class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
//   final _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch patient bookings when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BookingProvider>().fetchPatientBookings();
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = TDeviceUtils.isDarkMode(context);
//
//     final now = DateTime.now();
//     final formattedDate = DateFormat('EEE d MMM yyyy').format(now);
//     final formattedTime = DateFormat('HH:mm').format(now);
//
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Consumer<BookingProvider>(
//             builder: (context, bookingProvider, child) {
//               // Show loading indicator
//               if (bookingProvider.isLoading) {
//                 return Center(
//                   child: CircularProgressIndicator(
//                     color: QColors.newPrimary500,
//                   ),
//                 );
//               }
//
//               // Show error message
//               if (bookingProvider.hasError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 60, color: Colors.red),
//                       SizedBox(height: 16),
//                       Text(
//                         'Error loading appointments',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         bookingProvider.errorMessage ?? 'Unknown error',
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 16),
//                       QButton(
//                         text: "Retry",
//                         onPressed: () {
//                           bookingProvider.fetchPatientBookings();
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               // Get bookings
//               final allBookings = bookingProvider.patientBookings;
//
//               // Separate upcoming and recent appointments
//               final upcomingBookings = allBookings.where((booking) {
//                 // Filter logic: bookings in the future or today with pending/accepted status
//                 return booking.status == 'pending' || booking.status == 'accepted';
//               }).toList();
//
//               final recentBookings = allBookings.where((booking) {
//                 // Filter logic: completed, rejected, or no-show bookings
//                 return booking.status == 'completed' ||
//                     booking.status == 'rejected' ||
//                     booking.status == 'no-show';
//               }).toList();
//
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 12),
//                     Row(
//                       children: [
//                         ProfilePic(
//                           imagePath: QImagesPath.profileImg,
//                           onTap: () => context.push('/patientProfileScreen'),
//                         ),
//                         SizedBox(width: 5),
//
//                         /// ---------------- SEARCH BAR WIDGET ---------------- ///
//                         Expanded(
//                           child: TextInputWidget(
//                             dark: isDark,
//                             height: 42,
//                             hintText: "Search Appointments",
//                             fillColor: Colors.transparent,
//                             radius: BorderRadius.circular(24),
//                             suffixSvgPath: QImagesPath.search,
//                             controller: _searchController,
//                           ),
//                         ),
//
//                         /// ---------------- NOTIFICATION BUTTON ---------------- ///
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: Center(
//                             child: IconButton(
//                               onPressed: () {
//                                 AppRouter.router.push('/notificationScreen');
//                               },
//                               icon: Icon(
//                                 Icons.notifications_outlined,
//                                 color: QColors.newPrimary500,
//                                 size: 35,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//
//                     CurrentDateTimeWidget(
//                       date: formattedDate,
//                       time: formattedTime,
//                     ),
//
//                     SizedBox(height: 10),
//
//                     /// ---------------- UPCOMING APPOINTMENT ---------------- ///
//                     HeadingText(text: "Upcoming Appointments"),
//
//                     if (upcomingBookings.isEmpty)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         child: Text(
//                           'No upcoming appointments',
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       )
//                     else
//                       ...upcomingBookings.take(2).map((booking) {
//                         return AppointmentWidget(
//                           date: _formatDate(booking.date),
//                           time: booking.time,
//                           status: _mapStatus(booking.status),
//                           doctorName: booking.doctorName,
//                           specialization: null, // Not available in BookingResponse
//                           location: booking.doctorName, // Using doctor name as location label
//                           latitude: booking.doctorLatitude,
//                           longitude: booking.doctorLongitude,
//
//                           // Handle appointment card tap - navigate to details
//                           onAppointmentTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PatientAppointmentDetailScreen(booking: booking),
//                               ),
//                             );
//                           },
//
//                           // Handle directions button tap - navigate to directions
//                           onDirectionsTap: () {
//                             _navigateToDirections(
//                               context,
//                               booking.doctorLatitude,
//                               booking.doctorLongitude,
//                               booking.doctorName ?? 'Doctor Location',
//                               booking.doctorName,
//                               null, // specialization not available
//                             );
//                           },
//                         );
//                       }),
//
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: QButton(
//                         width: 100,
//                         text: 'View All',
//                         onPressed: () {
//                           context.push('/viewAllAppointments', extra: {'filterType': 'upcoming'});
//                         },
//                         buttonType: QButtonType.text,
//                       ),
//                     ),
//
//                     /// ---------------- RECENT APPOINTMENT ---------------- ///
//                     HeadingText(text: "Recent Appointments"),
//
//                     if (recentBookings.isEmpty)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         child: Text(
//                           'No recent appointments',
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       )
//                     else
//                       ...recentBookings.take(2).map((booking) {
//                         return AppointmentWidget(
//                           date: _formatDate(booking.date),
//                           time: booking.time,
//                           status: _mapStatus(booking.status),
//                           doctorName: booking.doctorName,
//                           specialization: null, // Not available in BookingResponse
//                           location: booking.doctorName, // Using doctor name as location label
//                           latitude: booking.doctorLatitude,
//                           longitude: booking.doctorLongitude,
//
//                           // Handle appointment card tap - navigate to details
//                           onAppointmentTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PatientAppointmentDetailScreen(booking: booking),
//                               ),
//                             );
//                           },
//                           //
//                           // // Handle directions button tap - navigate to directions
//                           // onDirectionsTap: () {
//                           //   _navigateToDirections(
//                           //     context,
//                           //     booking.doctorLatitude,
//                           //     booking.doctorLongitude,
//                           //     booking.doctorName ?? 'Doctor Location',
//                           //     booking.doctorName,
//                           //     null, // specialization not available
//                           //   );
//                           // },
//                         );
//                       }),
//
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: QButton(
//                         width: 100,
//                         text: 'View All',
//                         onPressed: () {
//                           context.push('/viewAllAppointments', extra: {'filterType': 'recent'});
//                         },
//                         buttonType: QButtonType.text,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Navigate to DirectionOptionsScreen with location data
//   void _navigateToDirections(
//       BuildContext context,
//       double? latitude,
//       double? longitude,
//       String location,
//       String? doctorName,
//       String? specialization,
//       ) {
//     // Validate coordinates
//     if (latitude == null || longitude == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location coordinates not available'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     if (latitude <= 0 || longitude <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid location coordinates'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Prepare location data
//     final Map<String, dynamic> locationData = {
//       'latitude': latitude,
//       'longitude': longitude,
//       'location': location,
//       'doctorName': doctorName,
//       'specialization': specialization,
//     };
//
//     print('📍 Navigating to directions with data: $locationData');
//
//     // Navigate using GoRouter
//     context.push('/directionOptions', extra: locationData);
//   }
//
//   /// Format date from BookingResponse
//   String _formatDate(dynamic date) {
//     if (date == null) return 'Date not set';
//
//     try {
//       DateTime dateTime;
//       if (date is String) {
//         dateTime = DateTime.parse(date);
//       } else if (date is DateTime) {
//         dateTime = date;
//       } else {
//         return 'Invalid date';
//       }
//
//       return DateFormat('d MMMM yyyy').format(dateTime);
//     } catch (e) {
//       return 'Invalid date';
//     }
//   }
//
//   /// Map API status to Status enum
//   Status _mapStatus(String? status) {
//     if (status == null) return Status.pending;
//
//     switch (status.toLowerCase()) {
//       case 'accepted':
//       case 'confirmed':
//         return Status.accepted;
//       case 'rejected':
//       case 'cancelled':
//         return Status.rejected;
//       case 'completed':
//       case 'complete':
//         return Status.complete;
//       case 'no-show':
//       case 'noshow':
//         return Status.noShow;
//       case 'pending':
//       default:
//         return Status.pending;
//     }
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/current_date_time_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';

import '../../../../routes/app_routes.dart';
import '../../../provider/BookingProvider.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  final _searchController = TextEditingController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Fetch patient bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchPatientBookings();
    });

    // Set up auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        context.read<BookingProvider>().fetchPatientBookings();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// Handle pull-to-refresh
  Future<void> _handleRefresh() async {
    await context.read<BookingProvider>().fetchPatientBookings();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    final now = DateTime.now();
    final formattedDate = DateFormat('EEE d MMM yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Consumer<BookingProvider>(
            builder: (context, bookingProvider, child) {
              // Show loading indicator
              if (bookingProvider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: QColors.newPrimary500,
                  ),
                );
              }

              // Show error message
              if (bookingProvider.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error loading appointments',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        bookingProvider.errorMessage ?? 'Unknown error',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      QButton(
                        text: "Retry",
                        onPressed: () {
                          bookingProvider.fetchPatientBookings();
                        },
                      ),
                    ],
                  ),
                );
              }

              // Get bookings
              final allBookings = bookingProvider.patientBookings;

              // Separate upcoming and recent appointments
              final upcomingBookings = allBookings.where((booking) {
                // Filter logic: bookings in the future or today with pending/accepted status
                return booking.status == 'pending' || booking.status == 'accepted';
              }).toList();

              final recentBookings = allBookings.where((booking) {
                // Filter logic: completed, rejected, or no-show bookings
                return booking.status == 'completed' ||
                    booking.status == 'rejected' ||
                    booking.status == 'no-show';
              }).toList();

              return RefreshIndicator(
                onRefresh: _handleRefresh,
                color: QColors.newPrimary500,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ProfilePic(
                            imagePath: QImagesPath.profileImg,
                            onTap: () => context.push('/patientProfileScreen'),
                          ),
                          SizedBox(width: 5),

                          /// ---------------- SEARCH BAR WIDGET ---------------- ///
                          Expanded(
                            child: TextInputWidget(
                              dark: isDark,
                              height: 42,
                              hintText: "Search Appointments",
                              fillColor: Colors.transparent,
                              radius: BorderRadius.circular(24),
                              suffixSvgPath: QImagesPath.search,
                              controller: _searchController,
                            ),
                          ),

                          /// ---------------- NOTIFICATION BUTTON ---------------- ///
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  AppRouter.router.push('/notificationScreen');
                                },
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: QColors.newPrimary500,
                                  size: 35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      CurrentDateTimeWidget(
                        date: formattedDate,
                        time: formattedTime,
                      ),

                      SizedBox(height: 10),

                      /// ---------------- UPCOMING APPOINTMENT ---------------- ///
                      HeadingText(text: "Upcoming Appointments"),

                      if (upcomingBookings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No upcoming appointments',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        ...upcomingBookings.take(2).map((booking) {
                          return AppointmentWidget(
                            date: _formatDate(booking.date),
                            time: booking.time,
                            status: _mapStatus(booking.status),
                            doctorName: booking.doctorName,
                            specialization: null, // Not available in BookingResponse
                            location: booking.doctorName, // Using doctor name as location label
                            latitude: booking.doctorLatitude,
                            longitude: booking.doctorLongitude,

                            // Handle appointment card tap - navigate to details
                            onAppointmentTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientAppointmentDetailScreen(booking: booking),
                                ),
                              );
                            },

                            // Handle directions button tap - navigate to directions
                            // onDirectionsTap: () {
                            //   _navigateToDirections(
                            //     context,
                            //     booking.doctorLatitude,
                            //     booking.doctorLongitude,
                            //     booking.doctorName ?? 'Doctor Location',
                            //     booking.doctorName,
                            //     null, // specialization not available
                            //   );
                        //    },
                          );
                        }),

                      Align(
                        alignment: Alignment.topRight,
                        child: QButton(
                          width: 100,
                          text: 'View All',
                          onPressed: () {
                            context.push('/viewAllAppointments', extra: {'filterType': 'upcoming'});
                          },
                          buttonType: QButtonType.text,
                        ),
                      ),

                      /// ---------------- RECENT APPOINTMENT ---------------- ///
                      HeadingText(text: "Recent Appointments"),

                      if (recentBookings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No recent appointments',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        ...recentBookings.take(2).map((booking) {
                          return AppointmentWidget(
                            date: _formatDate(booking.date),
                            time: booking.time,
                            status: _mapStatus(booking.status),
                            doctorName: booking.doctorName,
                            specialization: null, // Not available in BookingResponse
                            location: booking.doctorName, // Using doctor name as location label
                            latitude: booking.doctorLatitude,
                            longitude: booking.doctorLongitude,

                            // Handle appointment card tap - navigate to details
                            onAppointmentTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientAppointmentDetailScreen(booking: booking),
                                ),
                              );
                            },
                            //
                            // // Handle directions button tap - navigate to directions
                            // onDirectionsTap: () {
                            //   _navigateToDirections(
                            //     context,
                            //     booking.doctorLatitude,
                            //     booking.doctorLongitude,
                            //     booking.doctorName ?? 'Doctor Location',
                            //     booking.doctorName,
                            //     null, // specialization not available
                            //   );
                            // },
                          );
                        }),

                      Align(
                        alignment: Alignment.topRight,
                        child: QButton(
                          width: 100,
                          text: 'View All',
                          onPressed: () {
                            context.push('/viewAllAppointments', extra: {'filterType': 'recent'});
                          },
                          buttonType: QButtonType.text,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
    // Validate coordinates
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

    // Prepare location data
    final Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'doctorName': doctorName,
      'specialization': specialization,
    };

    print('📍 Navigating to directions with data: $locationData');

    // Navigate using GoRouter
    context.push('/directionOptions', extra: locationData);
  }

  /// Format date from BookingResponse
  String _formatDate(dynamic date) {
    if (date == null) return 'Date not set';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Invalid date';
      }

      return DateFormat('d MMMM yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  /// Map API status to Status enum
  Status _mapStatus(String? status) {
    if (status == null) return Status.pending;

    switch (status.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
        return Status.accepted;
      case 'rejected':
      case 'cancelled':
        return Status.rejected;
      case 'completed':
      case 'complete':
        return Status.complete;
      case 'no-show':
      case 'noshow':
        return Status.noShow;
      case 'pending':
      default:
        return Status.pending;
    }
  }
}