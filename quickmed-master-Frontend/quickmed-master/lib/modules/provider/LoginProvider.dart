import 'package:flutter/material.dart';
import 'package:quickmed/data/models/response/login_response.dart';
import 'package:quickmed/domain/repositories/auth_repository.dart';

import '../../data/local/UserPreferences.dart';
import '../../data/models/models/user.dart';
import '../../data/models/request/LoginRequest.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final UserPreferences _userPrefs;

  LoginProvider({
    required this.authRepository,
    UserPreferences? userPrefs,
  }) : _userPrefs = userPrefs ?? UserPreferences();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _loginError;
  LoginResponse? _loginResponse;

  // Getters
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get loginError => _loginError;
  LoginResponse? get loginResponse => _loginResponse;

  // Form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  Future<bool> loginUser() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    _loginError = null;
    _loginResponse = null;
    notifyListeners();

    try {
      // Create login request
      final loginRequest = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("=== LOGIN REQUEST DATA ===");
      print("Email: ${loginRequest.email}");
      print("========================");

      // 1. Call repository to login user
      final response = await authRepository.loginUser(loginRequest);
      _loginResponse = response;

      // 2. Save tokens using UserPreferences
      await _userPrefs.saveToken(response.access);
      await _userPrefs.setLoggedIn(true);
      print("✅ Tokens saved to UserPreferences");

      // 3. Fetch and save user profile
      final profileSuccess = await fetchUserProfile();

      if (!profileSuccess) {
        print("⚠️ Login successful but profile fetch failed");
      }

      _isLoading = false;
      notifyListeners();

      print("✅ Login successful!");
      return true;
    } catch (e) {
      print("=== LOGIN ERROR ===");
      print("Full error: $e");
      print("==================");

      _loginError = _extractErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  /// Fetch user profile and save to UserPreferences
  Future<bool> fetchUserProfile() async {
    try {
      print("👤 Fetching user profile...");

      // Call repository to fetch profile
      final userData = await authRepository.getUser();

      print("✅ Profile fetched: ${userData.fullName}");

      // Save to UserPreferences
      await _userPrefs.saveUserData(userData);

      print("💾 Profile saved to UserPreferences");

      return true;
    } catch (e) {
      print("❌ Error fetching profile: $e");
      _loginError = _extractErrorMessage(e.toString());
      return false;
    }
  }

  /// Get cached user profile without API call
  Future<UserData?> getCachedUserProfile() async {
    try {
      return await _userPrefs.getUserData();
    } catch (e) {
      print("❌ Error getting cached profile: $e");
      return null;
    }
  }
  Future<bool> isUserLoggedIn() async {
    return await _userPrefs.isLoggedIn();
  }
  /// Refresh user profile data from API
  Future<bool> refreshUserProfile() async {
    _isLoading = true;
    _loginError = null;
    notifyListeners();

    try {
      // Fetch fresh data from API
      final userData = await authRepository.getUser();

      // Save updated data
      await _userPrefs.saveUserData(userData);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _loginError = _extractErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get the refresh token before clearing user data
      final token = await _userPrefs.getToken();

      if (token != null) {
        // Call repository logout to invalidate tokens on backend
        await authRepository.logout(token);
      }

      // Clear local user data
      await _userPrefs.clearUserData();

      _loginResponse = null;
      _loginError = null;
      emailController.clear();
      passwordController.clear();
      _isLoading = false;

      notifyListeners();
      print("✅ User logged out successfully");
    } catch (e) {
      print("❌ Error during logout: $e");
      _loginError = _extractErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<Map<String, String?>> getUserData() async {
    final userData = await _userPrefs.getUserData();

    if (userData == null) {
      return {};
    }

    return {
      'user_id': userData.id.toString(),
      'user_type': userData.userType,
      'email': userData.email,
      'username': userData.username,
      'first_name': userData.firstName,
      'last_name': userData.lastName,
      'dob': userData.dob,
      'gender': userData.gender,
      'address': userData.address,
      'city': userData.city,
      'state': userData.state,
      'zipCode': userData.zipCode,
      'country': userData.country,
    };
  }



  String _extractErrorMessage(String error) {
    // Remove "Exception: " prefix if present
    if (error.startsWith('Exception: ')) {
      error = error.substring(11);
    }

    // Check for common error patterns
    if (error.contains('Network error')) {
      return 'Network error. Please check your internet connection.';
    }

    if (error.toLowerCase().contains('invalid credentials') ||
        error.toLowerCase().contains('incorrect email or password')) {
      return 'Invalid email or password. Please try again.';
    }

    if (error.toLowerCase().contains('user not found') ||
        error.toLowerCase().contains('no active account')) {
      return 'No account found with this email.';
    }

    // Return the error as is if no pattern matches
    return error.isNotEmpty ? error : 'Login failed. Please try again.';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}