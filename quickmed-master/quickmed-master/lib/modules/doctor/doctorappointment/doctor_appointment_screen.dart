

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/response/BookingResponse.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/sizes.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/StatusActionTile.dart';
import '../../provider/BookingProvider.dart';
import '../widgets/appointment_card_widget.dart';
import 'AppointmentDetailScreen.dart'; // Add this import
import 'EmptyStateWidget.dart';
import 'ErrorStateWidget.dart';
import 'StatusColorHelper.dart';
import 'StatusFilterChip.dart';
import 'StatusUpdateBottomSheet.dart';

class DoctorAppointments extends StatefulWidget {
  const DoctorAppointments({super.key});

  @override
  State<DoctorAppointments> createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  late Timer _timer;
  late String _currentDateTime;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, pending, approved, rejected, cancelled, completed, no show

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime();
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Fetch doctor bookings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchDoctorBookings();
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEE d MMM yyyy | HH:mm:ss');
    setState(() {
      _currentDateTime = dateFormat.format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Show status update bottom sheet
  void _showStatusUpdateSheet(BookingResponse booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatusUpdateBottomSheet(booking: booking),
    );
  }

  // Navigate to detail screen
  void _navigateToDetailScreen(BookingResponse booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(booking: booking),
      ),
    );
  }

  // Format booking to display format
  Map<String, String> _formatBooking(BookingResponse booking) {
    try {
      final dateTime = DateTime.parse('${booking.date} ${booking.time}');
      final day = DateFormat('EEEE').format(dateTime); // Wednesday
      final date = DateFormat('dd MMM yyyy').format(dateTime); // 08 Oct 2025
      final time = DateFormat('hh:mm a').format(dateTime); // 09:30 AM

      return {
        'patientName': booking.patientName,
        'day': day,
        'date': date,
        'time': 'Time: $time',
        'status': _capitalizeFirst(booking.status),
        'id': booking.id.toString(),
        'symptoms': booking.currentSymptoms,
        'medicalHistory': booking.medicalHistory,
      };
    } catch (e) {
      return {
        'patientName': booking.patientName,
        'day': '',
        'date': booking.date,
        'time': 'Time: ${booking.time}',
        'status': _capitalizeFirst(booking.status),
        'id': booking.id.toString(),
        'symptoms': booking.currentSymptoms,
        'medicalHistory': booking.medicalHistory,
      };
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    // Handle "no show" specially
    if (text.toLowerCase() == 'no show') return 'No Show';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Filter appointments based on search query and status filter
  List<Map<String, String>> _getFilteredAppointments(List<BookingResponse> bookings) {
    var filtered = bookings;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((b) =>
      b.status.toLowerCase() == _selectedFilter.toLowerCase()
      ).toList();
    }

    // Convert to display format
    var formattedList = filtered.map((b) => _formatBooking(b)).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      formattedList = formattedList.where((appointment) {
        final patientName = appointment['patientName']!.toLowerCase();
        final date = appointment['date']!.toLowerCase();
        final status = appointment['status']!.toLowerCase();
        final day = appointment['day']!.toLowerCase();

        return patientName.contains(_searchQuery) ||
            date.contains(_searchQuery) ||
            status.contains(_searchQuery) ||
            day.contains(_searchQuery);
      }).toList();
    }

    // Sort by date (most recent first)
    formattedList.sort((a, b) {
      try {
        final dateA = DateFormat('dd MMM yyyy').parse(a['date']!);
        final dateB = DateFormat('dd MMM yyyy').parse(b['date']!);
        return dateB.compareTo(dateA); // Descending order
      } catch (e) {
        return 0;
      }
    });

    return formattedList;
  }

  // Get status color - Updated to include all Django status choices
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
      case 'no show':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Get status count
  int _getStatusCount(List<BookingResponse> bookings, String status) {
    if (status == 'all') return bookings.length;
    return bookings.where((b) => b.status.toLowerCase() == status).length;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final bookings = bookingProvider.doctorBookings;
            final filteredAppointments = _getFilteredAppointments(bookings);

            return RefreshIndicator(
              onRefresh: () async {
                await bookingProvider.fetchDoctorBookings();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    children: [
                      /// TOP BAR WITH PROFILE, SEARCH, NOTIFICATION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              AppRouter.router.push('/doctorProfileScreen');
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(QImagesPath.profile),
                            ),
                          ),
                          SizedBox(width: 2),

                          /// SEARCH FIELD
                          SizedBox(
                            height: 38,
                            width: 230,
                            child: Center(
                              child: TextField(
                                controller: _searchController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Search Appointments",
                                  hintStyle: TAppTextStyle.inter(
                                    weight: FontWeight.w400,
                                    color: QColors.lightGray400,
                                    fontSize: QSizes.fontSizeSmx,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: QColors.lightTextColor,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                      : Icon(
                                    Icons.search,
                                    color: QColors.lightTextColor,
                                    size: 22,
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 20,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: QColors.progressLight,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: QColors.progressLight,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// NOTIFICATION ICON
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none,
                              color: QColors.progressLight,
                              size: 30,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      /// REAL-TIME CLOCK
                      Center(
                        child: Text(
                          "Today: $_currentDateTime",
                          style: TAppTextStyle.inter(
                            color: QColors.lightTextColor,
                            fontSize: 20,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      /// STATUS FILTER CHIPS - Updated to include all Django status choices
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            StatusFilterChip(
                              value: 'all',
                              label: 'All',
                              count: _getStatusCount(bookings, 'all'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'pending',
                              label: 'Pending',
                              count: _getStatusCount(bookings, 'pending'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'approved',
                              label: 'Approved',
                              count: _getStatusCount(bookings, 'approved'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'rejected',
                              label: 'Rejected',
                              count: _getStatusCount(bookings, 'rejected'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'cancelled',
                              label: 'Cancelled',
                              count: _getStatusCount(bookings, 'cancelled'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'completed',
                              label: 'Completed',
                              count: _getStatusCount(bookings, 'completed'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                            StatusFilterChip(
                              value: 'no show',
                              label: 'No Show',
                              count: _getStatusCount(bookings, 'no show'),
                              selectedValue: _selectedFilter,
                              onSelected: (value) {
                                setState(() {
                                  _selectedFilter = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      /// SEARCH RESULTS INFO
                      if (_searchQuery.isNotEmpty || _selectedFilter != 'all')
                        Padding(
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
                              if (_searchQuery.isNotEmpty || _selectedFilter != 'all')
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
                                      color: QColors.progressLight,
                                      fontSize: 14,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: 10),

                      /// LOADING STATE
                      if (bookingProvider.isLoading)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )

                      /// ERROR STATE
                      else if (bookingProvider.hasError)
                        ErrorStateWidget(
                          title: "Failed to load appointments",
                          message: bookingProvider.errorMessage ?? "Unknown error",
                          iconColor: Colors.red,
                          onRetry: () => bookingProvider.fetchDoctorBookings(),
                        )

                      /// APPOINTMENTS LIST
                      else if (filteredAppointments.isEmpty)
                          EmptyStateWidget(
                            searchQuery: _searchQuery,
                            selectedFilter: _selectedFilter,
                            onClearFilters: () {
                              setState(() {
                                _searchController.clear();
                                _selectedFilter = 'all';
                              });
                            },
                          )
                        else
                          Column(
                            children: bookings.where((booking) {
                              // Filter based on current filters
                              if (_selectedFilter != 'all' && booking.status.toLowerCase() != _selectedFilter.toLowerCase()) {
                                return false;
                              }
                              if (_searchQuery.isNotEmpty) {
                                final searchLower = _searchQuery.toLowerCase();
                                return booking.patientName.toLowerCase().contains(searchLower) ||
                                    booking.date.toLowerCase().contains(searchLower) ||
                                    booking.status.toLowerCase().contains(searchLower);
                              }
                              return true;
                            }).map((booking) {
                              final formatted = _formatBooking(booking);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Stack(
                                  children: [
                                    // Main card - Navigate to detail screen
                                    GestureDetector(
                                      onTap: () => _navigateToDetailScreen(booking),
                                      child: AppointmentCardWidget(
                                        patientName: formatted['patientName']!,
                                        day: formatted['day']!,
                                        date: formatted['date']!,
                                        time: formatted['time']!,
                                        status: formatted['status']!,
                                      ),
                                    ),

                                    // Quick action button - Show bottom sheet
                                    Positioned(
                                      right: 12,
                                      top: 12,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _showStatusUpdateSheet(booking),
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.more_vert,
                                              size: 20,
                                              color: QColors.progressLight,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
