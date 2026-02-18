// class UserData {
// final String id;
// final String userType;
// final String firstName;
// final String lastName;
// final String username;
// final String email;
// final String? dob;
// final String? gender;
// final String? address;
// final String? city;
// final String? state;
// final String? zipCode;
// final String? country;
// final String? healthIssues; // For patients
// final String? specialization; // For doctors
// final String? specializationIllnessSymptoms; // For doctors
//
// UserData({
//   required this.id,
//   required this.userType,
//   required this.firstName,
//   required this.lastName,
//   required this.username,
//   required this.email,
//   this.dob,
//   this.gender,
//   this.address,
//   this.city,
//   this.state,
//   this.zipCode,
//   this.country,
//   this.healthIssues,
//   this.specialization,
//   this.specializationIllnessSymptoms,
// });
//
// /// Create from JSON
// factory UserData.fromJson(Map<String, dynamic> json) {
// return UserData(
// id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
// userType: json['user_type'] ?? '',
// firstName: json['first_name'] ?? '',
// lastName: json['last_name'] ?? '',
// username: json['username'] ?? '',
// email: json['email'] ?? '',
// dob: json['dob'],
// gender: json['gender'],
// address: json['address'],
// city: json['city'],
// state: json['state'],
// zipCode: json['zipCode'],
// country: json['country'],
// healthIssues: json['healthIssues'],
// specialization: json['specilization'], // Note: API spelling
// specializationIllnessSymptoms: json['specilization_illnes_symptoms'],
// );
// }
//
// /// Convert to JSON
// Map<String, dynamic> toJson() {
// return {
// 'id': id,
// 'user_type': userType,
// 'first_name': firstName,
// 'last_name': lastName,
// 'username': username,
// 'email': email,
// 'dob': dob,
// 'gender': gender,
// 'address': address,
// 'city': city,
// 'state': state,
// 'zipCode': zipCode,
// 'country': country,
// 'healthIssues': healthIssues,
// 'specilization': specialization,
// 'specilization_illnes_symptoms': specializationIllnessSymptoms,
// };
// }
//
// /// Get full name
// String get fullName => '$firstName $lastName';
//
// /// Check if user is a doctor
// bool get isDoctor => userType.toLowerCase() == 'doctor';
//
// /// Check if user is a patient
// bool get isPatient => userType.toLowerCase() == 'patient';
//
// @override
// String toString() {
// return 'UserData(id: $id, name: $fullName, email: $email, userType: $userType)';
// }
// }



class UserData {
  final int id;
  final String userType;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? dob;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? healthIssues; // For patients - extracted from patient_profile
  final String? specialization; // For doctors - extracted from doctor_profile
  final String? specializationIllnessSymptoms; // For doctors - extracted from doctor_profile

  UserData({
    required this.id,
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.dob,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.healthIssues,
    this.specialization,
    this.specializationIllnessSymptoms,
  });

  /// Create from JSON - Handles both nested profile structure and flat structure
  factory UserData.fromJson(Map<String, dynamic> json) {
    // Extract patient health issues from nested patient_profile
    String? healthIssues;
    if (json['patient_profile'] != null && json['patient_profile'] is Map) {
      healthIssues = json['patient_profile']['healthIssues'];
    }

    // Extract doctor info from nested doctor_profile
    String? specialization;
    String? specializationIllnessSymptoms;
    if (json['doctor_profile'] != null && json['doctor_profile'] is Map) {
      specialization = json['doctor_profile']['specialization'];
      specializationIllnessSymptoms = json['doctor_profile']['specialization_illnes_symptoms'];
    }

    return UserData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userType: json['user_type'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      healthIssues: healthIssues,
      specialization: specialization,
      specializationIllnessSymptoms: specializationIllnessSymptoms,
    );
  }

  /// Convert to JSON - Creates nested structure for API compatibility
  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'dob': dob,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };

    // Add nested patient_profile if user is a patient
    if (isPatient) {
      json['patient_profile'] = {
        'healthIssues': healthIssues,
      };
      json['doctor_profile'] = null;
    }

    // Add nested doctor_profile if user is a doctor
    if (isDoctor) {
      json['doctor_profile'] = {
        'specialization': specialization,
        'specialization_illnes_symptoms': specializationIllnessSymptoms,
      };
      json['patient_profile'] = null;
    }

    return json;
  }

  /// Get full name
  String get fullName {
    final first = firstName.trim();
    final last = lastName.trim();

    if (first.isEmpty && last.isEmpty) {
      return username;
    }

    return '$first $last'.trim();
  }

  /// Check if user is a doctor
  bool get isDoctor => userType.toLowerCase() == 'doctor';

  /// Check if user is a patient
  bool get isPatient => userType.toLowerCase() == 'patient';

  /// Check if profile is complete
  bool get isProfileComplete {
    final basicInfoComplete = firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        dob != null &&
        gender != null &&
        address != null &&
        city != null &&
        state != null &&
        zipCode != null &&
        country != null;

    if (isDoctor) {
      return basicInfoComplete &&
          specialization != null &&
          specialization!.isNotEmpty;
    } else if (isPatient) {
      return basicInfoComplete;
    }

    return basicInfoComplete;
  }

  /// Get display name (first name or username if first name is empty)
  String get displayName {
    if (firstName.isNotEmpty) {
      return firstName;
    }
    return username;
  }

  /// Copy with method for easy updates
  UserData copyWith({
    int? id,
    String? userType,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? dob,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? healthIssues,
    String? specialization,
    String? specializationIllnessSymptoms,
  }) {
    return UserData(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      healthIssues: healthIssues ?? this.healthIssues,
      specialization: specialization ?? this.specialization,
      specializationIllnessSymptoms: specializationIllnessSymptoms ?? this.specializationIllnessSymptoms,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $fullName, email: $email, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}