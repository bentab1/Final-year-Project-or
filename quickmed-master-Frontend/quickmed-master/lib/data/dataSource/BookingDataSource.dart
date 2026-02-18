import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../core/endpoint/api_endpoints.dart';
import '../models/request/BookingRequest.dart';
import '../models/response/BookingResponse.dart';

class BookingDataSource {
  final ApiClient apiClient;

  BookingDataSource({required this.apiClient});

  /// Create a new booking
  /// Throws [Exception] on failure
  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      if (kDebugMode) {
        print('📝 Creating booking for doctor: ${request.doctorId}');
        print('📦 Request data: ${request.toJson()}');
      }

      final response = await apiClient.post(
        endpoint: ApiEndpoints.bookings,
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Booking created successfully');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        return BookingResponse.fromJson(response.data);
      }

      // ERROR CASE
      return _extractErrorAndThrow(response.data, response.statusCode);

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during booking creation: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during booking: $e');
      throw Exception('Booking failed: $e');
    }
  }

  /// Get all bookings
  Future<List<BookingResponse>> getBookings() async {
    try {
      if (kDebugMode) print('📋 Fetching all bookings');

      final response = await apiClient.get(
        ApiEndpoints.bookings,
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception("Invalid response format - expected list");
        }

        final bookings = (response.data as List)
            .map((json) => BookingResponse.fromJson(json as Map<String, dynamic>))
            .toList();

        if (kDebugMode) print('✅ Fetched ${bookings.length} bookings');
        return bookings;
      }

      throw Exception('Failed to fetch bookings: ${response.statusCode}');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during fetching bookings: ${e.message}');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  /// Get booking by ID
  Future<BookingResponse> getBookingById(int id) async {
    try {
      if (kDebugMode) print('🔍 Fetching booking with ID: $id');

      final response = await apiClient.get(
        ApiEndpoints.bookingById(id),
      );

      if (response.statusCode == 200) {
        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format");
        }

        return BookingResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch booking: ${response.statusCode}');

    } on DioException catch (e) {
      if (kDebugMode) print('❌ DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Get patient bookings
  Future<List<BookingResponse>> getPatientBookings() async {
    try {
      if (kDebugMode) print('👤 Fetching patient bookings');

      final response = await apiClient.get(
        ApiEndpoints.patientBookings,
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception("Invalid response format - expected list");
        }

        final bookings = (response.data as List)
            .map((json) => BookingResponse.fromJson(json as Map<String, dynamic>))
            .toList();

        if (kDebugMode) print('✅ Fetched ${bookings.length} patient bookings');
        return bookings;
      }

      throw Exception('Failed to fetch patient bookings: ${response.statusCode}');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during fetching patient bookings: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      throw Exception('Failed to fetch patient bookings: $e');
    }
  }

  /// Get doctor bookings
  Future<List<BookingResponse>> getDoctorBookings() async {
    try {
      if (kDebugMode) print('👨‍⚕️ Fetching doctor bookings');

      final response = await apiClient.get(
        ApiEndpoints.doctorBookings,
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        if (response.data is! List) {
          throw Exception("Invalid response format - expected list");
        }

        final bookings = (response.data as List)
            .map((json) => BookingResponse.fromJson(json as Map<String, dynamic>))
            .toList();

        if (kDebugMode) print('✅ Fetched ${bookings.length} doctor bookings');
        return bookings;
      }

      throw Exception('Failed to fetch doctor bookings: ${response.statusCode}');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during fetching doctor bookings: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      throw Exception('Failed to fetch doctor bookings: $e');
    }
  }

  /// Update booking status
  /// [id] - Booking ID
  /// [status] - New status (e.g., "approved", "rejected", "completed", "cancelled")
  Future<BookingResponse> updateBookingStatus(int id, String status) async {
    try {
      if (kDebugMode) {
        print('🔄 Updating booking $id status to: $status');
      }

      final response = await apiClient.patch(
        ApiEndpoints.updateBookingStatus(id),
        data: {'status': status},
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
        print('📥 Response data type: ${response.data.runtimeType}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Booking status updated successfully');

        // Handle different response formats
        dynamic responseData = response.data;

        // If response is a Map but doesn't have all booking fields,
        // it might just be a success message
        if (responseData is Map<String, dynamic>) {
          // Check if it's a full booking object or just a status update confirmation
          if (responseData.containsKey('id') ||
              responseData.containsKey('patient_name') ||
              responseData.containsKey('doctor_name')) {
            // It's a full booking response
            try {
              return BookingResponse.fromJson(responseData);
            } catch (e) {
              if (kDebugMode) {
                print('⚠️ Error parsing response, fetching updated booking: $e');
              }
              // If parsing fails, fetch the updated booking by ID
              return await getBookingById(id);
            }
          } else {
            // It's just a confirmation message, fetch the updated booking
            if (kDebugMode) {
              print('⚠️ Response is confirmation only, fetching updated booking');
            }
            return await getBookingById(id);
          }
        } else {
          // Unexpected response format, fetch the booking
          if (kDebugMode) {
            print('⚠️ Unexpected response format, fetching updated booking');
          }
          return await getBookingById(id);
        }
      }

      // ERROR CASE
      return _extractErrorAndThrow(response.data, response.statusCode);

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during status update: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during status update: $e');
      throw Exception('Status update failed: $e');
    }
  }


  /// Delete booking by ID
  /// Delete booking by ID
  Future<void> deleteBooking(int id) async {
    try {
      if (kDebugMode) print('🗑️ Deleting booking with ID: $id');

      final response = await apiClient.delete(
        endpoint: '${ApiEndpoints.deleteBooking(id)}/', // Ensure trailing slash
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // Django DELETE typically returns 204 No Content on success
      if (response.statusCode == 204 ||
          response.statusCode == 200 ||
          response.statusCode == 202) {
        if (kDebugMode) print('✅ Booking deleted successfully');
        return;
      }

      _extractErrorAndThrow(response.data, response.statusCode);

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during booking deletion: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during deletion: $e');
      throw Exception('Failed to delete booking: $e');
    }
  }  /// Delete booking by ID
  // Helper method to extract error messages
  Never _extractErrorAndThrow(dynamic data, int? statusCode) {
    if (kDebugMode) {
      print('❌ Error response (status $statusCode): $data');
    }

    String errorMessage = 'Booking failed';

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