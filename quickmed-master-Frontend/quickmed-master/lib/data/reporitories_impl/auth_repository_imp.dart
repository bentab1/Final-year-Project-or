import 'package:flutter/foundation.dart';
import 'package:quickmed/core/network/api_client.dart';
import 'package:quickmed/data/dataSource/auth_dataSources.dart';
import 'package:quickmed/data/models/models/user.dart';
import 'package:quickmed/data/models/request/register_request.dart';
import 'package:quickmed/data/models/response/register_response.dart';
import 'package:quickmed/domain/repositories/auth_repository.dart';

import '../models/request/LoginRequest.dart';
import '../models/response/login_response.dart';

class AuthRepoImpl implements AuthRepository{
  final AuthDataSource authRemoteDataSource;

  AuthRepoImpl({required this.authRemoteDataSource});

  @override
  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    print("➡️ [AuthRepoImpl] registerUser called with: ${request.toJson()}");

    try {
      final response = await authRemoteDataSource.register(request);
      print("✅ [AuthRepoImpl] Registration success: ${response.toJson()}");
      return response;
    } catch (error, stackTrace) {
      print("❌ [AuthRepoImpl] Error in registerUser: $error");
      print(stackTrace);
      throw Exception('Error in repository during Registration: $error');
    }
  }

  @override
  Future<LoginResponse> loginUser(LoginRequest request) async {
    print("➡️ [AuthRepoImpl] loginUser called with: ${request.email}");

    try {
      final response = await authRemoteDataSource.login(request);
      print("✅ [AuthRepoImpl] Login success: ${response.toString()}");
      return response;
    } catch (error, stackTrace) {
      print("❌ [AuthRepoImpl] Error in loginUser: $error");
      print(stackTrace);
      throw Exception('Error in repository during Login: $error');
    }
  }

  @override
  Future<UserData> getUser() async {

    try {
      final response = await authRemoteDataSource.fetchProfile();
      print("✅ [AuthRepoImpl] Login success: ${response.toString()}");
      return response;
    } catch (error, stackTrace) {
      print("❌ [AuthRepoImpl] Error in loginUser: $error");
      print(stackTrace);
      throw Exception('Error in repository during Login: $error');
    }
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      if (kDebugMode) print('🚪 Repository: Logging out...');

      // Call API to invalidate refresh token
      await authRemoteDataSource.logout(refreshToken);

      // Clear local session data

      if (kDebugMode) print('✅ Repository: Logout successful, session cleared');
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Repository: Logout API failed - $e');
        print('🧹 Repository: Clearing local session anyway...');
      }

      // Even if API fails, clear local session

      if (kDebugMode) print('✅ Repository: Local session cleared');

      // Don't rethrow - logout should succeed even if API fails
    }
  }
}