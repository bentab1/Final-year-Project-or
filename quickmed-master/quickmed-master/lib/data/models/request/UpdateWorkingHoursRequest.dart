// lib/features/doctors/data/models/request/UpdateWorkingHoursRequest.dart

class UpdateWorkingHoursRequest {
  final List<WorkingHourItem> workingHours;

  UpdateWorkingHoursRequest({required this.workingHours});

  Map<String, dynamic> toJson() {
    return {
      'working_hours': workingHours.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkingHourItem {
  final String day;
  final String? startTime;
  final String? endTime;
  final bool isWorking;

  WorkingHourItem({
    required this.day,
    this.startTime,
    this.endTime,
    required this.isWorking,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'is_working': isWorking,
    };
  }

  factory WorkingHourItem.fromJson(Map<String, dynamic> json) {
    return WorkingHourItem(
      day: json['day'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      isWorking: json['is_working'] ?? false,
    );
  }
}