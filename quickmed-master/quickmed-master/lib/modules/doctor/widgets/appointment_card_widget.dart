import 'package:flutter/material.dart';

class AppointmentCardWidget extends StatelessWidget {
  final String patientName;
  final String day;
  final String date;
  final String time;
  final String status;

  const AppointmentCardWidget({
    super.key,
    required this.patientName,
    required this.day,
    required this.date,
    required this.time,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.red;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row → Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patientName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Day
          Text(
            day,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Date + Time
          Text(
            "$date | Time : $time",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}