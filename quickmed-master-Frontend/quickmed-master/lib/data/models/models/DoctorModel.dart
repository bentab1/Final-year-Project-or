// // lib/features/doctors/data/models/response/doctor_model.dart
//
// class DoctorModel {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String city;
//   final String state;
//   final String country;
//   final String specialization;
//   final String specializationIllnessSymptoms;
//   final int matchScore;
//   final String imageUrl; // ✅ NEW
//
//   DoctorModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.specialization,
//     required this.specializationIllnessSymptoms,
//     required this.matchScore,
//     required this.imageUrl, // ✅ NEW
//   });
//
//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     return DoctorModel(
//       id: json['id'] as int,
//       firstName: json['first_name'] as String? ?? '',
//       lastName: json['last_name'] as String? ?? '',
//       email: json['email'] as String? ?? '',
//       city: json['city'] as String? ?? '',
//       state: json['state'] as String? ?? '',
//       country: json['country'] as String? ?? '',
//       specialization: json['specialization'] as String? ?? '',
//       specializationIllnessSymptoms:
//       json['specialization_illnes_symptoms'] as String? ?? '',
//       matchScore: json['match_score'] as int? ?? 0,
//       imageUrl: json['image_url'] as String? ?? '', // ✅ NEW
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'city': city,
//       'state': state,
//       'country': country,
//       'specialization': specialization,
//       'specialization_illnes_symptoms': specializationIllnessSymptoms,
//       'match_score': matchScore,
//       'image_url': imageUrl, // ✅ NEW
//     };
//   }
//
//   // Helper getter for full name
//   String get fullName => '$firstName $lastName';
//
//   // Helper getter for location
//   String get location => '$city, $state, $country';
//
//   // Helper getter for symptoms as list
//   List<String> get symptomsList =>
//       specializationIllnessSymptoms.split(',').map((s) => s.trim()).toList();
//
//   // Optional helper: fallback avatar
//   String get avatar =>
//       imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150';
//
//   @override
//   String toString() {
//     return 'DoctorModel(id: $id, name: $fullName, specialization: $specialization, matchScore: $matchScore)';
//   }
//
//
// }



class DoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String state;
  final String country;
  final String specialization;
  final String specializationIllnessSymptoms;
  final int matchScore;
  final String imageUrl;
  final double? latitude;
  final double? longitude;

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.state,
    required this.country,
    required this.specialization,
    required this.specializationIllnessSymptoms,
    required this.matchScore,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      specialization: json['specialization'] ?? '',
      specializationIllnessSymptoms:
      json['specialization_illnes_symptoms'] ?? '',
      matchScore: json['match_score'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'city': city,
      'state': state,
      'country': country,
      'specialization': specialization,
      'specialization_illnes_symptoms': specializationIllnessSymptoms,
      'match_score': matchScore,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullName => '$firstName $lastName';

  String get location => '$city, $state, $country';

  List<String> get symptomsList =>
      specializationIllnessSymptoms.split(',').map((s) => s.trim()).toList();

  String get avatar =>
      imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150';
}
