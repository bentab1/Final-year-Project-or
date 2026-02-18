// lib/features/doctors/data/models/response/BookingsResponse.dart

import '../models/BookingModel.dart';

class BookingsResponse {
  final int count;
  final List<BookingModel> bookings;
  final String? message;

  BookingsResponse({
    required this.count,
    required this.bookings,
    this.message,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    // Handle different possible response structures
    List<BookingModel> bookingsList = [];
    int bookingsCount = 0;

    // Case 1: Response has 'bookings' array
    if (json.containsKey('bookings')) {
      final bookingsData = json['bookings'] as List;
      bookingsList = bookingsData
          .map((booking) => BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList();
      bookingsCount = bookingsList.length;
    }
    // Case 2: Response has 'results' array (paginated response)
    else if (json.containsKey('results')) {
      final resultsData = json['results'] as List;
      bookingsList = resultsData
          .map((booking) => BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList();
      bookingsCount = json['count'] ?? bookingsList.length;
    }
    // Case 3: Response is directly an array
    else if (json.containsKey('data') && json['data'] is List) {
      final dataList = json['data'] as List;
      bookingsList = dataList
          .map((booking) => BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList();
      bookingsCount = bookingsList.length;
    }

    return BookingsResponse(
      count: json['count'] ?? bookingsCount,
      bookings: bookingsList,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'bookings': bookings.map((booking) => booking.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }

  BookingsResponse copyWith({
    int? count,
    List<BookingModel>? bookings,
    String? message,
  }) {
    return BookingsResponse(
      count: count ?? this.count,
      bookings: bookings ?? this.bookings,
      message: message ?? this.message,
    );
  }

  // Helper methods
  bool get isEmpty => bookings.isEmpty;
  bool get isNotEmpty => bookings.isNotEmpty;

  // Filter bookings by status
  List<BookingModel> getBookingsByStatus(String status) {
    return bookings.where((booking) => booking.status == status).toList();
  }

  // Get pending bookings
  List<BookingModel> get pendingBookings => getBookingsByStatus('pending');

  // Get approved bookings
  List<BookingModel> get approvedBookings => getBookingsByStatus('approved');

  // Get rejected bookings
  List<BookingModel> get rejectedBookings => getBookingsByStatus('rejected');

  // Get completed bookings
  List<BookingModel> get completedBookings => getBookingsByStatus('completed');
}