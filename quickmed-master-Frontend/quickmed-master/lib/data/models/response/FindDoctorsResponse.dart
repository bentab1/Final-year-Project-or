
import '../models/DoctorModel.dart';

class FindDoctorsResponse {
  final int count;
  final String symptomsSearched;
  final List<DoctorModel> doctors;

  FindDoctorsResponse({
    required this.count,
    required this.symptomsSearched,
    required this.doctors,
  });

  factory FindDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return FindDoctorsResponse(
      count: json['count'] as int? ?? 0,
      symptomsSearched: json['symptoms_searched'] as String? ?? '',
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((doctorJson) => DoctorModel.fromJson(doctorJson as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'symptoms_searched': symptomsSearched,
      'doctors': doctors.map((doctor) => doctor.toJson()).toList(),
    };
  }

  // Helper getter to check if doctors were found
  bool get hasDoctors => doctors.isNotEmpty;

  // Helper getter to get doctors sorted by match score
  List<DoctorModel> get doctorsSortedByScore {
    final sortedList = List<DoctorModel>.from(doctors);
    sortedList.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return sortedList;
  }

  @override
  String toString() {
    return 'FindDoctorsResponse(count: $count, symptomsSearched: $symptomsSearched, doctors: ${doctors.length})';
  }
}