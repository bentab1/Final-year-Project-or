// lib/features/doctors/data/models/response/UpdateWorkingHoursResponse.dart

import '../request/UpdateWorkingHoursRequest.dart';

class UpdateWorkingHoursResponse {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String userType;
  final String? dob;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DoctorProfile? doctorProfile;

  UpdateWorkingHoursResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.dob,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.doctorProfile,
  });

  factory UpdateWorkingHoursResponse.fromJson(Map<String, dynamic> json) {
    return UpdateWorkingHoursResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      userType: json['user_type'] ?? '',
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      doctorProfile: json['doctor_profile'] != null
          ? DoctorProfile.fromJson(json['doctor_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'dob': dob,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'doctor_profile': doctorProfile?.toJson(),
    };
  }
}

class DoctorProfile {
  final String? specialization;
  final String? specializationIllnessSymptoms;
  final String? latitude;
  final String? longitude;
  final List<WorkingHourItem>? workingHours;

  DoctorProfile({
    this.specialization,
    this.specializationIllnessSymptoms,
    this.latitude,
    this.longitude,
    this.workingHours,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      specialization: json['specialization'],
      specializationIllnessSymptoms: json['specialization_illnes_symptoms'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      workingHours: json['working_hours'] != null
          ? (json['working_hours'] as List)
          .map((e) => WorkingHourItem.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialization': specialization,
      'specialization_illnes_symptoms': specializationIllnessSymptoms,
      'latitude': latitude,
      'longitude': longitude,
      'working_hours': workingHours?.map((e) => e.toJson()).toList(),
    };
  }
}