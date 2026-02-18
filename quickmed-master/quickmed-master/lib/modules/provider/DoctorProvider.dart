//
//
//
// import 'package:flutter/foundation.dart';
// import '../../data/models/models/DoctorModel.dart';
// import '../../data/models/request/FindDoctorsRequest.dart';
// import '../../domain/repositories/DoctorRepository.dart';
//
// enum DoctorSearchStatus {
//   initial,
//   loading,
//   success,
//   error,
// }
//
// class DoctorProvider extends ChangeNotifier {
//   final DoctorRepository doctorRepository;
//
//   DoctorProvider({required this.doctorRepository});
//
//   // State variables
//   DoctorSearchStatus _status = DoctorSearchStatus.initial;
//   List<DoctorModel> _doctors = [];
//   String? _errorMessage;
//   int _totalCount = 0;
//   String? _selectedDoctorId;
//
//   // Getters
//   DoctorSearchStatus get status => _status;
//   List<DoctorModel> get doctors => _doctors;
//   List<DoctorModel> get suggestedDoctors => _doctors; // Alias for UI compatibility
//   String? get errorMessage => _errorMessage;
//   int get totalCount => _totalCount;
//   bool get isLoading => _status == DoctorSearchStatus.loading;
//   bool get hasError => _status == DoctorSearchStatus.error;
//   bool get hasData => _status == DoctorSearchStatus.success;
//   String? get selectedDoctorId => _selectedDoctorId;
//
//   // In DoctorProvider, update the selectedDoctor getter:
//   DoctorModel? get selectedDoctor {
//     if (_selectedDoctorId == null) {
//       print('❌ No doctor ID selected');
//       return null;
//     }
//
//     print('🔍 Looking for doctor with ID: $_selectedDoctorId');
//     print('🔍 Available doctors: ${_doctors.map((d) => '${d.id}: ${d.fullName}').join(', ')}');
//
//     try {
//       final doctor = _doctors.firstWhere((doctor) => doctor.id.toString() == _selectedDoctorId);
//       print('✅ Found doctor: ${doctor.fullName}');
//       return doctor;
//     } catch (e) {
//       print('❌ Doctor not found: $e');
//       return null;
//     }
//   }
//
//
//   Future<void> findDoctors(String symptoms, {String? medicalHistory}) async {
//     if (kDebugMode) {
//       print('🔍 [DoctorProvider] Finding doctors for symptoms: $symptoms');
//       if (medicalHistory != null) {
//         print('📋 [DoctorProvider] Medical history: $medicalHistory');
//       }
//     }
//
//     _status = DoctorSearchStatus.loading;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       final request = FindDoctorsRequest(
//         symptoms: symptoms,
//         medicalHistory: medicalHistory,
//       );
//       final response = await doctorRepository.findDoctors(request);
//
//       _doctors = response.doctors;
//       _totalCount = response.count;
//       _status = DoctorSearchStatus.success;
//       _errorMessage = null;
//
//       if (kDebugMode) {
//         print('✅ [DoctorProvider] Found ${_doctors.length} doctors');
//       }
//
//       notifyListeners();
//     } catch (error) {
//       _status = DoctorSearchStatus.error;
//       _errorMessage = error.toString().replaceAll('Exception: ', '');
//       _doctors = [];
//       _totalCount = 0;
//
//       if (kDebugMode) {
//         print('❌ [DoctorProvider] Error finding doctors: $error');
//       }
//
//       notifyListeners();
//     }
//   }
//
//   /// Find doctors based on symptoms
//
//   /// Select a doctor by ID
//   void selectDoctor(String doctorId) {
//     if (kDebugMode) {
//       print('✅ [DoctorProvider] Selecting doctor: $doctorId');
//     }
//
//     _selectedDoctorId = doctorId;
//     notifyListeners();
//   }
//
//   /// Deselect current doctor
//   void deselectDoctor() {
//     if (kDebugMode) {
//       print('❌ [DoctorProvider] Deselecting doctor');
//     }
//
//     _selectedDoctorId = null;
//     notifyListeners();
//   }
//
//   /// Clear search results and reset state
//   void clearSearch() {
//     if (kDebugMode) {
//       print('🧹 [DoctorProvider] Clearing search results');
//     }
//
//     _status = DoctorSearchStatus.initial;
//     _doctors = [];
//     _totalCount = 0;
//     _errorMessage = null;
//     _selectedDoctorId = null;
//     notifyListeners();
//   }
//
//   /// Reset error state
//   void clearError() {
//     if (kDebugMode) {
//       print('🧹 [DoctorProvider] Clearing error state');
//     }
//
//     _errorMessage = null;
//     if (_status == DoctorSearchStatus.error) {
//       _status = DoctorSearchStatus.initial;
//     }
//     notifyListeners();
//   }
// }


