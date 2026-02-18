class BookingResponse {
  final int id;
  final String patientName;
  final String doctorName;
  final double patientLatitude;
  final double patientLongitude;
  final double doctorLatitude;
  final double doctorLongitude;
  final String medicalHistory;
  final String currentSymptoms;
  final String date;
  final String time;
  final String status;
  final String createdAt;

  BookingResponse({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.patientLatitude,
    required this.patientLongitude,
    required this.doctorLatitude,
    required this.doctorLongitude,
    required this.medicalHistory,
    required this.currentSymptoms,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] ?? 0,
      patientName: json['patient_name']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? '',
      patientLatitude: (json['patient_latitude'] != null)
          ? double.tryParse(json['patient_latitude'].toString()) ?? 0.0
          : 0.0,
      patientLongitude: (json['patient_longitude'] != null)
          ? double.tryParse(json['patient_longitude'].toString()) ?? 0.0
          : 0.0,
      doctorLatitude: (json['doctor_latitude'] != null)
          ? double.tryParse(json['doctor_latitude'].toString()) ?? 0.0
          : 0.0,
      doctorLongitude: (json['doctor_longitude'] != null)
          ? double.tryParse(json['doctor_longitude'].toString()) ?? 0.0
          : 0.0,
      medicalHistory: json['medical_history']?.toString() ?? '',
      currentSymptoms: json['current_symptoms']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'patient_latitude': patientLatitude,
      'patient_longitude': patientLongitude,
      'doctor_latitude': doctorLatitude,
      'doctor_longitude': doctorLongitude,
      'medical_history': medicalHistory,
      'current_symptoms': currentSymptoms,
      'date': date,
      'time': time,
      'status': status,
      'created_at': createdAt,
    };
  }
}
