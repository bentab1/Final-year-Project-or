// lib/features/doctors/data/datasources/doctor_data_source.dart

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../core/endpoint/api_endpoints.dart';
import '../models/models/DoctorModel.dart';
import '../models/request/FindDoctorsRequest.dart';
import '../models/request/GetAvailableSlotsRequest.dart';
import '../models/request/UpdateWorkingHoursRequest.dart';
import '../models/request/UpdateWorkingHoursRequest12.dart';
import '../models/response/AvailableSlotsResponse.dart';
import '../models/response/BookingsResponse.dart';
import '../models/response/FindDoctorsResponse.dart';
import '../models/response/UpdateWorkingHoursResponse.dart';

class DoctorDataSource {
  final ApiClient apiClient;

  DoctorDataSource({required this.apiClient});

  /// Find doctors based on symptoms
  /// Throws [Exception] on failure
  Future<FindDoctorsResponse> findDoctors(FindDoctorsRequest request) async {
    try {
      if (kDebugMode) {
        print('🔍 Searching doctors for symptoms: ${request.symptoms}');
        print('📦 Request data: ${request.toJson()}');
      }

      final response = await apiClient.post(
        endpoint: ApiEndpoints.findDoctors,
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Doctors found successfully');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        final doctorsResponse = FindDoctorsResponse.fromJson(response.data);

        if (kDebugMode) {
          print('✅ Found ${doctorsResponse.count} doctors matching symptoms');
        }

        return doctorsResponse;
      }

      // ERROR CASE
      return _extractErrorAndThrow(response.data, response.statusCode);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during doctor search: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during doctor search: $e');
      throw Exception('Doctor search failed: $e');
    }
  }

  Future<BookingsResponse> getDoctorBookings() async {
    try {
      if (kDebugMode) {
        print('🔍 Fetching bookings for logged-in doctor');
      }

      final response = await apiClient.get(
        ApiEndpoints.doctorBookings,
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200) {
        if (kDebugMode) print('✅ Doctor bookings fetched successfully');

        final data = response.data;
        if (data == null || data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        final bookingsResponse = BookingsResponse.fromJson(data);

        if (kDebugMode) {
          print('✅ Found ${bookingsResponse.count} bookings for doctor');
        }

        return bookingsResponse;
      }

      // ERROR CASE
      _extractErrorAndThrow(response.data, response.statusCode);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during fetching doctor bookings: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected error during fetching doctor bookings: $e');
      }
      throw Exception('Failed to fetch doctor bookings: $e');
    }
  }

  // Future<UpdateWorkingHoursResponse> updateWorkingHours(
  //     UpdateWorkingHoursRequest request) async {
  //   try {
  //     if (kDebugMode) {
  //       print('🕐 Updating working hours');
  //       print('📦 Request data: ${request.toJson()}');
  //     }
  //
  //     final response = await apiClient.put(
  //       endpoint: ApiEndpoints.updateProfile,
  //       data: request.toJson(),
  //     );
  //
  //     if (kDebugMode) {
  //       print('📥 Response status: ${response.statusCode}');
  //       print('📥 Response data: ${response.data}');
  //     }
  //
  //     // SUCCESS CASE
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       if (kDebugMode) print('✅ Working hours updated successfully');
  //
  //       if (response.data is! Map<String, dynamic>) {
  //         throw Exception("Invalid response format from server");
  //       }
  //
  //       final workingHoursResponse =
  //       UpdateWorkingHoursResponse.fromJson(response.data);
  //
  //       if (kDebugMode) {
  //         print('✅ Profile updated with new working hours');
  //       }
  //
  //       return workingHoursResponse;
  //     }
  //
  //     // ERROR CASE
  //     return _extractErrorAndThrow(response.data, response.statusCode);
  //   } on DioException catch (e) {
  //     if (kDebugMode) {
  //       print('❌ DioException during working hours update: ${e.message}');
  //       print('❌ Response status: ${e.response?.statusCode}');
  //       print('❌ Response data: ${e.response?.data}');
  //     }
  //
  //     if (e.response?.data != null) {
  //       return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
  //     }
  //
  //     throw Exception('Network error: ${e.message}');
  //   } catch (e) {
  //     if (kDebugMode)
  //       print('❌ Unexpected error during working hours update: $e');
  //     throw Exception('Working hours update failed: $e');
  //   }
  // }

  /// Get available time slots for a doctor on a specific date
  /// Throws [Exception] on failure
  Future<AvailableSlotsResponse> getAvailableSlots(
      GetAvailableSlotsRequest request) async {
    try {
      if (kDebugMode) {
        print(
            '🕐 Fetching available slots for doctor ${request
                .doctorId} on ${request.date}');
        print('📦 Query params: ${request.toQueryParams()}');
      }

      final response = await apiClient.get(
        ApiEndpoints.availableSlots,
        queryParameters: request.toQueryParams(),
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200) {
        if (kDebugMode) print('✅ Available slots fetched successfully');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        final slotsResponse = AvailableSlotsResponse.fromJson(response.data);

        if (kDebugMode) {
          print(
              '✅ Found ${slotsResponse
                  .availableCount} available slots out of ${slotsResponse
                  .totalSlots}');
        }

        return slotsResponse;
      }

      // ERROR CASE
      return _extractErrorAndThrow(response.data, response.statusCode);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during fetching available slots: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode)
        print('❌ Unexpected error during fetching available slots: $e');
      throw Exception('Failed to fetch available slots: $e');
    }
  }

  /// Update doctor working hours
  Future<UserProfileResponse> updateDoctorWorkingHours(
      UpdateWorkingHoursRequest12 request,
      ) async {
    try {
      if (kDebugMode) {
        print('⏰ Updating doctor working hours');
        print('📦 Request data: ${request.toJson()}');
      }

      final response = await apiClient.put(endpoint:         ApiEndpoints.profile,
        data: request.toJson(),

      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Working hours updated successfully');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        return UserProfileResponse.fromJson(response.data);
      }

      // ERROR CASE
      return _extractErrorAndThrow(response.data, response.statusCode);

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during working hours update: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during working hours update: $e');
      throw Exception('Working hours update failed: $e');
    }
  }

  // Helper method to extract error messages
  Never _extractErrorAndThrow(dynamic data, int? statusCode) {
    if (kDebugMode) {
      print('❌ Error response (status $statusCode): $data');
    }

    String errorMessage = 'Doctor search failed';

    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ??
          data['error'] ??
          data['detail'] ??
          errorMessage;
    } else if (data is String) {
      errorMessage = data;
    }

    throw Exception(errorMessage);
  }
}