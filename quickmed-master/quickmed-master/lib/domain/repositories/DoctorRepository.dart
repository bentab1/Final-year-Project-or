// lib/features/doctors/domain/repositories/doctor_repository.dart

import '../../data/models/request/FindDoctorsRequest.dart';
import '../../data/models/request/GetAvailableSlotsRequest.dart';
import '../../data/models/request/UpdateWorkingHoursRequest.dart';
import '../../data/models/request/UpdateWorkingHoursRequest12.dart';
import '../../data/models/response/AvailableSlotsResponse.dart';
import '../../data/models/response/FindDoctorsResponse.dart';
import '../../data/models/response/UpdateWorkingHoursResponse.dart';

abstract class DoctorRepository {
  /// Find doctors based on symptoms
  /// Returns [FindDoctorsResponse] on success
  /// Throws [Exception] on failure
  Future<FindDoctorsResponse> findDoctors(FindDoctorsRequest request);

  // Future<UpdateWorkingHoursResponse> updateWorkingHours(
  //     UpdateWorkingHoursRequest request);

  /// Get available time slots for a doctor
  Future<AvailableSlotsResponse> getAvailableSlots(
      GetAvailableSlotsRequest request);
  Future<UserProfileResponse> updateDoctorWorkingHours(
      UpdateWorkingHoursRequest12 request,
      );
}