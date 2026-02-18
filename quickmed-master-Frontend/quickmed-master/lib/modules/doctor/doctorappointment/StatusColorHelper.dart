import 'package:flutter/material.dart';

class StatusColorHelper {
  // Private constructor to prevent instantiation
  StatusColorHelper._();

  // Static method to get color based on status
  static Color getStatusColor(String status) {
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
}
