// class RegisterRequest {
//   final String userType;
//   final String username;
//   final String firstName;
//   final String lastname;
//   final String email;
//   final String password;
//   final String dob;
//   final String gender;
//   final String address;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String country;
//   final String? healthIssues; // Optional, only for patients
//   final String? specialization; // Optional, only for doctors
//   final String? specializationIllnessSymptoms; // Optional, only for doctors
//
//   RegisterRequest(this.firstName, this.lastname, {
//     required this.userType,
//
//     required this.username,
//     required this.email,
//     required this.password,
//     required this.dob,
//     required this.gender,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.country,
//     this.healthIssues,
//     this.specialization,
//     this.specializationIllnessSymptoms,
//   });
//
//   /// Convert to JSON for API request
//   Map<String, dynamic> toJson() {
//     final json = {
//       'user_type': userType,
//
//       'username': username,
//       'email': email,
//       'password': password,
//       'dob': dob,
//       'gender': gender,
//       'address': address,
//       'city': city,
//       'state': state,
//       'zipCode': zipCode,
//       'country': country,
//     };
//
//     // Only include healthIssues if it's not null (for patients)
//     if (healthIssues != null && healthIssues!.isNotEmpty) {
//       json['healthIssues'] = healthIssues!;
//     }
//
//     // Only include specialization fields if not null (for doctors)
//     if (specialization != null && specialization!.isNotEmpty) {
//       json['specilization'] = specialization!; // Note: keeping your API spelling
//     }
//
//     if (specializationIllnessSymptoms != null && specializationIllnessSymptoms!.isNotEmpty) {
//       json['specilization_illnes_symptoms'] = specializationIllnessSymptoms!; // Note: keeping your API spelling
//     }
//
//     return json;
//   }
//
//   /// Create from JSON
//   factory RegisterRequest.fromJson(Map<String, dynamic> json) {
//     return  RegisterRequest(
//       userType: json['user_type'] ?? '',
//       firs
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       password: json['password'] ?? '',
//       dob: json['dob'] ?? '',
//       gender: json['gender'] ?? '',
//       address: json['address'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       zipCode: json['zipCode'] ?? '',
//       country: json['country'] ?? '',
//       healthIssues: json['healthIssues'],
//       specialization: json['specilization'], // Note: API spelling
//       specializationIllnessSymptoms: json['specilization_illnes_symptoms'], // Note: API spelling
//     );
//   }
//
//   /// Copy with method for easy modification
//   RegisterRequest copyWith({
//     String? userType,
//     String? firstName,
//     String? lastName,
//     String? username,
//     String? email,
//     String? password,
//     String? dob,
//     String? gender,
//     String? address,
//     String? city,
//     String? state,
//     String? zipCode,
//     String? country,
//     String? healthIssues,
//     String? specialization,
//     String? specializationIllnessSymptoms,
//   }) {
//     return RegisterRequest(
//       userType: userType ?? this.userType,
//
//       username: username ?? this.username,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       dob: dob ?? this.dob,
//       gender: gender ?? this.gender,
//       address: address ?? this.address,
//       city: city ?? this.city,
//       state: state ?? this.state,
//       zipCode: zipCode ?? this.zipCode,
//       country: country ?? this.country,
//       healthIssues: healthIssues ?? this.healthIssues,
//       specialization: specialization ?? this.specialization,
//       specializationIllnessSymptoms: specializationIllnessSymptoms ?? this.specializationIllnessSymptoms,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'RegisterRequest(userType: $userType,, username: $username, email: $email, specialization: $specialization)';
//   }
// }


class RegisterRequest {
  final String userType;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String dob;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  // Optional (Patient)
  final String? healthIssues;

  // Optional (Doctor)
  final String? specialization;
  final String? specializationIllnessSymptoms;

  RegisterRequest({
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.healthIssues,
    this.specialization,
    this.specializationIllnessSymptoms,
  });

  /// Convert request to JSON matching API structure
  Map<String, dynamic> toJson() {
    final json = {
      "user_type": userType,
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "email": email,
      "password": password,
      "dob": dob,
      "gender": gender,
      "address": address,
      "city": city,
      "state": state,
      "zipCode": zipCode,
      "country": country,
    };

    if (healthIssues != null && healthIssues!.isNotEmpty) {
      json["healthIssues"] = healthIssues!;
    }

    if (specialization != null && specialization!.isNotEmpty) {
      json["specialization"] = specialization!; // spelled this way by API
    }

    if (specializationIllnessSymptoms != null &&
        specializationIllnessSymptoms!.isNotEmpty) {
      json["specialization_illnes_symptoms"] = specializationIllnessSymptoms!;
    }

    return json;
  }

  @override
  String toString() {
    return "RegisterRequest(userType: $userType, email: $email, username: $username)";
  }
}