// lib/features/doctors/presentation/providers/doctor_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/models/DoctorModel.dart';
import '../../data/models/request/FindDoctorsRequest.dart';
import '../../data/models/request/UpdateWorkingHoursRequest.dart';
import '../../data/models/request/GetAvailableSlotsRequest.dart';
import '../../data/models/request/UpdateWorkingHoursRequest12.dart';
import '../../data/models/response/UpdateWorkingHoursResponse.dart';
import '../../data/models/response/AvailableSlotsResponse.dart';
import '../../data/models/response/BookingsResponse.dart';
import '../../domain/repositories/DoctorRepository.dart';

enum DoctorSearchStatus {
  initial,
  loading,
  success,
  error,
}

enum WorkingHoursStatus {
  initial,
  loading,
  success,
  error,
}

enum AvailableSlotsStatus {
  initial,
  loading,
  success,
  error,
}

enum BookingsStatus {
  initial,
  loading,
  success,
  error,
}

enum WorkingHoursStatus12 {
  initial,
  loading,
  success,
  error,
}

class DoctorProvider extends ChangeNotifier {
  final DoctorRepository doctorRepository;

  DoctorProvider({required this.doctorRepository});

  // State variables
  DoctorSearchStatus _status = DoctorSearchStatus.initial;
  List<DoctorModel> _doctors = [];
  String? _errorMessage;
  int _totalCount = 0;
  String? _selectedDoctorId;

  // New state variables for working hours
  WorkingHoursStatus _workingHoursStatus = WorkingHoursStatus.initial;
  UpdateWorkingHoursResponse? _profileResponse;
  String? _workingHoursErrorMessage;

  // New state variables for available slots
  AvailableSlotsStatus _slotsStatus = AvailableSlotsStatus.initial;
  AvailableSlotsResponse? _availableSlots;
  String? _slotsErrorMessage;

  // New state variables for bookings
  BookingsStatus _bookingsStatus = BookingsStatus.initial;
  BookingsResponse? _bookingsResponse;
  String? _bookingsErrorMessage;




  // Getters
  DoctorSearchStatus get status => _status;
  List<DoctorModel> get doctors => _doctors;
  List<DoctorModel> get suggestedDoctors => _doctors; // Alias for UI compatibility
  String? get errorMessage => _errorMessage;
  int get totalCount => _totalCount;
  bool get isLoading => _status == DoctorSearchStatus.loading;
  bool get hasError => _status == DoctorSearchStatus.error;
  bool get hasData => _status == DoctorSearchStatus.success;
  String? get selectedDoctorId => _selectedDoctorId;

  // New getters for working hours
  WorkingHoursStatus get workingHoursStatus => _workingHoursStatus;
  UpdateWorkingHoursResponse? get profileResponse => _profileResponse;
  String? get workingHoursErrorMessage => _workingHoursErrorMessage;
  bool get isWorkingHoursLoading => _workingHoursStatus == WorkingHoursStatus.loading;

  // New getters for available slots
  AvailableSlotsStatus get slotsStatus => _slotsStatus;
  AvailableSlotsResponse? get availableSlots => _availableSlots;
  String? get slotsErrorMessage => _slotsErrorMessage;
  bool get isSlotsLoading => _slotsStatus == AvailableSlotsStatus.loading;

  // New getters for bookings
  BookingsStatus get bookingsStatus => _bookingsStatus;
  BookingsResponse? get bookingsResponse => _bookingsResponse;
  String? get bookingsErrorMessage => _bookingsErrorMessage;
  bool get isBookingsLoading => _bookingsStatus == BookingsStatus.loading;

  // In DoctorProvider, update the selectedDoctor getter:
  DoctorModel? get selectedDoctor {
    if (_selectedDoctorId == null) {
      print('❌ No doctor ID selected');
      return null;
    }

    print('🔍 Looking for doctor with ID: $_selectedDoctorId');
    print('🔍 Available doctors: ${_doctors.map((d) => '${d.id}: ${d.fullName}').join(', ')}');

    try {
      final doctor = _doctors.firstWhere((doctor) => doctor.id.toString() == _selectedDoctorId);
      print('✅ Found doctor: ${doctor.fullName}');
      return doctor;
    } catch (e) {
      print('❌ Doctor not found: $e');
      return null;
    }
  }


