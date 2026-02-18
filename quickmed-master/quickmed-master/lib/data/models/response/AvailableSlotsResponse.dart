// lib/features/doctors/data/models/response/AvailableSlotsResponse.dart

class AvailableSlotsResponse {
  final String doctorId;
  final String doctorName;
  final String date;
  final int durationMinutes;
  final List<TimeSlot> slots;
  final int totalSlots;
  final int availableCount;

  AvailableSlotsResponse({
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.durationMinutes,
    required this.slots,
    required this.totalSlots,
    required this.availableCount,
  });

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsResponse(
      doctorId: json['doctor_id']?.toString() ?? '',
      doctorName: json['doctor_name'] ?? '',
      date: json['date'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 30,
      slots: json['slots'] != null
          ? (json['slots'] as List)
          .map((e) => TimeSlot.fromJson(e))
          .toList()
          : [],
      totalSlots: json['total_slots'] ?? 0,
      availableCount: json['available_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'date': date,
      'duration_minutes': durationMinutes,
      'slots': slots.map((e) => e.toJson()).toList(),
      'total_slots': totalSlots,
      'available_count': availableCount,
    };
  }
}

class TimeSlot {
  final String time;
  final String displayTime;
  final bool isAvailable;

  TimeSlot({
    required this.time,
    required this.displayTime,
    required this.isAvailable,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      time: json['time'] ?? '',
      displayTime: json['display_time'] ?? '',
      isAvailable: json['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'display_time': displayTime,
      'is_available': isAvailable,
    };
  }
}