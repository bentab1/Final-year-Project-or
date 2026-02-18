import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_detail_screen.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/appointment_widget.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';

import '../../../../data/models/response/BookingResponse.dart';
import '../../../../utils/app_text_style.dart';
import '../../../provider/BookingProvider.dart';

class PatientAppointmentScreen extends StatefulWidget {
  const PatientAppointmentScreen({super.key});

  @override
  State<PatientAppointmentScreen> createState() => _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, pending, approved, rejected, cancelled, completed

  @override
  void initState() {
    super.initState();

    // Listen to search changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Fetch patient bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchPatientBookings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Status _getAppointmentStatus(String? status) {
    if (status == null) return Status.pending;

    switch (status.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
      case 'approved':
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

  // Helper method to format date
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Helper method to format time
  String _formatTime(DateTime? time) {
    if (time == null) return 'N/A';
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Filter appointments based on search query and status filter
  List<BookingResponse> _getFilteredAppointments(List<BookingResponse> bookings) {
    var filtered = bookings;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((b) {
        final status = b.status.toLowerCase();
        final filter = _selectedFilter.toLowerCase();

        // Handle different status mappings
        if (filter == 'approved') {
          return status == 'approved' || status == 'accepted' || status == 'confirmed';
        }
        if (filter == 'rejected') {
          return status == 'rejected' || status == 'cancelled';
        }
        if (filter == 'completed') {
          return status == 'completed' || status == 'complete';
        }

        return status == filter;
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        final doctorName = (booking.doctorName ?? '').toLowerCase();
        final date = booking.date.toLowerCase();
        final status = booking.status.toLowerCase();
        final time = booking.time.toLowerCase();

        return doctorName.contains(_searchQuery) ||
            date.contains(_searchQuery) ||
            status.contains(_searchQuery) ||
            time.contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  // Get status count
  int _getStatusCount(List<BookingResponse> bookings, String status) {
    if (status == 'all') return bookings.length;

    return bookings.where((b) {
      final bookingStatus = b.status.toLowerCase();
      final filter = status.toLowerCase();

      // Handle different status mappings
      if (filter == 'approved') {
        return bookingStatus == 'approved' || bookingStatus == 'accepted' || bookingStatus == 'confirmed';
      }
      if (filter == 'rejected') {
        return bookingStatus == 'rejected' || bookingStatus == 'cancelled';
      }
      if (filter == 'completed') {
        return bookingStatus == 'completed' || bookingStatus == 'complete';
      }

      return bookingStatus == filter;
    }).length;
  }

  // Get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.deepOrange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
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
              SizedBox(height: 10),
              CustomBackButton(),
              SizedBox(height: 20),
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
                        onPressed: () {},
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
              HeadingText(text: "Appointments"),
              SizedBox(height: 15),

              /// ---------------- STATUS FILTER TABS ---------------- ///
              Consumer<BookingProvider>(
                builder: (context, bookingProvider, child) {
                  final bookings = bookingProvider.patientBookings;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'All', _getStatusCount(bookings, 'all')),
                        SizedBox(width: 8),
                        _buildFilterChip('pending', 'Pending', _getStatusCount(bookings, 'pending')),
                        SizedBox(width: 8),
                        _buildFilterChip('approved', 'Approved', _getStatusCount(bookings, 'approved')),
                        SizedBox(width: 8),
                        _buildFilterChip('completed', 'Completed', _getStatusCount(bookings, 'completed')),
                        SizedBox(width: 8),
                        _buildFilterChip('rejected', 'Rejected', _getStatusCount(bookings, 'rejected')),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 15),

              /// ---------------- SEARCH RESULTS INFO ---------------- ///
              Consumer<BookingProvider>(
                builder: (context, bookingProvider, child) {
                  final filteredAppointments = _getFilteredAppointments(bookingProvider.patientBookings);

                  if (_searchQuery.isNotEmpty || _selectedFilter != 'all') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Results: ${filteredAppointments.length}",
                            style: TAppTextStyle.inter(
                              color: QColors.lightTextColor,
                              fontSize: 16,
                              weight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _selectedFilter = 'all';
                              });
                            },
                            child: Text(
                              "Clear Filters",
                              style: TAppTextStyle.inter(
                                color: QColors.newPrimary500,
                                fontSize: 14,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

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
                    final filteredAppointments = _getFilteredAppointments(bookingProvider.patientBookings);

                    // Show empty state
                    if (filteredAppointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isNotEmpty || _selectedFilter != 'all'
                                  ? Icons.search_off
                                  : Icons.calendar_today_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? "No appointments found for '$_searchQuery'"
                                  : _selectedFilter != 'all'
                                  ? "No ${_selectedFilter} appointments"
                                  : 'No appointments found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_searchQuery.isNotEmpty || _selectedFilter != 'all') ...[
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _selectedFilter = 'all';
                                  });
                                },
                                child: Text(
                                  "Clear Filters",
                                  style: TAppTextStyle.inter(
                                    color: QColors.newPrimary500,
                                    fontSize: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    // Show appointments list
                    return RefreshIndicator(
                      onRefresh: () async {
                        await bookingProvider.fetchPatientBookings();
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Display filtered appointments
                            ...filteredAppointments.map((booking) {
                              return AppointmentWidget(
                                date: booking.date,
                                time: booking.time,
                                status: _getAppointmentStatus(booking.status),
                                onAppointmentTap: (){

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientAppointmentDetailScreen(booking: booking),
                                    ),
                                  );
                                },
                                // Add these if your AppointmentWidget supports them:
                                // doctorName: booking.doctorName,
                                // specialty: booking.specialty,
                                // onTap: () => context.push('/appointmentDetails/${booking.id}'),
                              );
                            }).toList(),
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

  /// FILTER CHIP WIDGET
  Widget _buildFilterChip(String value, String label, int count) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: _getStatusColor(value).withOpacity(0.2),
      checkmarkColor: _getStatusColor(value),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TAppTextStyle.inter(
        fontSize: 13,
        weight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? _getStatusColor(value) : Colors.grey.shade700,
      ),
    );
  }
}