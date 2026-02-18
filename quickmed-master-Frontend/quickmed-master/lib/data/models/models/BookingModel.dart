// lib/features/doctors/data/models/models/BookingModel.dart

class BookingModel {
  final int id;
  final int doctorId;
  final int patientId;
  final String medicalHistory;
  final String currentSymptoms;
  final String date;
  final String time;
  final String status; // pending, approved, rejected, completed
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optional nested objects if API returns them
  final DoctorInfo? doctor;
  final PatientInfo? patient;

  BookingModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.medicalHistory,
    required this.currentSymptoms,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.doctor,
    this.patient,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      doctorId: json['doctorId'] as int,
      patientId: json['patientId'] as int,
      medicalHistory: json['medical_history'] as String,
      currentSymptoms: json['current_symptoms'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      doctor: json['doctor'] != null
          ? DoctorInfo.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      patient: json['patient'] != null
          ? PatientInfo.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'medical_history': medicalHistory,
      'current_symptoms': currentSymptoms,
      'date': date,
      'time': time,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (doctor != null) 'doctor': doctor!.toJson(),
      if (patient != null) 'patient': patient!.toJson(),
    };
  }

  BookingModel copyWith({
    int? id,
    int? doctorId,
    int? patientId,
    String? medicalHistory,
    String? currentSymptoms,
    String? date,
    String? time,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DoctorInfo? doctor,
    PatientInfo? patient,
  }) {
    return BookingModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      currentSymptoms: currentSymptoms ?? this.currentSymptoms,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
    );
  }
}

// Nested models for doctor/patient info if returned by API
class DoctorInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String? specialization;
  final String email;

  DoctorInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.specialization,
    required this.email,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      specialization: json['specialization'] as String?,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'specialization': specialization,
      'email': email,
    };
  }
}

class PatientInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;
  final String? dob;

  PatientInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.dob,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'dob': dob,
    };
  }
}