class FindDoctorsRequest {
  final String symptoms;
  final String? medicalHistory;

  FindDoctorsRequest({
    required this.symptoms,
    this.medicalHistory,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'symptoms': symptoms,
    };

    // Only include medicalHistory if it's not null
    if (medicalHistory != null) {
      json['medical_history'] = medicalHistory;
    }

    return json;
  }

  @override
  String toString() {
    return 'FindDoctorsRequest(symptoms: $symptoms, medicalHistory: $medicalHistory)';
  }
}