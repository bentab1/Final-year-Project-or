import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/response/BookingResponse.dart';
import '../../../utils/widgets/StatusActionTile.dart';
import '../../provider/BookingProvider.dart';
import 'StatusColorHelper.dart';

class StatusUpdateBottomSheet extends StatefulWidget {
  final BookingResponse booking;

  const StatusUpdateBottomSheet({required this.booking, Key? key})
    : super(key: key);

  @override
  State<StatusUpdateBottomSheet> createState() =>
      _StatusUpdateBottomSheetState();
}

class _StatusUpdateBottomSheetState extends State<StatusUpdateBottomSheet> {
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
              backgroundColor: StatusColorHelper.getStatusColor(status),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                _PatientInfo(
                  booking: widget.booking,
                  currentStatus: currentStatus,
                ),

                SizedBox(height: 16),
                Text(
                  'Change Status:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),

                // Status Action Buttons
                ..._getStatusActions(currentStatus),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getStatusActions(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return [
          StatusActionTile(
            icon: Icons.check_circle,
            label: 'Approve Appointment',
            color: Colors.green,
            onTap: () => _updateStatus('approved', 'approve'),
          ),
          SizedBox(height: 12),
          StatusActionTile(
            icon: Icons.cancel,
            label: 'Reject Appointment',
            color: Colors.red,
            onTap: () => _updateStatus('rejected', 'reject'),
          ),

          SizedBox(height: 12),

          StatusActionTile(
            icon: Icons.close,
            label: 'Cancel Appointment',
            color: Colors.deepOrange,
            onTap: () => _updateStatus('cancelled', 'cancel'),
          ),

          SizedBox(height: 12),
          StatusActionTile(
            icon: Icons.check_circle_outline,
            label: 'Mark as Completed',
            color: Colors.blue,
            onTap: () => _updateStatus('completed', 'complete'),
          ),

          SizedBox(height: 12),
          StatusActionTile(
            icon: Icons.person_off,
            label: 'Mark as No Show',
            color: Colors.purple,
            onTap: () => _updateStatus('no show', 'mark as no show'),
          ),
        ];
      case 'approved':
        return [
          StatusActionTile(
            icon: Icons.check_circle_outline,
            label: 'Mark as Completed',
            color: Colors.blue,
            onTap: () => _updateStatus('completed', 'complete'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.person_off,
            label: 'Mark as No Show',
            color: Colors.purple,
            onTap: () => _updateStatus('no show', 'mark as no show'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.close,
            label: 'Cancel Appointment',
            color: Colors.deepOrange,
            onTap: () => _updateStatus('cancelled', 'cancel'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.cancel,
            label: 'Reject Appointment',
            color: Colors.red,
            onTap: () => _updateStatus('rejected', 'reject'),
          ),
        ];
      case 'rejected':
        return [
          StatusActionTile(
            icon: Icons.check_circle,
            label: 'Approve Appointment',
            color: Colors.green,
            onTap: () => _updateStatus('approved', 'approve'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.close,
            label: 'Cancel Appointment',
            color: Colors.deepOrange,
            onTap: () => _updateStatus('cancelled', 'cancel'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.pending_actions,
            label: 'Move to Pending',
            color: Colors.orange,
            onTap: () => _updateStatus('pending', 'move to pending'),
          ),
        ];
      case 'cancelled':
        return [
          StatusActionTile(
            icon: Icons.pending_actions,
            label: 'Move to Pending',
            color: Colors.orange,
            onTap: () => _updateStatus('pending', 'move to pending'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.check_circle,
            label: 'Approve Appointment',
            color: Colors.green,
            onTap: () => _updateStatus('approved', 'approve'),
          ),
        ];
      case 'completed':
        return [
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
                  ),
                  Text(
                    'The appointment has been successfully completed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ];
      case 'no show':
        return [
          StatusActionTile(
            icon: Icons.check_circle_outline,
            label: 'Mark as Completed',
            color: Colors.blue,
            onTap: () => _updateStatus('completed', 'complete'),
          ),
          SizedBox(height: 12,),

          StatusActionTile(
            icon: Icons.close,
            label: 'Cancel Appointment',
            color: Colors.deepOrange,
            onTap: () => _updateStatus('cancelled', 'cancel'),
          ),
        ];
      default:
        return [];
    }
  }
}

class _PatientInfo extends StatelessWidget {
  final BookingResponse booking;
  final String currentStatus;

  const _PatientInfo({required this.booking, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Icon(Icons.person, size: 16, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    booking.patientName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: StatusColorHelper.getStatusColor(
                    currentStatus,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentStatus.toUpperCase(),
                  style: TextStyle(
                    color: StatusColorHelper.getStatusColor(currentStatus),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
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
                '${booking.date} at ${booking.time}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
