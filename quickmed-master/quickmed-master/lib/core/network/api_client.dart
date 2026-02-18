//
//
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import '../../data/local/UserPreferences.dart';
//
// class ApiClient {
//   final Dio _dio;
//   final UserPreferences _userPrefs;
//
//   ApiClient(String baseUrl, {UserPreferences? userPrefs})
//       : _userPrefs = userPrefs ?? UserPreferences(),
//         _dio = Dio(BaseOptions(
//           baseUrl: baseUrl,
//           connectTimeout: const Duration(seconds: 10),
//           receiveTimeout: const Duration(seconds: 10),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         )) {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // ✅ Automatically add token to requests
//           final token = await _userPrefs.getToken();
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//             if (kDebugMode) print('🔑 Token added to request');
//           }
//
//           if (kDebugMode) {
//             print('📤 Request: ${options.method} ${options.path}');
//             print('📤 Headers: ${options.headers}');
//             print('📤 Data: ${options.data}');
//           }
//           handler.next(options);
//         },
//         onResponse: (response, handler) {
//           if (kDebugMode) {
//             print('✅ Response [${response.statusCode}]: ${response.requestOptions.path}');
//             print('✅ Response data: ${response.data}');
//           }
//           handler.next(response);
//         },
//         onError: (error, handler) async {
//           if (kDebugMode) {
//             print('❌ Error [${error.response?.statusCode}]: ${error.message}');
//             print('❌ Error data: ${error.response?.data}');
//           }
//
//           // ✅ Handle 401 - Clear session
//           if (error.response?.statusCode == 401) {
//             if (kDebugMode) print('🔓 Unauthorized - Clearing session');
//             await _userPrefs.clearUserData();
//           }
//
//           handler.next(error);
//         },
//       ),
//     );
//   }
//
//   // GET request
//   Future<Response> get(
//       String endpoint, {
//         Map<String, dynamic>? queryParameters,
//         Map<String, dynamic>? headers,
//       }) async {
//     try {
//       final response = await _dio.get(
//         endpoint,
//         queryParameters: queryParameters,
//         options: headers != null ? Options(headers: headers) : null,
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // POST request
//   Future<Response> post({
//     required String endpoint,
//     dynamic data,
//     Map<String, dynamic>? headers,
//   }) async {
//     try {
//       final response = await _dio.post(
//         endpoint,
//         data: data,
//         options: Options(
//           headers: headers,
//           validateStatus: (status) => true,
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // PUT request
//   Future<Response> put({
//     required String endpoint,
//     required Map<String, dynamic> data,
//     bool isFormData = false,
//   }) async {
//     try {
//       if (isFormData) {
//         final formData = await _convertToFormData(data);
//         return await _dio.put(
//           endpoint,
//           data: formData,
//           options: Options(
//             contentType: 'multipart/form-data',
//           ),
//         );
//       } else {
//         return await _dio.put(
//           endpoint,
//           data: data,
//         );
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<FormData> _convertToFormData(Map<String, dynamic> data) async {
//     final formDataMap = <String, dynamic>{};
//
//     for (var entry in data.entries) {
//       final key = entry.key;
//       final value = entry.value;
//
//       if (value is File) {
//         final fileName = value.path.split('/').last;
//         formDataMap[key] = await MultipartFile.fromFile(
//           value.path,
//           filename: fileName,
//         );
//       } else if (value is String && (value.startsWith('/') || value.contains('file://'))) {
//         final filePath = value.replaceAll('file://', '');
//         final fileName = filePath.split('/').last;
//         formDataMap[key] = await MultipartFile.fromFile(
//           filePath,
//           filename: fileName,
//         );
//       } else if (value is MultipartFile) {
//         formDataMap[key] = value;
//       } else {
//         formDataMap[key] = value;
//       }
//     }
//
//     return FormData.fromMap(formDataMap);
//   }
//
//   // DELETE request
//   Future<Response> delete({
//     required String endpoint,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? headers,
//   }) async {
//     try {
//       final response = await _dio.delete(
//         endpoint,
//         data: data,
//         options: headers != null ? Options(headers: headers) : null,
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // PATCH request
//   Future<Response> patch(
//       String path, {
//         Map<String, dynamic>? data,
//         Map<String, dynamic>? queryParameters,
//         Options? options,
//       }) async {
//     try {
//       final response = await _dio.patch(
//         path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // Multipart POST (file uploads)
//   Future<Response> postMultipart({
//     required String endpoint,
//     required FormData data,
//   }) async {
//     try {
//       final response = await _dio.post(
//         endpoint,
//         data: data,
//         options: Options(
//           contentType: 'multipart/form-data',
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // Multipart PUT
//   Future<Response> putMultipart({
//     required String endpoint,
//     required FormData data,
//   }) async {
//     try {
//       final response = await _dio.put(
//         endpoint,
//         data: data,
//         options: Options(
//           headers: {
//             'Content-Type': 'multipart/form-data',
//           },
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   // Error handling
//   Response _handleError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         if (kDebugMode) print("⏱️ Connection Timeout: ${error.message}");
//         break;
//       case DioExceptionType.sendTimeout:
//         if (kDebugMode) print("⏱️ Send Timeout: ${error.message}");
//         break;
//       case DioExceptionType.receiveTimeout:
//         if (kDebugMode) print("⏱️ Receive Timeout: ${error.message}");
//         break;
//       case DioExceptionType.badResponse:
//         if (kDebugMode) print("❌ Bad Response [${error.response?.statusCode}]: ${error.response?.data}");
//         return error.response!;
//       case DioExceptionType.cancel:
//         if (kDebugMode) print("🚫 Request Cancelled: ${error.message}");
//         break;
//       case DioExceptionType.badCertificate:
//         if (kDebugMode) print("🔒 Bad Certificate: ${error.message}");
//         break;
//       case DioExceptionType.connectionError:
//         if (kDebugMode) print("🌐 Connection Error: ${error.message}");
//         break;
//       case DioExceptionType.unknown:
//         if (kDebugMode) print("❓ Unknown Error: ${error.message}");
//         break;
//     }
//
//     return error.response ??
//         Response(
//           requestOptions: RequestOptions(path: error.requestOptions.path),
//           statusCode: 500,
//           statusMessage: 'An unknown error occurred.',
//         );
//   }
// }



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../data/local/UserPreferences.dart';

class ApiClient {
  final Dio _dio;
  final UserPreferences _userPrefs;

  ApiClient(String baseUrl, {UserPreferences? userPrefs})
      : _userPrefs = userPrefs ?? UserPreferences(),
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30), // Increased from 10
          receiveTimeout: const Duration(seconds: 30), // Increased from 10
          sendTimeout: const Duration(seconds: 30),    // Added
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    // Add retry interceptor FIRST
    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ Automatically add token to requests
          final token = await _userPrefs.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            if (kDebugMode) print('🔑 Token added to request');
          }

          if (kDebugMode) {
            print('📤 Request: ${options.method} ${options.path}');
            print('📤 Headers: ${options.headers}');
            print('📤 Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ Response [${response.statusCode}]: ${response.requestOptions.path}');
            print('✅ Response data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('❌ Error [${error.response?.statusCode}]: ${error.message}');
            print('❌ Error data: ${error.response?.data}');
          }

          // ✅ Handle 401 - Clear session
          if (error.response?.statusCode == 401) {
            if (kDebugMode) print('🔓 Unauthorized - Clearing session');
            await _userPrefs.clearUserData();
          }

          handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<Response> post({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: headers,
          validateStatus: (status) => true,
        ),
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<Response> put({
    required String endpoint,
    required Map<String, dynamic> data,
    bool isFormData = false,
  }) async {
    try {
      if (isFormData) {
        final formData = await _convertToFormData(data);
        return await _dio.put(
          endpoint,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );
      } else {
        return await _dio.put(
          endpoint,
          data: data,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FormData> _convertToFormData(Map<String, dynamic> data) async {
    final formDataMap = <String, dynamic>{};

    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is File) {
        final fileName = value.path.split('/').last;
        formDataMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: fileName,
        );
      } else if (value is String && (value.startsWith('/') || value.contains('file://'))) {
        final filePath = value.replaceAll('file://', '');
        final fileName = filePath.split('/').last;
        formDataMap[key] = await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      } else if (value is MultipartFile) {
        formDataMap[key] = value;
      } else {
        formDataMap[key] = value;
      }
    }

    return FormData.fromMap(formDataMap);
  }

  // DELETE request
  Future<Response> delete({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: headers != null ? Options(headers: headers) : null,
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
      String path, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Multipart POST (file uploads)
  Future<Response> postMultipart({
    required String endpoint,
    required FormData data,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Multipart PUT
  Future<Response> putMultipart({
    required String endpoint,
    required FormData data,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handling
  Response _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        if (kDebugMode) print("⏱️ Connection Timeout: ${error.message}");
        break;
      case DioExceptionType.sendTimeout:
        if (kDebugMode) print("⏱️ Send Timeout: ${error.message}");
        break;
      case DioExceptionType.receiveTimeout:
        if (kDebugMode) print("⏱️ Receive Timeout: ${error.message}");
        break;
      case DioExceptionType.badResponse:
        if (kDebugMode) print("❌ Bad Response [${error.response?.statusCode}]: ${error.response?.data}");
        return error.response!;
      case DioExceptionType.cancel:
        if (kDebugMode) print("🚫 Request Cancelled: ${error.message}");
        break;
      case DioExceptionType.badCertificate:
        if (kDebugMode) print("🔒 Bad Certificate: ${error.message}");
        break;
      case DioExceptionType.connectionError:
        if (kDebugMode) print("🌐 Connection Error: ${error.message}");
        break;
      case DioExceptionType.unknown:
        if (kDebugMode) print("❓ Unknown Error: ${error.message}");
        break;
    }

    return error.response ??
        Response(
          requestOptions: RequestOptions(path: error.requestOptions.path),
          statusCode: 500,
          statusMessage: 'An unknown error occurred.',
        );
  }
}

// ============================================
// 🔄 RETRY INTERCEPTOR
// ============================================
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if we should retry
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

      if (retryCount < maxRetries) {
        if (kDebugMode) {
          print('🔄 Retry attempt ${retryCount + 1}/$maxRetries for ${err.requestOptions.path}');
        }

        // Wait before retrying
        await Future.delayed(retryDelay * (retryCount + 1)); // Exponential backoff

        // Increment retry count
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          // Retry the request
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          // If retry fails, pass the error along
          return super.onError(e, handler);
        }
      } else {
        if (kDebugMode) {
          print('❌ Max retries ($maxRetries) reached for ${err.requestOptions.path}');
        }
      }
    }

    // If we shouldn't retry or max retries reached, pass error along
    return super.onError(err, handler);
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException err) {
    // Retry on these conditions:
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode != null &&
            (err.response!.statusCode! >= 500 || // Server errors
                err.response!.statusCode == 408 || // Request timeout
                err.response!.statusCode == 429)); // Too many requests
  }
}