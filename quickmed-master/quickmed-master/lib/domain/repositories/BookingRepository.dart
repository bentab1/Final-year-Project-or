// lib/features/booking/domain/repositories/booking_repository.dart
import '../../data/models/request/BookingRequest.dart';
import '../../data/models/response/BookingResponse.dart';

abstract class BookingRepository {
  Future<BookingResponse> createBooking(BookingRequest request);
  Future<List<BookingResponse>> getBookings();
  Future<List<BookingResponse>> getPatientBookings(); // ✅ NEW
  Future<BookingResponse> getBookingById(int id);
  Future<List<BookingResponse>> getDoctorBookings();
  Future<BookingResponse> updateBookingStatus(int id, String status);
  Future<void> deleteBooking(int id); // ✅ Already added
}