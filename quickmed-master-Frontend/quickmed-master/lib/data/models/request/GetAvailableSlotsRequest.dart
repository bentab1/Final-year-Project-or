// lib/features/doctors/data/models/request/GetAvailableSlotsRequest.dart

class GetAvailableSlotsRequest {
  final String doctorId;
  final String date; // Format: YYYY-MM-DD

  GetAvailableSlotsRequest({
    required this.doctorId,
    required this.date,
  });

  Map<String, String> toQueryParams() {
    return {
      'doctor_id': doctorId,
      'date': date,
    };
  }
}