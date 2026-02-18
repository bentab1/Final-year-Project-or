// lib/features/booking/data/models/booking_request.dart
class BookingRequest {
  final int doctorId;
  final String medicalHistory;
  final String currentSymptoms;
  final String date; // "2024-12-15"
  final String time; // "10:30:00"

  BookingRequest({
    required this.doctorId,
    required this.medicalHistory,
    required this.currentSymptoms,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'medical_history': medicalHistory,
      'current_symptoms': currentSymptoms,
      'date': date,
      'time': time,
    };
  }
}