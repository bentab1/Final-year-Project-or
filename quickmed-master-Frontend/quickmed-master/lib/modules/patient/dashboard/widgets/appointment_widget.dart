import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_text_style.dart';
import '../../../../utils/device_utility.dart';
import '../../../../utils/theme/colors/q_color.dart';
import '../../../../utils/widgets/TButton.dart';

class AppointmentWidget extends StatelessWidget {
  final String date;
  final String time;
  final Status status;

  // Callbacks
  final VoidCallback? onAppointmentTap;
  final VoidCallback? onDirectionsTap;

  // Location data for displaying the button
  final String? doctorName;
  final String? specialization;
  final String? location;
  final double? latitude;
  final double? longitude;

  const AppointmentWidget({
    required this.date,
    required this.time,
    required this.status,
    this.onAppointmentTap,
    this.onDirectionsTap,
    this.doctorName,
    this.specialization,
    this.location,
    this.latitude,
    this.longitude,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    bool showDirectionsButton =
        latitude != null &&
            longitude != null &&
            latitude! > 0 &&
            longitude! > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onAppointmentTap,
        child: Container(
          width: 420,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: QColors.brand100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Date : $date | $time",
                    style: TAppTextStyle.inter(
                      color: isDark ? QColors.lightBackground : Colors.black,
                      fontSize: 20,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      "Status : ",
                      style: TAppTextStyle.inter(
                        color: isDark ? QColors.lightBackground : Colors.black,
                        fontSize: 20,
                        weight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _appointmentStatus(status),
                      style: TAppTextStyle.inter(
                        color: _getStatusColor(status, isDark),
                        fontSize: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Show directions button only when coordinates are valid
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(Status status, bool isDark) {
    switch (status) {
      case Status.accepted:
        return Colors.green;
      case Status.complete:
        return Colors.blue;
      case Status.rejected:
        return Colors.red;
      case Status.noShow:
        return Colors.orange;
      case Status.pending:
        return Colors.amber;
    }
  }
}

String _appointmentStatus(Status status) {
  switch (status) {
    case Status.accepted:
      return "✅ Accepted";
    case Status.rejected:
      return "❌ Rejected";
    case Status.complete:
      return "✅ Completed";
    case Status.noShow:
      return "🚫 No Show";
    case Status.pending:
      return "⏳ Pending";
  }
}

enum Status {
  accepted,    // Appointment confirmed by doctor
  rejected,    // Appointment declined by doctor
  complete,    // Appointment finished
  noShow,      // Patient didn't show up
  pending      // Waiting for doctor confirmation
}