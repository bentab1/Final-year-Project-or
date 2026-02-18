// lib/features/booking/data/repositories/booking_repo_impl.dart
import 'package:flutter/foundation.dart';
import '../../domain/repositories/BookingRepository.dart';
import '../dataSource/BookingDataSource.dart';
import '../models/request/BookingRequest.dart';
import '../models/response/BookingResponse.dart';

class BookingRepoImpl implements BookingRepository {
  final BookingDataSource bookingDataSource;

  BookingRepoImpl({required this.bookingDataSource});

  @override
  Future<BookingResponse> createBooking(BookingRequest request) async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] createBooking called with: ${request.toJson()}");
    }

    try {
      final response = await bookingDataSource.createBooking(request);
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Booking created: ${response.toJson()}");
      }
      return response;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in createBooking: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository during booking creation: $error');
    }
  }

  @override
  Future<List<BookingResponse>> getBookings() async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] getBookings called");
    }

    try {
      final bookings = await bookingDataSource.getBookings();
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Fetched ${bookings.length} bookings");
      }
      return bookings;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in getBookings: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while fetching bookings: $error');
    }
  }

  @override
  Future<List<BookingResponse>> getPatientBookings() async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] getPatientBookings called");
    }

    try {
      final bookings = await bookingDataSource.getPatientBookings();
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Fetched ${bookings.length} patient bookings");
      }
      return bookings;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in getPatientBookings: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while fetching patient bookings: $error');
    }
  }
  @override
  Future<List<BookingResponse>> getDoctorBookings() async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] getDoctorBookings called");
    }

    try {
      final response = await bookingDataSource.getDoctorBookings();
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Fetched ${response.length} doctor bookings");
      }
      return response;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in getDoctorBookings: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while fetching doctor bookings: $error');
    }
  }

  @override
  Future<void> deleteBooking(int id) async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] deleteBooking called for ID: $id");
    }

    try {
      await bookingDataSource.deleteBooking(id);
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Booking $id deleted successfully");
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in deleteBooking: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while deleting booking: $error');
    }
  }


  /// Delete booking by ID
  @override
  Future<BookingResponse> getBookingById(int id) async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] getBookingById called with ID: $id");
    }

    try {
      final booking = await bookingDataSource.getBookingById(id);
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Fetched booking: ${booking.toJson()}");
      }
      return booking;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in getBookingById: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while fetching booking: $error');
    }
  }

  @override
  Future<BookingResponse> updateBookingStatus(int id, String status) async {
    if (kDebugMode) {
      print("➡️ [BookingRepoImpl] updateBookingStatus called - ID: $id, Status: $status");
    }

    try {
      final response = await bookingDataSource.updateBookingStatus(id, status);
      if (kDebugMode) {
        print("✅ [BookingRepoImpl] Booking status updated: ${response.toJson()}");
      }
      return response;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("❌ [BookingRepoImpl] Error in updateBookingStatus: $error");
        print(stackTrace);
      }
      throw Exception('Error in repository while updating booking status: $error');
    }
  }
}