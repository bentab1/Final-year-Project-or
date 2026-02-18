import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/data/models/response/BookingResponse.dart';
import 'package:quickmed/modules/provider/BookingProvider.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/StatusActionTile.dart';

import '../doctormap/get_direction_screen.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final BookingResponse booking;

  const AppointmentDetailScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  String _formatDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse('$date $time');
      return DateFormat('EEEE, d MMM yyyy | hh:mm a').format(dateTime);
    } catch (e) {
      return '$date $time';
    }
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final dateTime = DateTime(2000, 1, 1, hour, minute);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return time;
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_actions;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.close;
      case 'completed':
        return Icons.check_circle_outline;
      case 'no show':
        return Icons.person_off;
      default:
        return Icons.info_outline;
    }
  }

  void _showStatusUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StatusUpdateSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointment Details',
          style: TAppTextStyle.inter(
            fontSize: 18,
            weight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom + 20, // safe dynamic padding
        ),        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getStatusIcon(booking.status), color: statusColor, size: 24),
                  SizedBox(width: 8),
                  Text(
                    booking.status.toUpperCase(),
                    style: TAppTextStyle.inter(
                      fontSize: 16,
                      weight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Patient Information Card
            _buildInfoCard(
              context,
              title: 'Patient Information',
              icon: Icons.person,
              children: [
                _buildInfoRow('Name', booking.patientName, Icons.person_outline),
                _buildDivider(),
                _buildInfoRow('Booking ID', '#${booking.id}', Icons.confirmation_number_outlined),
              ],
            ),

            SizedBox(height: 16),

            // Appointment Details Card
            _buildInfoCard(
              context,
              title: 'Appointment Details',
              icon: Icons.calendar_today,
              children: [
                _buildInfoRow('Date', _formatDate(booking.date), Icons.calendar_today_outlined),
                _buildDivider(),
                _buildInfoRow('Time', _formatTime(booking.time), Icons.access_time),
                _buildDivider(),
                _buildInfoRow('Full Date & Time', _formatDateTime(booking.date, booking.time), Icons.schedule),
              ],
            ),

            SizedBox(height: 16),

            // Medical Information Card
            _buildInfoCard(
              context,
              title: 'Medical Information',
              icon: Icons.medical_services,
              children: [
                _buildDetailRow('Current Symptoms', booking.currentSymptoms, Icons.sick),
                _buildDivider(),
                _buildDetailRow('Medical History', booking.medicalHistory, Icons.history),
              ],
            ),

            SizedBox(height: 24),

            // Action Button
            if (booking.status.toLowerCase() != 'completed' &&
                booking.status.toLowerCase() != 'cancelled' &&
                booking.status.toLowerCase() != 'rejected')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _showStatusUpdateSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: QColors.progressLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Update Status',
                      style: TAppTextStyle.inter(
                        fontSize: 16,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 32),
            // After the existing Update Status button block, before the last SizedBox(height: 32)

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _openGetDirections(context),
                  icon: Icon(Icons.directions, color: QColors.progressLight),
                  label: Text(
                    'Get Directions',
                    style: TAppTextStyle.inter(
                      fontSize: 16,
                      weight: FontWeight.w600,
                      color: QColors.progressLight,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: QColors.progressLight, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12), // spacing between the two buttons
          ],
        ),
      ),
    );
  }
  void _openGetDirections(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GetDirectionScreen(
          locationData: {
            'doctorName':    booking.patientName,
            'latitude':      booking.doctorLatitude,
            'longitude':     booking.doctorLongitude,
            'patientName':   booking.patientName,
            'patientLat':    booking.patientLatitude,
            'patientLng':    booking.patientLongitude,
          },
        ),
      ),
    );
  }
  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: QColors.progressLight),
              SizedBox(width: 8),
              Text(
                title,
                style: TAppTextStyle.inter(
                  fontSize: 16,
                  weight: FontWeight.bold,
                  color: QColors.info900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TAppTextStyle.inter(
                    fontSize: 12,
                    weight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TAppTextStyle.inter(
                    fontSize: 15,
                    weight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade600),
              SizedBox(width: 8),
              Text(
                label,
                style: TAppTextStyle.inter(
                  fontSize: 12,
                  weight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: TAppTextStyle.inter(
                fontSize: 14,
                weight: FontWeight.w500,
                color: value.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1);
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
      Navigator.pop(context); // Close detail screen
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
                          Icon(Icons.check_circle_outline, size: 48, color: Colors.blue),
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