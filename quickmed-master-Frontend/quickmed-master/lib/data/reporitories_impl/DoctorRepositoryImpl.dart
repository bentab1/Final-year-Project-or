// lib/features/doctors/data/repositories/doctor_repository_impl.dart

import 'package:flutter/foundation.dart';
import '../../domain/repositories/DoctorRepository.dart';
import '../dataSource/DoctorDataSource.dart';
import '../models/request/FindDoctorsRequest.dart';
import '../models/request/GetAvailableSlotsRequest.dart';
import '../models/request/UpdateWorkingHoursRequest.dart';
import '../models/request/UpdateWorkingHoursRequest12.dart';
import '../models/response/AvailableSlotsResponse.dart';
import '../models/response/FindDoctorsResponse.dart';
import '../models/response/UpdateWorkingHoursResponse.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorDataSource doctorDataSource;

  DoctorRepositoryImpl({required this.doctorDataSource});

  @override
  Future<FindDoctorsResponse> findDoctors(FindDoctorsRequest request) async {
    if (kDebugMode) {
      print("➡️ [DoctorRepoImpl] findDoctors called with: ${request.toJson()}");
    }

    try {
      final response = await doctorDataSource.findDoctors(request);

      if (kDebugMode) {
        print("✅ [DoctorRepoImpl] Find doctors success: ${response
            .count} doctors found");
      }

      return response;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [DoctorRepoImpl] Error in findDoctors: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository during doctor search: $error');
    }
  }


  // @override
  // Future<UpdateWorkingHoursResponse> updateWorkingHours(
  //     UpdateWorkingHoursRequest request) async {
  //   print("➡️ [DoctorRepoImpl] updateWorkingHours called with: ${request
  //       .toJson()}");
  //
  //   try {
  //     final response = await doctorDataSource.updateWorkingHours(request);
  //     print("✅ [DoctorRepoImpl] Working hours updated successfully: ${response
  //         .toJson()}");
  //     return response;
  //   } catch (error, stackTrace) {
  //     print("❌ [DoctorRepoImpl] Error in updateWorkingHours: $error");
  //     print(stackTrace);
  //     throw Exception(
  //         'Error in repository during working hours update: $error');
  //   }
  // }

  @override
  Future<AvailableSlotsResponse> getAvailableSlots(
      GetAvailableSlotsRequest request) async {
    print(
        "➡️ [DoctorRepoImpl] getAvailableSlots called with: Doctor ID: ${request
            .doctorId}, Date: ${request.date}");

    try {
      final response = await doctorDataSource.getAvailableSlots(request);
      print("✅ [DoctorRepoImpl] Available slots fetched successfully: ${response
          .availableCount}/${response.totalSlots} slots available");
      return response;
    } catch (error, stackTrace) {
      print("❌ [DoctorRepoImpl] Error in getAvailableSlots: $error");
      print(stackTrace);
      throw Exception(
          'Error in repository during fetching available slots: $error');
    }
  }


  @override
  Future<UserProfileResponse> updateDoctorWorkingHours(
      UpdateWorkingHoursRequest12 request,
      ) async {
    if (kDebugMode) {
      print("➡️ [DoctorRepoImpl] updateDoctorWorkingHours called with: ${request.toJson()}");
    }

    try {
      final response = await doctorDataSource.updateDoctorWorkingHours(request);

      if (kDebugMode) {
        print("✅ [DoctorRepoImpl] Working hours updated successfully");
        print("✅ [DoctorRepoImpl] Doctor: ${response.firstName} ${response.lastName}");
        print("✅ [DoctorRepoImpl] Total working hours: ${response.doctorProfile?.workingHours?.length ?? 0}");
      }

      return response;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [DoctorRepoImpl] Error in updateDoctorWorkingHours: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository during working hours update: $error');
    }
  }
}