//
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:quickmed/data/models/response/BookingResponse.dart';
// import 'package:quickmed/utils/app_text_style.dart';
// import 'package:quickmed/utils/theme/colors/q_color.dart';
//
// import '../../../provider/BookingProvider.dart';
//
// class PatientAppointmentDetailScreen extends StatelessWidget {
//   final BookingResponse booking;
//
//   const PatientAppointmentDetailScreen({
//     Key? key,
//     required this.booking,
//   }) : super(key: key);
//
//   String _formatDateTime(String date, String time) {
//     try {
//       final dateTime = DateTime.parse('$date $time');
//       return DateFormat('EEEE, d MMM yyyy | hh:mm a').format(dateTime);
//     } catch (e) {
//       return '$date $time';
//     }
//   }
//
//   String _formatDate(String date) {
//     try {
//       final dateTime = DateTime.parse(date);
//       return DateFormat('d MMM yyyy').format(dateTime);
//     } catch (e) {
//       return date;
//     }
//   }
//
//   String _formatTime(String time) {
//     if (time.isEmpty) return 'Time not set';
//     try {
//       final timeParts = time.split(':');
//       final hour = int.parse(timeParts[0]);
//       final minute = int.parse(timeParts[1]);
//       final dateTime = DateTime(2000, 1, 1, hour, minute);
//       return DateFormat('hh:mm a').format(dateTime);
//     } catch (e) {
//       return time;
//     }
//   }
//
//   String _formatCreatedAt(String createdAt) {
//     try {
//       final dateTime = DateTime.parse(createdAt);
//       return DateFormat('d MMM yyyy, hh:mm a').format(dateTime);
//     } catch (e) {
//       return createdAt;
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'approved':
//       case 'accepted':
//       case 'confirmed':
//         return Colors.green;
//       case 'rejected':
//       case 'cancelled':
//         return Colors.red;
//       case 'completed':
//       case 'complete':
//         return Colors.blue;
//       case 'no show':
//       case 'no-show':
//       case 'noshow':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Icons.pending_actions;
//       case 'approved':
//       case 'accepted':
//       case 'confirmed':
//         return Icons.check_circle;
//       case 'rejected':
//       case 'cancelled':
//         return Icons.cancel;
//       case 'completed':
//       case 'complete':
//         return Icons.check_circle_outline;
//       case 'no show':
//       case 'no-show':
//       case 'noshow':
//         return Icons.person_off;
//       default:
//         return Icons.info_outline;
//     }
//   }
//
//   String _capitalizeStatus(String status) {
//     if (status.toLowerCase() == 'no show' ||
//         status.toLowerCase() == 'no-show' ||
//         status.toLowerCase() == 'noshow') {
//       return 'No Show';
//     }
//     return status[0].toUpperCase() + status.substring(1).toLowerCase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor(booking.status);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Appointment Details',
//           style: TAppTextStyle.inter(
//             fontSize: 18,
//             weight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer<BookingProvider>(
//         builder: (context, bookingProvider, child) {
//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Status Banner
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         border: Border(
//                           bottom: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(_getStatusIcon(booking.status), color: statusColor, size: 24),
//                           SizedBox(width: 8),
//                           Text(
//                             _capitalizeStatus(booking.status).toUpperCase(),
//                             style: TAppTextStyle.inter(
//                               fontSize: 16,
//                               weight: FontWeight.bold,
//                               color: statusColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(height: 16),
//
//                     // Doctor Information Card
//                     _buildInfoCard(
//                       context,
//                       title: 'Doctor Information',
//                       icon: Icons.person,
//                       children: [
//                         _buildInfoRow(
//                             'Doctor Name',
//                             booking.doctorName.isEmpty ? 'Not specified' : booking.doctorName,
//                             Icons.person_outline
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 16),
//
//                     // Appointment Details Card
//                     _buildInfoCard(
//                       context,
//                       title: 'Appointment Details',
//                       icon: Icons.calendar_today,
//                       children: [
//                         _buildInfoRow('Date', _formatDate(booking.date), Icons.calendar_today_outlined),
//                         _buildDivider(),
//                         _buildInfoRow('Time', _formatTime(booking.time), Icons.access_time),
//                         _buildDivider(),
//                         _buildInfoRow('Full Date & Time', _formatDateTime(booking.date, booking.time), Icons.schedule),
//                         _buildDivider(),
//                         _buildInfoRow('Booking ID', '#${booking.id}', Icons.confirmation_number_outlined),
//                         _buildDivider(),
//                         _buildInfoRow('Booked On', _formatCreatedAt(booking.createdAt), Icons.history),
//                       ],
//                     ),
//
//                     SizedBox(height: 16),
//
//                     // Medical Information Card
//                     _buildInfoCard(
//                       context,
//                       title: 'Medical Information',
//                       icon: Icons.medical_services,
//                       children: [
//                         _buildDetailRow('Current Symptoms', booking.currentSymptoms, Icons.sick),
//                         _buildDivider(),
//                         _buildDetailRow('Medical History', booking.medicalHistory, Icons.history),
//                       ],
//                     ),
//
//                     SizedBox(height: 32),
//
//                     // Action Buttons (only for pending/accepted appointments)
//                     if (booking.status.toLowerCase() == 'pending' ||
//                         booking.status.toLowerCase() == 'accepted' ||
//                         booking.status.toLowerCase() == 'approved')
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: ElevatedButton.icon(
//                                 onPressed: bookingProvider.isLoading ? null : () {
//                                   // TODO: Implement reschedule functionality
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Reschedule feature coming soon'),
//                                       behavior: SnackBarBehavior.floating,
//                                     ),
//                                   );
//                                 },
//                                 icon: Icon(Icons.edit_calendar),
//                                 label: Text(
//                                   'Reschedule',
//                                   style: TAppTextStyle.inter(
//                                     fontSize: 16,
//                                     weight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: QColors.newPrimary500,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 2,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: OutlinedButton.icon(
//                                 onPressed: bookingProvider.isLoading
//                                     ? null
//                                     : () => _showCancelDialog(context),
//                                 icon: Icon(Icons.cancel_outlined, color: Colors.red),
//                                 label: Text(
//                                   'Cancel Appointment',
//                                   style: TAppTextStyle.inter(
//                                     fontSize: 16,
//                                     weight: FontWeight.w600,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                                 style: OutlinedButton.styleFrom(
//                                   side: BorderSide(color: Colors.red, width: 2),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//
//               // Loading Overlay
//               if (bookingProvider.isLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.3),
//                   child: Center(
//                     child: Card(
//                       elevation: 8,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(24),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 QColors.newPrimary500,
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'Processing...',
//                               style: TAppTextStyle.inter(
//                                 fontSize: 16,
//                                 weight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(BuildContext context, {
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 20, color: QColors.newPrimary500),
//               SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TAppTextStyle.inter(
//                   fontSize: 16,
//                   weight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           ...children,
//         ],
//       ),
//     );
//   }
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
//   Widget _buildInfoRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Colors.grey.shade600),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TAppTextStyle.inter(
//                     fontSize: 12,
//                     weight: FontWeight.w500,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: TAppTextStyle.inter(
//                     fontSize: 15,
//                     weight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 18, color: Colors.grey.shade600),
//               SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TAppTextStyle.inter(
//                   fontSize: 12,
//                   weight: FontWeight.w500,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: Text(
//               value.isEmpty ? 'Not provided' : value,
//               style: TAppTextStyle.inter(
//                 fontSize: 14,
//                 weight: FontWeight.w500,
//                 color: value.isEmpty ? Colors.grey : Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Divider(color: Colors.grey.shade200, height: 1);
//   }
//
//   void _showCancelDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Cancel Appointment',
//                 style: TAppTextStyle.inter(
//                   fontSize: 18,
//                   weight: FontWeight.bold, color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to cancel this appointment? This action cannot be undone.',
//           style: TAppTextStyle.inter(
//             fontSize: 14,
//             weight: FontWeight.w500,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(
//               'No, Keep It',
//               style: TAppTextStyle.inter(
//                 fontSize: 15,
//                 weight: FontWeight.w600,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx); // Close dialog
//               await _cancelAppointment(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: Text(
//               'Yes, Cancel',
//               style: TAppTextStyle.inter(
//                 fontSize: 15,
//                 weight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _cancelAppointment(BuildContext context) async {
//     final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
//
//     final success = await bookingProvider.deleteBooking(
//       id: booking.id,
//       refreshList: true,
//     );
//
//     if (context.mounted) {
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Appointment cancelled successfully',
//                     style: TAppTextStyle.inter(
//                       fontSize: 14,
//                       weight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: EdgeInsets.all(16),
//             duration: Duration(seconds: 3),
//           ),
//         );
//
//         // Navigate back to previous screen
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.error_outline, color: Colors.white),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Failed to cancel: ${bookingProvider.errorMessage ?? "Unknown error"}',
//                     style: TAppTextStyle.inter(
//                       fontSize: 14,
//                       weight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: EdgeInsets.all(16),
//             duration: Duration(seconds: 4),
//           ),
//         );
//       }
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/data/models/response/BookingResponse.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