  Future<void> findDoctors(String symptoms, {String? medicalHistory}) async {
    if (kDebugMode) {
      print('🔍 [DoctorProvider] Finding doctors for symptoms: $symptoms');
      if (medicalHistory != null) {
        print('📋 [DoctorProvider] Medical history: $medicalHistory');
      }
    }

    _status = DoctorSearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = FindDoctorsRequest(
        symptoms: symptoms,
        medicalHistory: medicalHistory,
      );
      final response = await doctorRepository.findDoctors(request);

      _doctors = response.doctors;
      _totalCount = response.count;
      _status = DoctorSearchStatus.success;
      _errorMessage = null;

      if (kDebugMode) {
        print('✅ [DoctorProvider] Found ${_doctors.length} doctors');
      }

      notifyListeners();
    } catch (error) {
      _status = DoctorSearchStatus.error;
      _errorMessage = error.toString().replaceAll('Exception: ', '');
      _doctors = [];
      _totalCount = 0;

      if (kDebugMode) {
        print('❌ [DoctorProvider] Error finding doctors: $error');
      }

      notifyListeners();
    }
  }

  /// Select a doctor by ID
  void selectDoctor(String doctorId) {
    if (kDebugMode) {
      print('✅ [DoctorProvider] Selecting doctor: $doctorId');
    }

    _selectedDoctorId = doctorId;
    notifyListeners();
  }

  /// Deselect current doctor
  void deselectDoctor() {
    if (kDebugMode) {
      print('❌ [DoctorProvider] Deselecting doctor');
    }

    _selectedDoctorId = null;
    notifyListeners();
  }

  /// Clear search results and reset state
  void clearSearch() {
    if (kDebugMode) {
      print('🧹 [DoctorProvider] Clearing search results');
    }

    _status = DoctorSearchStatus.initial;
    _doctors = [];
    _totalCount = 0;
    _errorMessage = null;
    _selectedDoctorId = null;
    notifyListeners();
  }

  /// Reset error state
  void clearError() {
    if (kDebugMode) {
      print('🧹 [DoctorProvider] Clearing error state');
    }

    _errorMessage = null;
    if (_status == DoctorSearchStatus.error) {
      _status = DoctorSearchStatus.initial;
    }
    notifyListeners();
  }

  // ============ NEW METHODS ============

  /// Update doctor's working hours
  UserProfileResponse? _userProfileResponse;

  UserProfileResponse? get userProfileResponse => _userProfileResponse;

  bool get hasWorkingHoursError => _workingHoursStatus == WorkingHoursStatus.error;
  bool get hasWorkingHoursData => _workingHoursStatus == WorkingHoursStatus.success;

  Future<void> updateDoctorWorkingHours(UpdateWorkingHoursRequest12 request) async {
    if (kDebugMode) {
      print('🕐 [DoctorProvider] Updating doctor working hours');
      print('📦 [DoctorProvider] Working hours count: ${request.workingHours.length}');
    }

    _workingHoursStatus = WorkingHoursStatus.loading;
    _workingHoursErrorMessage = null;
    notifyListeners();

    try {
      final response = await doctorRepository.updateDoctorWorkingHours(request);

      _userProfileResponse = response;
      _workingHoursStatus = WorkingHoursStatus.success;
      _workingHoursErrorMessage = null;

      if (kDebugMode) {
        print('✅ [DoctorProvider] Working hours updated successfully');
        print('✅ [DoctorProvider] Doctor: ${response.firstName} ${response.lastName}');
        print('✅ [DoctorProvider] Total working hours: ${response.doctorProfile?.workingHours?.length ?? 0}');
      }

      notifyListeners();
    } catch (error) {
      _workingHoursStatus = WorkingHoursStatus.error;
      _workingHoursErrorMessage = error.toString().replaceAll('Exception: ', '');
      _userProfileResponse = null;

      if (kDebugMode) {
        print('❌ [DoctorProvider] Error updating working hours: $error');
      }

      notifyListeners();
    }
  }
  void clearWorkingHoursState() {
    if (kDebugMode) {
      print('🧹 [DoctorProvider] Clearing working hours state');
    }

    _workingHoursStatus = WorkingHoursStatus.initial;
    _workingHoursErrorMessage = null;
    _userProfileResponse = null;
    notifyListeners();
  }

  /// Clear working hours error
  void clearWorkingHoursError() {
    if (kDebugMode) {
      print('🧹 [DoctorProvider] Clearing working hours error');
    }

    _workingHoursErrorMessage = null;
    if (_workingHoursStatus == WorkingHoursStatus.error) {
      _workingHoursStatus = WorkingHoursStatus.initial;
    }
    notifyListeners();
  }
  /// Get available slots for a doctor on a specific date
  Future<void> getAvailableSlots(String doctorId, String date) async {
    if (kDebugMode) {
      print('🕐 [DoctorProvider] Fetching available slots for doctor $doctorId on $date');
    }

    _slotsStatus = AvailableSlotsStatus.loading;
    _slotsErrorMessage = null;
    notifyListeners();

    try {
      final request = GetAvailableSlotsRequest(
        doctorId: doctorId,
        date: date,
      );
      final response = await doctorRepository.getAvailableSlots(request);

      _availableSlots = response;
      _slotsStatus = AvailableSlotsStatus.success;
      _slotsErrorMessage = null;

      if (kDebugMode) {
        print('✅ [DoctorProvider] Available slots fetched: ${response.availableCount}/${response.totalSlots}');
      }

      notifyListeners();
    } catch (error) {
      _slotsStatus = AvailableSlotsStatus.error;
      _slotsErrorMessage = error.toString().replaceAll('Exception: ', '');

      if (kDebugMode) {
        print('❌ [DoctorProvider] Error fetching available slots: $error');
      }

      notifyListeners();
    }
  }

}