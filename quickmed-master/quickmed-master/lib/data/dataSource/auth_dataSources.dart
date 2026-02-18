// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:quickmed/core/network/api_client.dart';
// import '../../core/endpoint/api_endpoints.dart';
// import '../models/models/user.dart';
// import '../models/request/LoginRequest.dart';
// import '../models/request/register_request.dart';
// import '../models/response/login_response.dart';
// import '../models/response/register_response.dart';
//
// class AuthDataSource {
//   final ApiClient apiClient;
//
//   AuthDataSource({required this.apiClient});
//
//   /// Throws [Exception] on failure
//   Future<RegisterResponse> register(RegisterRequest request) async {
//     try {
//       if (kDebugMode) {
//         print('📝 Registering user: ${request.email}');
//         print('📦 Request data: ${request.toJson()}');
//       }
//
//       // ✅ FIX: Send Map directly - Dio handles JSON encoding automatically
//       final response = await apiClient.post(
//         endpoint: ApiEndpoints.register,
//         data: request.toJson(), // ✅ Remove jsonEncode() - just send the Map
//       );
//
//       if (kDebugMode) {
//         print('📥 Response status: ${response.statusCode}');
//         print('📥 Response data: ${response.data}');
//       }
//
//       // SUCCESS CASE
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (kDebugMode) print('✅ Registration successful');
//
//         if (response.data is! Map<String, dynamic>) {
//           throw Exception("Invalid response format from server");
//         }
//
//         return RegisterResponse.fromJson(response.data);
//       }
//
//       // ERROR CASE
//       return _extractErrorAndThrow(response.data, response.statusCode);
//
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print('❌ DioException during registration: ${e.message}');
//         print('❌ Response status: ${e.response?.statusCode}');
//         print('❌ Response data: ${e.response?.data}');
//       }
//
//       if (e.response?.data != null) {
//         return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
//       }
//
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       if (kDebugMode) print('❌ Unexpected error during registration: $e');
//       throw Exception('Registration failed: $e');
//     }
//   }
//
//   /// Extract error message and throw
//   Never _extractErrorAndThrow(dynamic data, int? statusCode) {
//     String message = "Registration failed";
//
//     if (data is Map) {
//       message = data['message'] ?? data['error'] ?? message;
//     } else if (data is String) {
//       // Check if it's HTML (common with 500 errors)
//       if (data.contains('<!DOCTYPE') || data.contains('<html')) {
//         message = "Server error occurred (Status: $statusCode)";
//       } else {
//         message = data;
//       }
//     }
//
//     if (kDebugMode) print('❌ Registration failed: $message');
//     throw Exception(message);
//   }
//
//
//   Future<LoginResponse> login(LoginRequest request) async {
//     try {
//       if (kDebugMode) {
//         print('🔐 Logging in user: ${request.email}');
//         print('📦 Request data: ${request.toJson()}');
//       }
//
//       final response = await apiClient.post(
//         endpoint: ApiEndpoints.login,
//         data: request.toJson(),
//       );
//
//       if (kDebugMode) {
//         print('📥 Response status: ${response.statusCode}');
//         print('📥 Response data: ${response.data}');
//       }
//
//       // SUCCESS CASE
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (kDebugMode) print('✅ Login successful');
//
//         if (response.data is! Map<String, dynamic>) {
//           throw Exception("Invalid response format from server");
//         }
//
//         return LoginResponse.fromJson(response.data);
//       }
//
//       // ERROR CASE
//       return _extractErrorAndThrow(response.data, response.statusCode);
//
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print('❌ DioException during login: ${e.message}');
//         print('❌ Response status: ${e.response?.statusCode}');
//         print('❌ Response data: ${e.response?.data}');
//       }
//
//       if (e.response?.data != null) {
//         return _extractErrorAndThrow(e.response!.data, e.response!.statusCode);
//       }
//
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       if (kDebugMode) print('❌ Unexpected error during login: $e');
//       throw Exception('Login failed: $e');
//     }
//   }
//
//
//   Future<UserData> fetchProfile() async {
//     try {
//       if (kDebugMode) {
//         print('👤 Fetching user profile...');
//       }
//
//       // ✅ No need to manually add token - ApiClient interceptor handles it!
//       final response = await apiClient.get(ApiEndpoints.profile);
//
//       if (kDebugMode) {
//         print('📥 Response status: ${response.statusCode}');
//         print('📥 Response data: ${response.data}');
//       }
//
//       // SUCCESS CASE
//       if (response.statusCode == 200) {
//         if (kDebugMode) print('✅ Profile fetched successfully');
//
//         if (response.data is! Map<String, dynamic>) {
//           throw Exception("Invalid response format from server");
//         }
//
//         // Parse user data
//         final userData = UserData.fromJson(response.data);
//
//         // Save to SharedPreferences
//         if (kDebugMode) print('💾 Profile saved to SharedPreferences');
//
//         return userData;
//       }
//
//       // ERROR CASES
//       if (response.statusCode == 401) {
//         if (kDebugMode) print('❌ Unauthorized - Token expired');
//         // Session already cleared by ApiClient interceptor
//         throw Exception('Session expired. Please login again.');
//       }
//
//       // Generic error
//       return _extractProfileErrorAndThrow(response.data, response.statusCode);
//
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print('❌ DioException during profile fetch: ${e.message}');
//         print('❌ Response status: ${e.response?.statusCode}');
//         print('❌ Response data: ${e.response?.data}');
//       }
//
//       if (e.response?.statusCode == 401) {
//         // Session already cleared by ApiClient interceptor
//         throw Exception('Session expired. Please login again.');
//       }
//
//       if (e.response?.data != null) {
//         return _extractProfileErrorAndThrow(e.response!.data, e.response!.statusCode);
//       }
//
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       if (kDebugMode) print('❌ Unexpected error during profile fetch: $e');
//       throw Exception('Profile fetch failed: $e');
//     }
//   }
//
//   /// Logout user
//   Future<void> logout(String refreshToken) async {
//     try {
//       if (kDebugMode) {
//         print('🚪 Logging out user...');
//       }
//
//       final response = await apiClient.post(
//         endpoint: ApiEndpoints.logout,
//         data: {'refresh_token': refreshToken},
//       );
//
//       if (kDebugMode) {
//         print('📥 Response status: ${response.statusCode}');
//         print('📥 Response data: ${response.data}');
//       }
//
//       // SUCCESS CASE
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         if (kDebugMode) print('✅ Logout successful');
//         return;
//       }
//
//       // ERROR CASE
//       _extractLogoutErrorAndThrow(response.data, response.statusCode);
//
//     } on DioException catch (e) {
//       if (kDebugMode) {
//         print('❌ DioException during logout: ${e.message}');
//         print('❌ Response status: ${e.response?.statusCode}');
//         print('❌ Response data: ${e.response?.data}');
//       }
//
//       if (e.response?.data != null) {
//         _extractLogoutErrorAndThrow(e.response!.data, e.response!.statusCode);
//       }
//
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       if (kDebugMode) print('❌ Unexpected error during logout: $e');
//       throw Exception('Logout failed: $e');
//     }
//   }
//
//   /// Extract error message and throw (for logout)
//   Never _extractLogoutErrorAndThrow(dynamic data, int? statusCode) {
//     String message = "Logout failed";
//
//     if (data is Map) {
//       message = data['message'] ?? data['error'] ?? message;
//     } else if (data is String) {
//       if (data.contains('<!DOCTYPE') || data.contains('<html')) {
//         message = "Server error occurred (Status: $statusCode)";
//       } else {
//         message = data;
//       }
//     }
//
//     if (kDebugMode) print('❌ Logout failed: $message');
//     throw Exception(message);
//   }
//
//   /// Extract error message and throw (for profile fetch)
//   Never _extractProfileErrorAndThrow(dynamic data, int? statusCode) {
//     String message = "Failed to fetch profile";
//
//     if (data is Map) {
//       message = data['message'] ?? data['error'] ?? message;
//     } else if (data is String) {
//       if (data.contains('<!DOCTYPE') || data.contains('<html')) {
//         message = "Server error occurred (Status: $statusCode)";
//       } else {
//         message = data;
//       }
//     }
//
//     if (kDebugMode) print('❌ Profile fetch failed: $message');
//     throw Exception(message);
//   }
// }
//


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quickmed/core/network/api_client.dart';
import '../../core/endpoint/api_endpoints.dart';
import '../models/models/user.dart';
import '../models/request/LoginRequest.dart';
import '../models/request/register_request.dart';
import '../models/response/login_response.dart';
import '../models/response/register_response.dart';

