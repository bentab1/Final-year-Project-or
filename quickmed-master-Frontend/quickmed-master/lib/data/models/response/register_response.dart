/// Register Response Model
class RegisterResponse {
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String userType;
  final String dob;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? healthIssues; // Optional

  RegisterResponse({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.dob,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.healthIssues,
  });

  /// Create from JSON response
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      userType: json['user_type'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      healthIssues: json['healthIssues'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
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
      if (healthIssues != null) 'healthIssues': healthIssues,
    };
  }

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Check if user is a patient
  bool get isPatient => userType.toLowerCase() == 'patient';

  /// Check if user is a doctor
  bool get isDoctor => userType.toLowerCase() == 'doctor';

  @override
  String toString() {
    return 'RegisterResponse(email: $email, username: $username, fullName: $fullName, userType: $userType)';
  }
}