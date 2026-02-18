



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/modules/doctor/widgets/summary_item.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/image_path.dart';

import '../../../data/models/response/BookingResponse.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/sizes.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../provider/BookingProvider.dart';
import '../doctorappointment/AppointmentDetailScreen.dart';
import '../widgets/StatusActionSection.dart';


class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late Timer _timer;
  late String _currentDateTime;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime();
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
    super.dispose();
  }

  // Get next upcoming appointment (pending only)
  BookingResponse? _getNextAppointment(List<BookingResponse> bookings) {
    if (bookings.isEmpty) return null;

    final now = DateTime.now();

    // Filter for ONLY pending appointments that are in the future
    final upcomingBookings = bookings.where((booking) {
      try {
        final bookingDateTime = DateTime.parse('${booking.date} ${booking.time}');
        final status = booking.status.toLowerCase();

        // Only show pending appointments
        return bookingDateTime.isAfter(now) && status == 'pending';
      } catch (e) {
        return false;
      }
    }).toList();

    if (upcomingBookings.isEmpty) return null;

    // Sort by date and time to get the nearest one
    upcomingBookings.sort((a, b) {
      final dateTimeA = DateTime.parse('${a.date} ${a.time}');
      final dateTimeB = DateTime.parse('${b.date} ${b.time}');
      return dateTimeA.compareTo(dateTimeB);
    });

    return upcomingBookings.first;
  }

  Map<String, int> _calculateSummary(List<BookingResponse> bookings) {
    int total = bookings.length;
    int pending = bookings.where((b) => b.status.toLowerCase() == 'pending').length;
    int approved = bookings.where((b) => b.status.toLowerCase() == 'approved').length;
    int rejected = bookings.where((b) => b.status.toLowerCase() == 'rejected').length;
    int cancelled = bookings.where((b) => b.status.toLowerCase() == 'cancelled').length;
    int noShow = bookings.where((b) => b.status.toLowerCase() == 'no show').length;
    int completed = bookings.where((b) => b.status.toLowerCase() == 'completed').length;

    return {
      'total': total,
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
      'cancelled': cancelled,
      'no_show': noShow,
      'completed': completed,
    };
  }

  // Format date and time for display
  String _formatDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse('$date $time');
      return DateFormat('d MMM yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return '$date $time';
    }
  }

  // Get status color (matching Django choices)
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

  // Show status update bottom sheet
  void _showStatusUpdateSheet(BookingResponse booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StatusUpdateSheet(booking: booking),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final bookings = bookingProvider.doctorBookings;
            final nextAppointment = _getNextAppointment(bookings);
            final summary = _calculateSummary(bookings);

            return RefreshIndicator(
              onRefresh: () async {
                await bookingProvider.fetchDoctorBookings();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      SizedBox(height: 25),
                      Text(
                        "Next Appointment",
                        style: TAppTextStyle.inter(
                          weight: FontWeight.w700,
                          fontSize: 19,
                          color: QColors.info900,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Next Appointment Container - Clickable with action button
                      Stack(
                        children: [
                          InkWell(
                            onTap: nextAppointment != null
                                ? () => _navigateToDetailScreen(nextAppointment)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300, width: 1),
                              ),
                              child: bookingProvider.isLoading
                                  ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                                  : bookingProvider.hasError
                                  ? Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red, size: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      'Failed to load appointments',
                                      style: TAppTextStyle.inter(
                                        fontSize: 14,
                                        color: Colors.red,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        bookingProvider.fetchDoctorBookings();
                                      },
                                      child: Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                                  : nextAppointment == null
                                  ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No upcoming pending appointments",
                                      style: TAppTextStyle.inter(
                                        fontSize: 15,
                                        weight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Date: ${_formatDateTime(nextAppointment.date, nextAppointment.time)}",
                                          style: TAppTextStyle.inter(
                                            fontSize: 15,
                                            weight: FontWeight.w600,
                                            color: QColors.iconColorDark,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // Status badge
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(nextAppointment.status).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              nextAppointment.status.toUpperCase(),
                                              style: TAppTextStyle.inter(
                                                fontSize: 10,
                                                weight: FontWeight.bold,
                                                color: _getStatusColor(nextAppointment.status),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.touch_app,
                                            size: 18,
                                            color: QColors.progressLight,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "Patient - ",
                                        style: TAppTextStyle.inter(
                                          fontSize: 15,
                                          weight: FontWeight.w500,
                                          color: QColors.iconColorDark,
                                        ),
                                      ),
                                      Text(
                                        nextAppointment.patientName,
                                        style: TAppTextStyle.inter(
                                          fontSize: 15,
                                          weight: FontWeight.bold,
                                          color: QColors.containerbackgroundColorLightMode,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Symptoms: ${nextAppointment.currentSymptoms}",
                                    style: TAppTextStyle.inter(
                                      fontSize: 13,
                                      weight: FontWeight.w400,
                                      color: QColors.iconColorDark,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Quick action button - positioned in top-right
                          if (nextAppointment != null)
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showStatusUpdateSheet(nextAppointment),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: QColors.progressLight.withOpacity(0.3),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: QColors.progressLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 25),
                      Center(
                        child: Text(
                          "Summary",
                          style: TAppTextStyle.inter(
                            fontSize: 17,
                            weight: FontWeight.bold,
                            color: QColors.info900,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),

                      // Summary Items - Using exact Django status choices
                      SummaryItem(
                        title: "Total Appointments",
                        value: "${summary['total']}",
                      ),
                      SummaryItem(
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                        title: "Pending",
                        value: "${summary['pending']}",
                      ),
                      SummaryItem(
                        icon: Icons.check_circle,
                        color: Colors.green,
                        title: "Approved",
                        value: "${summary['approved']}",
                      ),
                      SummaryItem(
                        icon: Icons.cancel,
                        color: Colors.red,
                        title: "Rejected",
                        value: "${summary['rejected']}",
                      ),
                      SummaryItem(
                        icon: Icons.close,
                        color: Colors.deepOrange,
                        title: "Cancelled",
                        value: "${summary['cancelled']}",
                      ),
                      SummaryItem(
                        icon: Icons.person_off,
                        color: Colors.purple,
                        title: "No Show",
                        value: "${summary['no_show']}",
                      ),
                      SummaryItem(
                        icon: Icons.check_circle_outline,
                        color: Colors.blue,
                        title: "Completed",
                        value: "${summary['completed']}",
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

// Status Update Bottom Sheet Widget
class _StatusUpdateSheet extends StatefulWidget {
  final BookingResponse booking;

  const _StatusUpdateSheet({required this.booking});

  @override
  State<_StatusUpdateSheet> createState() => _StatusUpdateSheetState();
}

class _StatusUpdateSheetState extends State<_StatusUpdateSheet> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String status, String actionLabel) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm $actionLabel'),
        content: Text(
          'Are you sure you want to $actionLabel this appointment for ${widget.booking.patientName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getStatusColor(status),
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isUpdating = true);

    if (!mounted) return;

    final success = await context.read<BookingProvider>().updateBookingStatus(
      id: widget.booking.id,
      status: status,
    );

    if (!mounted) return;

    setState(() => _isUpdating = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment ${actionLabel}d successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // Close bottom sheet
    } else {
      final error = context.read<BookingProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to $actionLabel: ${error ?? "Unknown error"}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final currentStatus = widget.booking.status.toLowerCase();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) {
          if (_isUpdating) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Updating appointment status...',
                    style: TAppTextStyle.inter(
                      fontSize: 16,
                      weight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update Appointment',
                      style: TAppTextStyle.inter(
                        fontSize: 18,
                        weight: FontWeight.bold,
                        color: QColors.info900,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Patient Info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: QColors.iconColorDark),
                              SizedBox(width: 8),
                              Text(
                                widget.booking.patientName,
                                style: TAppTextStyle.inter(
                                  fontSize: 15,
                                  weight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          // Current status badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(currentStatus).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currentStatus.toUpperCase(),
                              style: TAppTextStyle.inter(
                                fontSize: 10,
                                weight: FontWeight.bold,
                                color: _getStatusColor(currentStatus),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '${widget.booking.date} at ${widget.booking.time}',
                            style: TAppTextStyle.inter(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  'Change Status:',
                  style: TAppTextStyle.inter(
                    fontSize: 14,
                    weight: FontWeight.w600,
                    color: QColors.iconColorDark,
                  ),
                ),
                SizedBox(height: 10),

                // Status Action Buttons - Based on Django STATUS_CHOICES
                if (currentStatus == 'pending') ...[
                  StatusActionTile(
                    icon: Icons.check_circle,
                    label: 'Approve Appointment',
                    color: Colors.green,
                    onTap: () => _updateStatus('approved', 'approve'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.cancel,
                    label: 'Reject Appointment',
                    color: Colors.red,
                    onTap: () => _updateStatus('rejected', 'reject'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.close,
                    label: 'Cancel Appointment',
                    color: Colors.deepOrange,
                    onTap: () => _updateStatus('cancelled', 'cancel'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.check_circle_outline,
                    label: 'Mark as Completed',
                    color: Colors.blue,
                    onTap: () => _updateStatus('completed', 'complete'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.person_off,
                    label: 'Mark as No Show',
                    color: Colors.purple,
                    onTap: () => _updateStatus('no show', 'mark as no show'),
                  ),
                ],

                if (currentStatus == 'approved') ...[
                  StatusActionTile(
                    icon: Icons.check_circle_outline,
                    label: 'Mark as Completed',
                    color: Colors.blue,
                    onTap: () => _updateStatus('completed', 'complete'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.person_off,
                    label: 'Mark as No Show',
                    color: Colors.purple,
                    onTap: () => _updateStatus('no show', 'mark as no show'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.close,
                    label: 'Cancel Appointment',
                    color: Colors.deepOrange,
                    onTap: () => _updateStatus('cancelled', 'cancel'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.cancel,
                    label: 'Reject Appointment',
                    color: Colors.red,
                    onTap: () => _updateStatus('rejected', 'reject'),
                  ),
                ],

                if (currentStatus == 'rejected') ...[
                  StatusActionTile(
                    icon: Icons.check_circle,
                    label: 'Approve Appointment',
                    color: Colors.green,
                    onTap: () => _updateStatus('approved', 'approve'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.close,
                    label: 'Cancel Appointment',
                    color: Colors.deepOrange,
                    onTap: () => _updateStatus('cancelled', 'cancel'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.pending_actions,
                    label: 'Move to Pending',
                    color: Colors.orange,
                    onTap: () => _updateStatus('pending', 'move to pending'),
                  ),
                ],

                if (currentStatus == 'cancelled') ...[
                  StatusActionTile(
                    icon: Icons.pending_actions,
                    label: 'Move to Pending',
                    color: Colors.orange,
                    onTap: () => _updateStatus('pending', 'move to pending'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.check_circle,
                    label: 'Approve Appointment',
                    color: Colors.green,
                    onTap: () => _updateStatus('approved', 'approve'),
                  ),
                ],

                if (currentStatus == 'completed') ...[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'This appointment is completed.',
                            textAlign: TextAlign.center,
                            style: TAppTextStyle.inter(
                              fontSize: 15,
                              color: Colors.black87,
                              weight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'The appointment has been successfully completed.',
                            textAlign: TextAlign.center,
                            style: TAppTextStyle.inter(
                              fontSize: 13,
                              color: Colors.grey,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (currentStatus == 'no show') ...[
                  StatusActionTile(
                    icon: Icons.check_circle_outline,
                    label: 'Mark as Completed',
                    color: Colors.blue,
                    onTap: () => _updateStatus('completed', 'complete'),
                  ),
                  SizedBox(height: 8),
                  StatusActionTile(
                    icon: Icons.close,
                    label: 'Cancel Appointment',
                    color: Colors.deepOrange,
                    onTap: () => _updateStatus('cancelled', 'cancel'),
                  ),
                ],

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}