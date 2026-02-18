import 'package:flutter/foundation.dart';

import '../../data/models/request/BookingRequest.dart';
import '../../data/models/response/BookingResponse.dart';
import '../../domain/repositories/BookingRepository.dart';


enum BookingStatus {
  initial,
  loading,
  success,
  error,
}

class BookingProvider extends ChangeNotifier {
  final BookingRepository bookingRepository;

  BookingProvider({required this.bookingRepository});

  // State
  BookingStatus _status = BookingStatus.initial;
  String? _errorMessage;
  BookingResponse? _currentBooking;
  List<BookingResponse> _bookings = [];
  List<BookingResponse> _patientBookings = [];
  List<BookingResponse> _doctorBookings = [];

  // Getters
  BookingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  BookingResponse? get currentBooking => _currentBooking;
  List<BookingResponse> get bookings => _bookings;
  List<BookingResponse> get patientBookings => _patientBookings;
  List<BookingResponse> get doctorBookings => _doctorBookings;
  bool get isLoading => _status == BookingStatus.loading;
  bool get hasError => _status == BookingStatus.error;

  // Private setter methods
  void _setLoading() {
    _status = BookingStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = BookingStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = BookingStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Create a new booking
  Future<bool> createBooking(BookingRequest request) async {
    if (kDebugMode) {
      print('📝 [BookingProvider] Creating booking: ${request.toJson()}');
    }

    _setLoading();

    try {
      final response = await bookingRepository.createBooking(request);
      _currentBooking = response;
      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Booking created: ${response.toJson()}');
      }

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error creating booking: $error');
      }
      _setError(error.toString());
      return false;
    }
  }

  /// Fetch all bookings
  Future<void> fetchBookings() async {
    if (kDebugMode) {
      print('📋 [BookingProvider] Fetching all bookings');
    }

    _setLoading();

    try {
      final bookings = await bookingRepository.getBookings();
      _bookings = bookings;
      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Fetched ${bookings.length} bookings');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error fetching bookings: $error');
      }
      _setError(error.toString());
    }
  }

  /// Fetch patient's own bookings
  Future<void> fetchPatientBookings() async {
    if (kDebugMode) {
      print('👤 [BookingProvider] Fetching patient bookings');
    }

    _setLoading();

    try {
      final bookings = await bookingRepository.getPatientBookings();
      _patientBookings = bookings;
      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Fetched ${bookings.length} patient bookings');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error fetching patient bookings: $error');
      }
      _setError(error.toString());
    }
  }

  /// Fetch doctor's bookings
  Future<void> fetchDoctorBookings() async {
    if (kDebugMode) {
      print('👨‍⚕️ [BookingProvider] Fetching doctor bookings');
    }

    _setLoading();

    try {
      final bookings = await bookingRepository.getDoctorBookings();
      _doctorBookings = bookings;
      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Fetched ${bookings.length} doctor bookings');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error fetching doctor bookings: $error');
      }
      _setError(error.toString());
    }
  }

  /// Fetch booking by ID
  Future<void> fetchBookingById(int id) async {
    if (kDebugMode) {
      print('🔍 [BookingProvider] Fetching booking with ID: $id');
    }

    _setLoading();

    try {
      final booking = await bookingRepository.getBookingById(id);
      _currentBooking = booking;
      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Fetched booking: ${booking.toJson()}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error fetching booking: $error');
      }
      _setError(error.toString());
    }
  }

  /// Update booking status
  /// [id] - Booking ID
  /// [status] - New status (approved, rejected, completed, cancelled, etc.)
  /// [refreshList] - Whether to refresh the bookings list after update (default: true)
  Future<bool> updateBookingStatus({
    required int id,
    required String status,
    bool refreshList = true,
  }) async {
    if (kDebugMode) {
      print('🔄 [BookingProvider] Updating booking $id status to: $status');
    }

    _setLoading();

    try {
      final updatedBooking = await bookingRepository.updateBookingStatus(id, status);
      _currentBooking = updatedBooking;

      // Update the booking in the local lists
      _updateBookingInLists(updatedBooking);

      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Booking status updated: ${updatedBooking.toJson()}');
      }

      // Optionally refresh the doctor bookings list
      if (refreshList) {
        await fetchDoctorBookings();
      }

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error updating booking status: $error');
      }
      _setError(error.toString());
      return false;
    }
  }

  /// Delete booking by ID
  Future<bool> deleteBooking({
    required int id,
    bool refreshList = false,
  }) async {
    if (kDebugMode) {
      print('🗑️ [BookingProvider] Deleting booking with ID: $id');
    }

    _setLoading();

    try {
      await bookingRepository.deleteBooking(id);

      // Remove the booking from local lists
      _removeBookingFromLists(id);

      _setSuccess();

      if (kDebugMode) {
        print('✅ [BookingProvider] Booking $id deleted successfully');
      }

      if (refreshList) {
        await fetchPatientBookings();
      }

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('❌ [BookingProvider] Error deleting booking: $error');
      }
      _setError(error.toString());
      return false;
    }
  }

  /// Helper method to remove booking from local lists
  void _removeBookingFromLists(int bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    _patientBookings.removeWhere((b) => b.id == bookingId);
    _doctorBookings.removeWhere((b) => b.id == bookingId);

    if (_currentBooking?.id == bookingId) {
      _currentBooking = null;
    }
  }



  /// Helper method to update booking in local lists
  void _updateBookingInLists(BookingResponse updatedBooking) {
    // Update in all bookings list
    final allIndex = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (allIndex != -1) {
      _bookings[allIndex] = updatedBooking;
    }

    // Update in patient bookings list
    final patientIndex = _patientBookings.indexWhere((b) => b.id == updatedBooking.id);
    if (patientIndex != -1) {
      _patientBookings[patientIndex] = updatedBooking;
    }

    // Update in doctor bookings list
    final doctorIndex = _doctorBookings.indexWhere((b) => b.id == updatedBooking.id);
    if (doctorIndex != -1) {
      _doctorBookings[doctorIndex] = updatedBooking;
    }
  }

  /// Reset provider state
  void reset() {
    _status = BookingStatus.initial;
    _errorMessage = null;
    _currentBooking = null;
    _bookings = [];
    _patientBookings = [];
    _doctorBookings = [];
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    if (_status == BookingStatus.error) {
      _status = BookingStatus.initial;
    }
    notifyListeners();
  }
}