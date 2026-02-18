// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
// import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
// import 'package:quickmed/utils/theme/colors/q_color.dart';
// import 'package:quickmed/utils/widgets/TButton.dart';
//
// import '../../../provider/BookingProvider.dart';
//
// class ViewAllAppointmentsScreen extends StatefulWidget {
//   final String? filterType; // 'upcoming' or 'recent'
//
//   const ViewAllAppointmentsScreen({
//     super.key,
//     this.filterType,
//   });
//
//   @override
//   State<ViewAllAppointmentsScreen> createState() => _ViewAllAppointmentsScreenState();
// }
//
// class _ViewAllAppointmentsScreenState extends State<ViewAllAppointmentsScreen> {
//   String _selectedFilter = 'all'; // all, upcoming, recent
//
//   @override
//   void initState() {
//     super.initState();
//     // Set initial filter if provided
//     if (widget.filterType != null) {
//       _selectedFilter = widget.filterType!;
//     }
//
//     // Fetch patient bookings when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BookingProvider>().fetchPatientBookings();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               CustomBackButton(),
//               SizedBox(height: 20),
//
//               HeadingText(text: "All Appointments"),
//               SizedBox(height: 20),
//
//               /// ---------------- FILTER TABS ---------------- ///
//               _buildFilterTabs(),
//               SizedBox(height: 20),
//
//               /// ---------------- APPOINTMENTS LIST ---------------- ///
//               Expanded(
//                 child: Consumer<BookingProvider>(
//                   builder: (context, bookingProvider, child) {
//                     // Show loading indicator
//                     if (bookingProvider.isLoading) {
//                       return Center(
//                         child: CircularProgressIndicator(
//                           color: QColors.newPrimary500,
//                         ),
//                       );
//                     }
//
//                     // Show error message
//                     if (bookingProvider.hasError) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.error_outline,
//                               size: 60,
//                               color: Colors.red,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'Error loading appointments',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               bookingProvider.errorMessage ?? 'Unknown error',
//                               style: TextStyle(fontSize: 12, color: Colors.grey),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 16),
//                             QButton(
//                               text: "Retry",
//                               onPressed: () {
//                                 bookingProvider.fetchPatientBookings();
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     // Get filtered appointments
//                     final filteredAppointments = _getFilteredAppointments(
//                       bookingProvider.patientBookings,
//                     );
//
//                     // Show empty state
//                     if (filteredAppointments.isEmpty) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.calendar_today_outlined,
//                               size: 60,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               _selectedFilter == 'all'
//                                   ? 'No appointments found'
//                                   : _selectedFilter == 'upcoming'
//                                   ? 'No upcoming appointments'
//                                   : 'No recent appointments',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//
//                     // Show appointments list
//                     return RefreshIndicator(
//                       onRefresh: () async {
//                         await bookingProvider.fetchPatientBookings();
//                       },
//                       child: ListView.builder(
//                         physics: AlwaysScrollableScrollPhysics(),
//                         itemCount: filteredAppointments.length,
//                         itemBuilder: (context, index) {
//                           final booking = filteredAppointments[index];
//                           return AppointmentWidget(
//                             onTap: (){
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => PatientAppointmentDetailScreen(booking: booking),
//                                 ),
//                               );
//                             },
//                             date: _formatDate(booking.date),
//                             time: booking.time ?? 'Time not set',
//                             status: _mapStatus(booking.status),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ---------------- FILTER TABS ---------------- ///
//   Widget _buildFilterTabs() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildFilterButton(
//             'all',
//             'All',
//             Icons.list_alt,
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: _buildFilterButton(
//             'upcoming',
//             'Upcoming',
//             Icons.upcoming,
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: _buildFilterButton(
//             'recent',
//             'Recent',
//             Icons.history,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilterButton(String value, String label, IconData icon) {
//     final isSelected = _selectedFilter == value;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedFilter = value;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? QColors.newPrimary500 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.grey.shade700,
//               size: 24,
//             ),
//             SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.grey.shade700,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ---------------- FILTER APPOINTMENTS ---------------- ///
//   List<dynamic> _getFilteredAppointments(List<dynamic> bookings) {
//     if (_selectedFilter == 'all') {
//       return bookings;
//     } else if (_selectedFilter == 'upcoming') {
//       return bookings.where((booking) {
//         return booking.status == 'pending' ||
//             booking.status == 'accepted' ||
//             booking.status == 'confirmed';
//       }).toList();
//     } else {
//       // recent
//       return bookings.where((booking) {
//         return booking.status == 'completed' ||
//             booking.status == 'rejected' ||
//             booking.status == 'cancelled' ||
//             booking.status == 'no-show';
//       }).toList();
//     }
//   }
//
//   /// ---------------- HELPER METHODS ---------------- ///
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


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';

import '../../../provider/BookingProvider.dart';

class ViewAllAppointmentsScreen extends StatefulWidget {
  final String? filterType; // 'upcoming' or 'recent'

  const ViewAllAppointmentsScreen({
    super.key,
    this.filterType,
  });

  @override
  State<ViewAllAppointmentsScreen> createState() => _ViewAllAppointmentsScreenState();
}

class _ViewAllAppointmentsScreenState extends State<ViewAllAppointmentsScreen> {
  String _selectedFilter = 'all'; // all, upcoming, recent

  @override
  void initState() {
    super.initState();
    // Set initial filter if provided
    if (widget.filterType != null) {
      _selectedFilter = widget.filterType!;
    }

    // Fetch patient bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchPatientBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomBackButton(),
              SizedBox(height: 20),

              HeadingText(text: "All Appointments"),
              SizedBox(height: 20),

              /// ---------------- FILTER TABS ---------------- ///
              _buildFilterTabs(),
              SizedBox(height: 20),

              /// ---------------- APPOINTMENTS LIST ---------------- ///
              Expanded(
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
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error loading appointments',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              bookingProvider.errorMessage ?? 'Unknown error',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
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

                    // Get filtered appointments
                    final filteredAppointments = _getFilteredAppointments(
                      bookingProvider.patientBookings,
                    );

                    // Show empty state
                    if (filteredAppointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _selectedFilter == 'all'
                                  ? 'No appointments found'
                                  : _selectedFilter == 'upcoming'
                                  ? 'No upcoming appointments'
                                  : 'No recent appointments',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Show appointments list
                    return RefreshIndicator(
                      onRefresh: () async {
                        await bookingProvider.fetchPatientBookings();
                      },
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: filteredAppointments.length,
                        itemBuilder: (context, index) {
                          final booking = filteredAppointments[index];
                          return AppointmentWidget(
                            date: _formatDate(booking.date),
                            time: booking.time ?? 'Time not set',
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
                            onDirectionsTap: () {
                              _navigateToDirections(
                                context,
                                booking.doctorLatitude,
                                booking.doctorLongitude,
                                booking.doctorName ?? 'Doctor Location',
                                booking.doctorName,
                                null, // specialization not available
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- FILTER TABS ---------------- ///
  Widget _buildFilterTabs() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterButton(
            'all',
            'All',
            Icons.list_alt,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildFilterButton(
            'upcoming',
            'Upcoming',
            Icons.upcoming,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildFilterButton(
            'recent',
            'Recent',
            Icons.history,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? QColors.newPrimary500 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- NAVIGATE TO DIRECTIONS ---------------- ///
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

  /// ---------------- FILTER APPOINTMENTS ---------------- ///
  List<dynamic> _getFilteredAppointments(List<dynamic> bookings) {
    if (_selectedFilter == 'all') {
      return bookings;
    } else if (_selectedFilter == 'upcoming') {
      return bookings.where((booking) {
        return booking.status == 'pending' ||
            booking.status == 'accepted' ||
            booking.status == 'confirmed';
      }).toList();
    } else {
      // recent
      return bookings.where((booking) {
        return booking.status == 'completed' ||
            booking.status == 'rejected' ||
            booking.status == 'cancelled' ||
            booking.status == 'no-show';
      }).toList();
    }
  }

  /// ---------------- HELPER METHODS ---------------- ///
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