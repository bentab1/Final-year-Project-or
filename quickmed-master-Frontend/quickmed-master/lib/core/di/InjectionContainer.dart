import 'package:quickmed/core/network/api_client.dart';
import 'package:quickmed/data/dataSource/DoctorDataSource.dart';
import 'package:quickmed/data/dataSource/auth_dataSources.dart';
import 'package:quickmed/data/reporitories_impl/BookingRepoImpl.dart';
import 'package:quickmed/domain/repositories/auth_repository.dart';
import 'package:quickmed/modules/provider/LoginProvider.dart';

import '../../data/dataSource/BookingDataSource.dart';
import '../../data/reporitories_impl/DoctorRepositoryImpl.dart';
import '../../data/reporitories_impl/auth_repository_imp.dart';
import '../../domain/repositories/BookingRepository.dart';
import '../../domain/repositories/DoctorRepository.dart';
import '../../modules/provider/BookingProvider.dart';
import '../../modules/provider/DoctorProvider.dart';
import '../../modules/provider/SignUpProvider.dart';

class InjectionContainer {
  // Singleton instance
  static final InjectionContainer _instance = InjectionContainer._internal();

  factory InjectionContainer() => _instance;

  InjectionContainer._internal();

  // ==================== CORE ====================
  late final ApiClient _apiClient;

  // ==================== DATA SOURCES ====================
  late final AuthDataSource _authDataSource;
  late final DoctorDataSource _doctorRemoteDataSource;
  late final BookingDataSource _bookingDataSource;

  // ==================== REPOSITORIES ====================
  late final AuthRepository _authRepository;
  late final DoctorRepository _doctorRepository;
  late final BookingRepository _bookingRepository;

  // ==================== PROVIDERS ====================
  late final SignUpProvider _signUpProvider;
  late final LoginProvider _loginProvider;
  late final DoctorProvider _doctorProvider;
  late final BookingProvider _bookingProvider;

  /// Initialize all dependencies
  /// [baseUrl] - Your API base URL (e.g., "https://api.yourapp.com")
  Future<void> init({required String baseUrl}) async {
    // ==================== CORE ====================
    // Initialize ApiClient with base URL
    _apiClient = ApiClient(baseUrl);

    // ==================== DATA SOURCES ====================
    _authDataSource = AuthDataSource(apiClient: _apiClient);
    _doctorRemoteDataSource = DoctorDataSource(apiClient: _apiClient);
    _bookingDataSource = BookingDataSource(apiClient: _apiClient);

    // ==================== REPOSITORIES ====================
    _authRepository = AuthRepoImpl(authRemoteDataSource: _authDataSource);
    _doctorRepository = DoctorRepositoryImpl(doctorDataSource: _doctorRemoteDataSource);
    _bookingRepository = BookingRepoImpl(bookingDataSource: _bookingDataSource);

    // ==================== PROVIDERS ====================
    _signUpProvider = SignUpProvider(authRepository: _authRepository);
    _loginProvider = LoginProvider(authRepository: _authRepository);
    _doctorProvider = DoctorProvider(doctorRepository: _doctorRepository);
    _bookingProvider = BookingProvider(bookingRepository: _bookingRepository);
  }

  // ==================== GETTERS ====================

  /// Get ApiClient instance
  ApiClient get apiClient => _apiClient;

  /// Get AuthDataSource instance
  AuthDataSource get authDataSource => _authDataSource;

  /// Get DoctorRemoteDataSource instance
  DoctorDataSource get doctorRemoteDataSource => _doctorRemoteDataSource;

  /// Get BookingDataSource instance
  BookingDataSource get bookingDataSource => _bookingDataSource;

  /// Get AuthRepository instance
  AuthRepository get authRepository => _authRepository;

  /// Get DoctorRepository instance
  DoctorRepository get doctorRepository => _doctorRepository;

  /// Get BookingRepository instance
  BookingRepository get bookingRepository => _bookingRepository;

  /// Get SignUpProvider instance
  SignUpProvider get signUpProvider => _signUpProvider;

  /// Get LoginProvider instance
  LoginProvider get loginProvider => _loginProvider;

  /// Get DoctorProvider instance
  DoctorProvider get doctorProvider => _doctorProvider;

  /// Get BookingProvider instance
  BookingProvider get bookingProvider => _bookingProvider;

  /// Reset all dependencies (useful for testing)
  void reset() {
    // Add any cleanup logic here if needed
  }
}