class AuthDataSource {
  final ApiClient apiClient;

  AuthDataSource({required this.apiClient});

  /// Register new user
  /// Throws [Exception] on failure
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      if (kDebugMode) {
        print('📝 Registering user: ${request.email}');
        print('📦 Request data: ${request.toJson()}');
      }

      final response = await apiClient.post(
        endpoint: ApiEndpoints.register,
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Registration successful');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        return RegisterResponse.fromJson(response.data);
      }

      // ERROR CASE
      _handleErrorResponse(response.data, response.statusCode, 'Registration');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during registration: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        _handleErrorResponse(e.response!.data, e.response!.statusCode, 'Registration');
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during registration: $e');
      throw Exception('Registration failed: $e');
    }
  }

  /// Login user
  /// Throws [Exception] on failure
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      if (kDebugMode) {
        print('🔐 Logging in user: ${request.email}');
        print('📦 Request data: ${request.toJson()}');
      }

      final response = await apiClient.post(
        endpoint: ApiEndpoints.login,
        data: request.toJson(),
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) print('✅ Login successful');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        return LoginResponse.fromJson(response.data);
      }

      // ERROR CASE - Pass 'Login' as operation type
      _handleErrorResponse(response.data, response.statusCode, 'Login');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during login: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        _handleErrorResponse(e.response!.data, e.response!.statusCode, 'Login');
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during login: $e');
      throw Exception('Login failed: $e');
    }
  }

  /// Fetch user profile
  /// Throws [Exception] on failure
  Future<UserData> fetchProfile() async {
    try {
      if (kDebugMode) {
        print('👤 Fetching user profile...');
      }

      final response = await apiClient.get(ApiEndpoints.profile);

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200) {
        if (kDebugMode) print('✅ Profile fetched successfully');

        if (response.data is! Map<String, dynamic>) {
          throw Exception("Invalid response format from server");
        }

        return UserData.fromJson(response.data);
      }

      // ERROR CASES
      if (response.statusCode == 401) {
        if (kDebugMode) print('❌ Unauthorized - Token expired');
        throw Exception('Session expired. Please login again.');
      }

      _handleErrorResponse(response.data, response.statusCode, 'Profile fetch');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during profile fetch: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      }

      if (e.response?.data != null) {
        _handleErrorResponse(e.response!.data, e.response!.statusCode, 'Profile fetch');
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during profile fetch: $e');
      throw Exception('Profile fetch failed: $e');
    }
  }

  /// Logout user
  /// Throws [Exception] on failure
  Future<void> logout(String refreshToken) async {
    try {
      if (kDebugMode) {
        print('🚪 Logging out user...');
      }

      final response = await apiClient.post(
        endpoint: ApiEndpoints.logout,
        data: {'refresh_token': refreshToken},
      );

      if (kDebugMode) {
        print('📥 Response status: ${response.statusCode}');
        print('📥 Response data: ${response.data}');
      }

      // SUCCESS CASE
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (kDebugMode) print('✅ Logout successful');
        return;
      }

      _handleErrorResponse(response.data, response.statusCode, 'Logout');

    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException during logout: ${e.message}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }

      if (e.response?.data != null) {
        _handleErrorResponse(e.response!.data, e.response!.statusCode, 'Logout');
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error during logout: $e');
      throw Exception('Logout failed: $e');
    }
  }

  /// ⭐ UNIFIED ERROR HANDLER - Handles all error responses
  /// Extracts meaningful error messages and throws appropriate exceptions
  Never _handleErrorResponse(dynamic data, int? statusCode, String operation) {
    String message = "$operation failed";

    // Handle different response data types
    if (data is Map<String, dynamic>) {
      // Try to extract error from common fields
      if (data.containsKey('detail')) {
        message = data['detail'].toString();
      } else if (data.containsKey('message')) {
        message = data['message'].toString();
      } else if (data.containsKey('error')) {
        message = data['error'].toString();
      } else if (data.containsKey('errors')) {
        // Handle validation errors (e.g., {"email": ["Invalid email"]})
        final errors = data['errors'];
        if (errors is Map) {
          final errorMessages = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => e.toString()));
            } else {
              errorMessages.add(value.toString());
            }
          });
          message = errorMessages.join(', ');
        } else {
          message = errors.toString();
        }
      } else {
        // Try to extract error from any field
        final errorMessages = <String>[];
        data.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((e) => '$key: $e'));
          } else if (value is String && value.isNotEmpty) {
            errorMessages.add('$key: $value');
          }
        });

        if (errorMessages.isNotEmpty) {
          message = errorMessages.join(', ');
        }
      }
    } else if (data is String) {
      // Check if it's HTML (common with 500 errors)
      if (data.contains('<!DOCTYPE') || data.contains('<html')) {
        message = "Server error occurred (Status: $statusCode)";
      } else if (data.isNotEmpty) {
        message = data;
      }
    }

    // Add status code context for specific errors
    if (statusCode == 401) {
      message = message.isEmpty ? 'Unauthorized' : message;
    } else if (statusCode == 403) {
      message = message.isEmpty ? 'Forbidden' : message;
    } else if (statusCode == 404) {
      message = message.isEmpty ? 'Not found' : message;
    } else if (statusCode == 500) {
      message = message.isEmpty ? 'Internal server error' : message;
    }

    if (kDebugMode) {
      print('❌ $operation failed (Status: $statusCode): $message');
    }

    throw Exception(message);
  }
}