import '../../../provider/BookingProvider.dart';

class PatientAppointmentDetailScreen extends StatelessWidget {
  final BookingResponse booking;

  const PatientAppointmentDetailScreen({
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
    if (time.isEmpty) return 'Time not set';
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

  String _formatCreatedAt(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      return DateFormat('d MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return createdAt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
      case 'accepted':
      case 'confirmed':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'completed':
      case 'complete':
        return Colors.blue;
      case 'no show':
      case 'no-show':
      case 'noshow':
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
      case 'accepted':
      case 'confirmed':
        return Icons.check_circle;
      case 'rejected':
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
      case 'complete':
        return Icons.check_circle_outline;
      case 'no show':
      case 'no-show':
      case 'noshow':
        return Icons.person_off;
      default:
        return Icons.info_outline;
    }
  }

  String _capitalizeStatus(String status) {
    if (status.toLowerCase() == 'no show' ||
        status.toLowerCase() == 'no-show' ||
        status.toLowerCase() == 'noshow') {
      return 'No Show';
    }
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  /// Check if appointment status is pending
  bool _isPendingStatus() {
    return booking.status.toLowerCase() == 'pending';
  }

  /// Check if appointment has valid location coordinates
  bool _hasValidLocation() {
    return booking.doctorLatitude != null &&
        booking.doctorLongitude != null &&
        booking.doctorLatitude! > 0 &&
        booking.doctorLongitude! > 0;
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
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                            _capitalizeStatus(booking.status).toUpperCase(),
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

                    // Doctor Information Card
                    _buildInfoCard(
                      context,
                      title: 'Doctor Information',
                      icon: Icons.person,
                      children: [
                        _buildInfoRow(
                            'Doctor Name',
                            booking.doctorName.isEmpty ? 'Not specified' : booking.doctorName,
                            Icons.person_outline
                        ),
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
                        _buildDivider(),
                        _buildInfoRow('Booking ID', '#${booking.id}', Icons.confirmation_number_outlined),
                        _buildDivider(),
                        _buildInfoRow('Booked On', _formatCreatedAt(booking.createdAt), Icons.history),
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

                    SizedBox(height: 32),

                    // Action Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Get Directions Button (show if valid location)
                          if (_hasValidLocation())
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => _navigateToDirections(context),
                                icon: Icon(Icons.directions, size: 22),
                                label: Text(
                                  'Get Directions',
                                  style: TAppTextStyle.inter(
                                    fontSize: 16,
                                    weight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: QColors.newPrimary500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),

                          // Add spacing if both buttons are shown
                          if (_hasValidLocation() && _isPendingStatus())
                            SizedBox(height: 12),

                          // Cancel Button (only for pending appointments)
                          if (_isPendingStatus())
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: bookingProvider.isLoading
                                    ? null
                                    : () => _showCancelDialog(context),
                                icon: Icon(Icons.cancel_outlined, color: Colors.red),
                                label: Text(
                                  'Cancel Appointment',
                                  style: TAppTextStyle.inter(
                                    fontSize: 16,
                                    weight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.red, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),

              // Loading Overlay
              if (bookingProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                QColors.newPrimary500,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Processing...',
                              style: TAppTextStyle.inter(
                                fontSize: 16,
                                weight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
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
              Icon(icon, size: 20, color: QColors.newPrimary500),
              SizedBox(width: 8),
              Text(
                title,
                style: TAppTextStyle.inter(
                  fontSize: 16,
                  weight: FontWeight.bold,
                  color: Colors.black87,
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

  /// Navigate to DirectionOptionsScreen with location data
  void _navigateToDirections(BuildContext context) {
    // Validate coordinates
    if (!_hasValidLocation()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Location coordinates not available',
                  style: TAppTextStyle.inter(
                    fontSize: 14,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Prepare location data
    final Map<String, dynamic> locationData = {
      'latitude': booking.doctorLatitude,
      'longitude': booking.doctorLongitude,
      'location': booking.doctorName.isEmpty ? 'Doctor Location' : booking.doctorName,
      'doctorName': booking.doctorName,
      'specialization': null,
    };

    print('📍 Navigating to directions with data: $locationData');

    // Navigate using GoRouter
    context.push('/directionOptions', extra: locationData);
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

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cancel Appointment',
                style: TAppTextStyle.inter(
                  fontSize: 18,
                  weight: FontWeight.bold, color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel this appointment? This action cannot be undone.',
          style: TAppTextStyle.inter(
            fontSize: 14,
            weight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'No, Keep It',
              style: TAppTextStyle.inter(
                fontSize: 15,
                weight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              await _cancelAppointment(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Yes, Cancel',
              style: TAppTextStyle.inter(
                fontSize: 15,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    final success = await bookingProvider.deleteBooking(
      id: booking.id,
      refreshList: true,
    );

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Appointment cancelled successfully',
                    style: TAppTextStyle.inter(
                      fontSize: 14,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate back to previous screen
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to cancel: ${bookingProvider.errorMessage ?? "Unknown error"}',
                    style: TAppTextStyle.inter(
                      fontSize: 14,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }
}