import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/models/user.dart';

class UserPreferences {
  static const String _keyUserData = 'user_data';
  static const String _keyToken = 'auth_token';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Singleton pattern
  static final UserPreferences _instance = UserPreferences._internal();
  factory UserPreferences() => _instance;
  UserPreferences._internal();

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// Save user data
  Future<bool> saveUserData(UserData userData) async {
    try {
      final preferences = await prefs;
      final userJson = json.encode(userData.toJson());
      return await preferences.setString(_keyUserData, userJson);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Get user data
  Future<UserData?> getUserData() async {
    try {
      final preferences = await prefs;
      final userJson = preferences.getString(_keyUserData);
      if (userJson == null) return null;

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserData.fromJson(userMap);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Save authentication token
  Future<bool> saveToken(String token) async {
    try {
      final preferences = await prefs;
      return await preferences.setString(_keyToken, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  /// Get authentication token
  Future<String?> getToken() async {
    try {
      final preferences = await prefs;
      return preferences.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Save login status
  Future<bool> setLoggedIn(bool isLoggedIn) async {
    try {
      final preferences = await prefs;
      return await preferences.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('Error saving login status: $e');
      return false;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final preferences = await prefs;
      return preferences.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Save user data and token together (typically after login)
  Future<bool> saveUserSession({
    required UserData userData,
    required String token,
  }) async {
    try {
      final userSaved = await saveUserData(userData);
      final tokenSaved = await saveToken(token);
      final loginSet = await setLoggedIn(true);

      return userSaved && tokenSaved && loginSet;
    } catch (e) {
      print('Error saving user session: $e');
      return false;
    }
  }

  /// Clear all user data (logout)
  Future<bool> clearUserData() async {
    try {
      final preferences = await prefs;
      await preferences.remove(_keyUserData);
      await preferences.remove(_keyToken);
      await preferences.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  /// Clear all preferences
  Future<bool> clearAll() async {
    try {
      final preferences = await prefs;
      return await preferences.clear();
    } catch (e) {
      print('Error clearing all preferences: $e');
      return false;
    }
  }

  /// Update specific user field
  Future<bool> updateUserField(String field, dynamic value) async {
    try {
      final userData = await getUserData();
      if (userData == null) return false;

      final userMap = userData.toJson();
      userMap[field] = value;

      final updatedUser = UserData.fromJson(userMap);
      return await saveUserData(updatedUser);
    } catch (e) {
      print('Error updating user field: $e');
      return false;
    }
  }

  /// Update user data with copyWith method (recommended)
  Future<bool> updateUserData({
    String? firstName,
    String? lastName,
    String? dob,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? healthIssues,
    String? specialization,
    String? specializationIllnessSymptoms,
  }) async {
    try {
      final userData = await getUserData();
      if (userData == null) return false;

      final updatedUser = userData.copyWith(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        gender: gender,
        address: address,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country,
        healthIssues: healthIssues,
        specialization: specialization,
        specializationIllnessSymptoms: specializationIllnessSymptoms,
      );

      return await saveUserData(updatedUser);
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get user ID (returns int)
  Future<int?> getUserId() async {
    final userData = await getUserData();
    return userData?.id;
  }

  /// Get user ID as String (for backward compatibility)
  Future<String?> getUserIdString() async {
    final userData = await getUserData();
    return userData?.id.toString();
  }

  /// Get user type
  Future<String?> getUserType() async {
    final userData = await getUserData();
    return userData?.userType;
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    final userData = await getUserData();
    return userData?.email;
  }

  /// Get user username
  Future<String?> getUsername() async {
    final userData = await getUserData();
    return userData?.username;
  }

  /// Get user full name
  Future<String?> getUserFullName() async {
    final userData = await getUserData();
    return userData?.fullName;
  }

  /// Get user display name
  Future<String?> getDisplayName() async {
    final userData = await getUserData();
    return userData?.displayName;
  }

  /// Check if current user is a doctor
  Future<bool> isDoctor() async {
    final userData = await getUserData();
    return userData?.isDoctor ?? false;
  }

  /// Check if current user is a patient
  Future<bool> isPatient() async {
    final userData = await getUserData();
    return userData?.isPatient ?? false;
  }

  /// Check if profile is complete
  Future<bool> isProfileComplete() async {
    final userData = await getUserData();
    return userData?.isProfileComplete ?? false;
  }

  /// Get doctor specialization (returns null if not a doctor)
  Future<String?> getDoctorSpecialization() async {
    final userData = await getUserData();
    if (userData?.isDoctor == true) {
      return userData?.specialization;
    }
    return null;
  }

  /// Get patient health issues (returns null if not a patient)
  Future<String?> getPatientHealthIssues() async {
    final userData = await getUserData();
    if (userData?.isPatient == true) {
      return userData?.healthIssues;
    }
    return null;
  }

  /// Get user address information
  Future<Map<String, String?>> getUserAddress() async {
    final userData = await getUserData();
    if (userData == null) return {};

    return {
      'address': userData.address,
      'city': userData.city,
      'state': userData.state,
      'zipCode': userData.zipCode,
      'country': userData.country,
    };
  }

  /// Check if user has complete address
  Future<bool> hasCompleteAddress() async {
    final userData = await getUserData();
    if (userData == null) return false;

    return userData.address != null &&
        userData.address!.isNotEmpty &&
        userData.city != null &&
        userData.city!.isNotEmpty &&
        userData.state != null &&
        userData.state!.isNotEmpty &&
        userData.zipCode != null &&
        userData.zipCode!.isNotEmpty &&
        userData.country != null &&
        userData.country!.isNotEmpty;
  }

  /// Debug: Print all stored data
  Future<void> printStoredData() async {
    try {
      final preferences = await prefs;
      final userData = await getUserData();
      final token = await getToken();
      final isLoggedIn = await this.isLoggedIn();

      print('==================== USER PREFERENCES DEBUG ====================');
      print('Is Logged In: $isLoggedIn');
      print('Token: ${token != null ? '***${token.substring(token.length - 10)}' : 'null'}');
      print('User Data: $userData');
      print('================================================================');
    } catch (e) {
      print('Error printing stored data: $e');
    }
  }
}