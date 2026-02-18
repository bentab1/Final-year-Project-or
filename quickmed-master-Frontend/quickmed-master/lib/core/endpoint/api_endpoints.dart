class ApiEndpoints{


  static const String baseUrl=  'http://178.128.3.110/api';
  static const String register = '/auth/register/';
  static const String login = '/auth/login/';
  static const String profile = '/auth/profile/';
  static const String bookings = '/bookings/';
  static String bookingById(int id) => '/bookings/$id';

  static const String patientBookings = '/bookings/patient-bookings';
  static String deleteBooking(int id) => '/bookings/$id'; //
  static const String findDoctors = '/auth/find-doctors/';

  static const String doctorBookings = '/bookings/doctor-bookings/';

  // Dynamic booking endpoints
  static String getBookingById(int id) => '/bookings/$id/';
  static String updateBookingStatus(int id) => '/bookings/$id/update-status/';
  static const String logout = '/auth/logout/';

  // New endpoints
  static const String updateProfile = '/auth/profile/';
  static const String availableSlots = '/bookings/available-slots/';
}