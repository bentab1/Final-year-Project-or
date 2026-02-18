// ============================================
// REQUEST CLASSES
// ============================================

/// models/request/UpdateWorkingHoursRequest.dart
class UpdateWorkingHoursRequest12 {
  final List<WorkingHours> workingHours;

  UpdateWorkingHoursRequest12({
    required this.workingHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'working_hours': workingHours.map((hour) => hour.toJson()).toList(),
    };
  }

  factory UpdateWorkingHoursRequest12.fromJson(Map<String, dynamic> json) {
    return UpdateWorkingHoursRequest12(
      workingHours: (json['working_hours'] as List)
          .map((hour) => WorkingHours.fromJson(hour as Map<String, dynamic>))
          .toList(),
    );
  }
}
class WorkingHours {
  final String date;
  final String? startTime;  // Make nullable
  final String? endTime;    // Make nullable
  final bool isWorking;

  WorkingHours({
    required this.date,
    this.startTime,  // Remove 'required'
    this.endTime,    // Remove 'required'
    required this.isWorking,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      date: json['date'] as String,
      startTime: json['start_time'] as String?,  // Cast to nullable String
      endTime: json['end_time'] as String?,      // Cast to nullable String
      isWorking: json['is_working'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'start_time': startTime,  // Will be null if not set
      'end_time': endTime,      // Will be null if not set
      'is_working': isWorking,
    };
  }
}
// /// models/WorkingHour.dart
// class WorkingHour {
//   final String date;
//   final String startTime;
//   final String endTime;
//   final bool isWorking;
//
//   WorkingHour({
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.isWorking,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'start_time': startTime,
//       'end_time': endTime,
//       'is_working': isWorking,
//     };
//   }
//
//   factory WorkingHour.fromJson(Map<String, dynamic> json) {
//     return WorkingHour(
//       date: json['date'] as String,
//       startTime: json['start_time'] as String,
//       endTime: json['end_time'] as String,
//       isWorking: json['is_working'] as bool,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'WorkingHour(date: $date, startTime: $startTime, endTime: $endTime, isWorking: $isWorking)';
//   }
// }

// ============================================
// RESPONSE CLASSES
// ============================================

/// models/response/UserProfileResponse.dart
class UserProfileResponse {
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
  final PatientProfile? patientProfile;
  final DoctorProfile? doctorProfile;

  UserProfileResponse({
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
    this.patientProfile,
    this.doctorProfile,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      userType: json['user_type'] as String,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      patientProfile: json['patient_profile'] != null
          ? PatientProfile.fromJson(json['patient_profile'] as Map<String, dynamic>)
          : null,
      doctorProfile: json['doctor_profile'] != null
          ? DoctorProfile.fromJson(json['doctor_profile'] as Map<String, dynamic>)
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
      'patient_profile': patientProfile?.toJson(),
      'doctor_profile': doctorProfile?.toJson(),
    };
  }

  @override
  String toString() {
    return 'UserProfileResponse(id: $id, email: $email, username: $username, userType: $userType)';
  }
}

/// models/DoctorProfile.dart
class DoctorProfile {
  final String? specialization;
  final String? specializationIllnessSymptoms;
  final String? latitude;
  final String? longitude;
  final List<WorkingHours>? workingHours;

  DoctorProfile({
    this.specialization,
    this.specializationIllnessSymptoms,
    this.latitude,
    this.longitude,
    this.workingHours,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      specialization: json['specialization'] as String?,
      specializationIllnessSymptoms: json['specialization_illnes_symptoms'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      workingHours: json['working_hours'] != null
          ? (json['working_hours'] as List)
          .map((hour) => WorkingHours.fromJson(hour as Map<String, dynamic>))
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
      'working_hours': workingHours?.map((hour) => hour.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'DoctorProfile(specialization: $specialization, workingHours: ${workingHours?.length ?? 0} entries)';
  }
}

/// models/PatientProfile.dart (placeholder - adjust based on your needs)
class PatientProfile {
  // Add patient-specific fields here
  final String? medicalHistory;
  final String? bloodGroup;

  PatientProfile({
    this.medicalHistory,
    this.bloodGroup,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      medicalHistory: json['medical_history'] as String?,
      bloodGroup: json['blood_group'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medical_history': medicalHistory,
      'blood_group': bloodGroup,
    };
  }

  @override
  String toString() {
    return 'PatientProfile(bloodGroup: $bloodGroup)';
  }
}