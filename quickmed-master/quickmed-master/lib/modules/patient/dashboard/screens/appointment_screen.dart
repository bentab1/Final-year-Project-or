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

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final TextEditingController _searchController = TextEditingController();
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

  Status _mapStatus(String? status) {
    if (status == null) {
      print('⚠️ Status is null, returning pending');
      return Status.pending;
    }

    // Debug: Print the raw status value
    print('📊 Mapping status: "$status" (lowercase: "${status.toLowerCase()}")');

    final lowercaseStatus = status.toLowerCase().trim();

    Status mappedStatus;
    switch (lowercaseStatus) {
      case 'accepted':
      case 'confirmed':
      case 'approved':
      case 'approve':
        mappedStatus = Status.accepted;
        break;
      case 'rejected':
      case 'cancelled':
      case 'canceled':
      case 'reject':
        mappedStatus = Status.rejected;
        break;
      case 'completed':
      case 'complete':
      case 'done':
        mappedStatus = Status.complete;
        break;
      case 'no-show':
      case 'noshow':
      case 'no_show':
        mappedStatus = Status.noShow;
        break;
      case 'pending':
      case 'waiting':
      default:
        mappedStatus = Status.pending;
        break;
    }

    print('✅ Mapped "$status" to $mappedStatus');
    return mappedStatus;
  }

  // Helper method to format date
  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('d MMMM yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  // Helper method to format time
  String _formatTime(String? time) {
    if (time == null) return 'N/A';
    try {
      // Parse time string (e.g., "09:00:00" or "12:00:00")
      final parts = time.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final tempDate = DateTime(2000, 1, 1, hour, minute);
        return DateFormat('h:mm a').format(tempDate);
      }
      return time;
    } catch (e) {
      return time;
    }
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

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                      height: 42,
                      dark: isDark,
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

              /// ---------------- APPOINTMENTS LIST ---------------- ///
              HeadingText(text: "Appointments"),

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

                    // Show error message with pull-to-refresh
                    if (bookingProvider.hasError) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await bookingProvider.fetchPatientBookings();
                        },
                        color: QColors.newPrimary500,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                    child: Text(
                                      bookingProvider.errorMessage ?? 'Unknown error',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Pull down to refresh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
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
                            ),
                          ),
                        ),
                      );
                    }

                    // Show empty state with pull-to-refresh
                    if (bookingProvider.patientBookings.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await bookingProvider.fetchPatientBookings();
                        },
                        color: QColors.newPrimary500,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No appointments found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Book your first appointment',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Pull down to refresh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    // Show appointments list with pull-to-refresh
                    final appointments = bookingProvider.patientBookings;

                    return RefreshIndicator(
                      onRefresh: () async {
                        await bookingProvider.fetchPatientBookings();
                      },
                      color: QColors.newPrimary500,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Display first 2 appointments
                            ...appointments.take(2).map((booking) {
                              // Debug print booking data
                              _debugPrintBookingData(booking);

                              return AppointmentWidget(
                                date: _formatDate(booking.date),
                                time: _formatTime(booking.time),
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
                                  print('Appointment tapped: ${booking.id}');
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
                            }).toList(),

                            // View All button
                            Container(
                              alignment: Alignment.topRight,
                              child: QButton(
                                text: appointments.length > 2
                                    ? "View All (${appointments.length})"
                                    : "View All",
                                width: appointments.length > 2 ? 140 : 100,
                                buttonType: QButtonType.text,
                                onPressed: () {
                                  // Navigate to full appointments list
                                  context.push('/patientAppointmentScreen');
                                },
                              ),
                            ),
                          ],
                        ),
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

  // Debug method to print booking data
  void _debugPrintBookingData(dynamic booking) {
    print('=== Booking Data ===');
    print('ID: ${booking.id}');
    print('Date: ${booking.date}');
    print('Time: ${booking.time}');
    print('Status (raw): "${booking.status}"');
    print('Status (mapped): ${_mapStatus(booking.status)}');
    print('Doctor Name: ${booking.doctorName}');
    print('Doctor Latitude: ${booking.doctorLatitude}');
    print('Doctor Longitude: ${booking.doctorLongitude}');
    print('Medical History: ${booking.medicalHistory}');
    print('Current Symptoms: ${booking.currentSymptoms}');
    print('==================');
  }
}