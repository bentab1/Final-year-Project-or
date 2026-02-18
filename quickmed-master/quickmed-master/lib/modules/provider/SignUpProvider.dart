import 'package:flutter/material.dart';
import 'package:quickmed/data/models/request/register_request.dart';
import 'package:quickmed/data/models/response/register_response.dart';
import 'package:quickmed/domain/repositories/auth_repository.dart';

class SignUpProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  SignUpProvider({required this.authRepository});

  // ==================== BASIC INFORMATION ====================
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController specializationController =
  TextEditingController();
  final TextEditingController specializationSymptomsController =
  TextEditingController();

  // ==================== ADDRESS INFORMATION ====================
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // ==================== ACCOUNT TYPE & MEDICAL ====================
  String selectedAccountType = "Patient";
  final TextEditingController medicalHistoryController =
  TextEditingController();
  bool acceptTerms = false;

  // ==================== REGISTRATION STATE ====================
  bool _isLoading = false;
  String? _registrationError;
  RegisterResponse? _registrationResponse;

  bool get isLoading => _isLoading;

  String? get registrationError => _registrationError;

  RegisterResponse? get registrationResponse => _registrationResponse;

  // ==================== VALIDATION ERRORS ====================
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? dobError;
  String? genderError;

  String? addressLine1Error;
  String? cityError;
  String? stateError;
  String? postcodeError;
  String? countryError;

  String? specializationError;
  String? specializationSymptomsError;

  String? termsError;

  // ==================== GETTERS ====================

  /// Get all form data as a Map
  Map<String, dynamic> getAllFormData() {
    return {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'dateOfBirth': dobController.text.trim(),
      'gender': genderController.text.trim(),
      'addressLine1': addressLine1Controller.text.trim(),
      'city': cityController.text.trim(),
      'state': stateController.text.trim(),
      'postcode': postcodeController.text.trim(),
      'country': countryController.text.trim(),
      'accountType': selectedAccountType,
      'medicalHistory': medicalHistoryController.text.trim(),
      'specialization': specializationController.text.trim(),
      'specializationSymptoms': specializationSymptomsController.text.trim(),
      'acceptedTerms': acceptTerms,
    };
  }

  // ==================== SETTERS ====================

  void setAccountType(String type) {
    selectedAccountType = type;
    // Clear errors when switching account type
    specializationError = null;
    specializationSymptomsError = null;
    notifyListeners();
  }

  void setAcceptTerms(bool value) {
    acceptTerms = value;
    termsError = null; // Clear error when user changes
    notifyListeners();
  }

  // ==================== REGISTRATION METHOD ====================

  /// Register user with backend
  /// Returns true if successful, false otherwise

  Future<bool> registerUser() async {
    // Validate all pages first
    if (!validateBasicInformation() ||
        !validateAddressInformation() ||
        !validateAccountTypeAndTerms()) {
      return false;
    }

    _isLoading = true;
    _registrationError = null;
    _registrationResponse = null;
    notifyListeners();

    try {
      // Create RegisterRequest from form data
      final registerRequest = _createRegisterRequest();

      // 🔍 DEBUG: Print the request data
      print("=== REGISTRATION REQUEST DATA ===");
      print("Email: ${registerRequest.email}");
      print("Username: ${registerRequest.username}");
      print("User Type: ${registerRequest.userType}");
      print("DOB: ${registerRequest.dob}");
      print("Password: ${registerRequest.password}");
      print("Gender: ${registerRequest.gender}");
      print("Address: ${registerRequest.address}");
      print("City: ${registerRequest.city}");
      print("State: ${registerRequest.state}");
      print("Zip: ${registerRequest.zipCode}");
      print("Country: ${registerRequest.country}");
      print("Health Issues: ${registerRequest.healthIssues}");
      print("Specialization: ${registerRequest.specialization}");
      print("Symptoms: ${registerRequest.specializationIllnessSymptoms}");
      print("================================");

      // Call repository to register user
      final response = await authRepository.registerUser(registerRequest);


      _registrationResponse = response;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      print("=== REGISTRATION ERROR ===");
      print("Full error: $e");
      print("========================");

      _registrationError = _extractErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
  RegisterRequest _createRegisterRequest() {
    return RegisterRequest(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      dob: _formatDate(dobController.text.trim()),
      gender: genderController.text.trim(),
      address: addressLine1Controller.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      zipCode: postcodeController.text.trim(),
      country: countryController.text.trim(),
      userType: selectedAccountType.toLowerCase(),  // ✅ Convert to lowercase

      healthIssues: selectedAccountType.toLowerCase() == "patient"  // ✅ Use toLowerCase()
          ? (medicalHistoryController.text.trim().isNotEmpty
          ? medicalHistoryController.text.trim()
          : '')
          : '',
      specialization: selectedAccountType.toLowerCase() == "doctor"  // ✅ Use toLowerCase()
          ? specializationController.text.trim()
          : '',
      specializationIllnessSymptoms: selectedAccountType.toLowerCase() == "doctor"  // ✅ Use toLowerCase()
          ? specializationSymptomsController.text.trim()
          : '',
      username: '${firstNameController.text.trim()}${lastNameController.text.trim()}',
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );
  }

  // RegisterRequest _createRegisterRequest() {
  //   return RegisterRequest(
  //     email: emailController.text.trim(),
  //     password: passwordController.text.trim(),
  //     dob: _formatDate(dobController.text.trim()), // Format the date
  //     gender: genderController.text.trim(),
  //     address: addressLine1Controller.text.trim(),
  //     city: cityController.text.trim(),
  //     state: stateController.text.trim(),
  //     zipCode: postcodeController.text.trim(),
  //     country: countryController.text.trim(),
  //     userType: selectedAccountType,
  //
  //     healthIssues: selectedAccountType == "patient"
  //         ? (medicalHistoryController.text.trim().isNotEmpty
  //         ? medicalHistoryController.text.trim()
  //         : '')
  //         : '',
  //     specialization: selectedAccountType == "doctor"
  //         ? specializationController.text.trim()
  //         : '',
  //     specializationIllnessSymptoms: selectedAccountType == "doctor"
  //         ? specializationSymptomsController.text.trim()
  //         : '',
  //     username: '${firstNameController.text.trim()}${lastNameController.text.trim()}', firstName: firstNameController.text.trim(), lastName: lastNameController.text.trim(), // No space or with underscore
  //   );
  // }

  String _formatDate(String input) {
    try {
      // Convert from DD/MM/YYYY to YYYY-MM-DD
      final parts = input.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
      return input; // Return as-is if format is different
    } catch (e) {
      return input;
    }
  }
  String _extractErrorMessage(String error) {
    // Remove "Exception: " prefix if present
    if (error.startsWith('Exception: ')) {
      return error.substring(11);
    }

    // Check for common error patterns
    if (error.contains('Network error')) {
      return 'Network error. Please check your internet connection.';
    }

    if (error.contains('Email already exists') ||
        error.toLowerCase().contains('already registered')) {
      return 'This email is already registered. Please use a different email or try logging in.';
    }

    if (error.contains('Invalid email')) {
      return 'Please enter a valid email address.';
    }

    // Return the error as is if no pattern matches
    return error.isNotEmpty ? error : 'Registration failed. Please try again.';
  }

  /// Clear registration state
  void clearRegistrationState() {
    _isLoading = false;
    _registrationError = null;
    _registrationResponse = null;
    notifyListeners();
  }

  // ==================== VALIDATION METHODS ====================

  /// Validate Basic Information (Page 1)
  bool validateBasicInformation() {
    bool isValid = true;

    // First Name Validation
    if (firstNameController.text.trim().isEmpty) {
      firstNameError = "First name is required";
      isValid = false;
    } else if (firstNameController.text.trim().length < 2) {
      firstNameError = "First name must be at least 2 characters";
      isValid = false;
    } else {
      firstNameError = null;
    }

    // Last Name Validation
    if (lastNameController.text.trim().isEmpty) {
      lastNameError = "Last name is required";
      isValid = false;
    } else if (lastNameController.text.trim().length < 2) {
      lastNameError = "Last name must be at least 2 characters";
      isValid = false;
    } else {
      lastNameError = null;
    }

    // Email Validation
    if (emailController.text.trim().isEmpty) {
      emailError = "Email is required";
      isValid = false;
    } else if (!_isValidEmail(emailController.text.trim())) {
      emailError = "Please enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    // Password Validation
    if (passwordController.text.isEmpty) {
      passwordError = "Password is required";
      isValid = false;
    } else if (passwordController.text.length < 8) {
      passwordError = "Password must be at least 8 characters";
      isValid = false;
    } else if (!_isStrongPassword(passwordController.text)) {
      passwordError =
      "Password must contain uppercase, lowercase, number & special character";
      isValid = false;
    } else {
      passwordError = null;
    }

    // Confirm Password Validation
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = "Please confirm your password";
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError = "Passwords do not match";
      isValid = false;
    } else {
      confirmPasswordError = null;
    }

    // Date of Birth Validation
    if (dobController.text.trim().isEmpty) {
      dobError = "Date of birth is required";
      isValid = false;
    } else if (!_isValidDate(dobController.text.trim())) {
      dobError = "Please enter a valid date (DD/MM/YYYY)";
      isValid = false;
    } else {
      dobError = null;
    }

    // Gender Validation
    if (genderController.text.trim().isEmpty) {
      genderError = "Gender is required";
      isValid = false;
    } else {
      genderError = null;
    }

    notifyListeners();
    return isValid;
  }

  /// Validate Address Information (Page 2)
  bool validateAddressInformation() {
    bool isValid = true;

    // Address Line 1 Validation
    if (addressLine1Controller.text.trim().isEmpty) {
      addressLine1Error = "Address is required";
      isValid = false;
    } else if (addressLine1Controller.text.trim().length < 5) {
      addressLine1Error = "Address must be at least 5 characters";
      isValid = false;
    } else {
      addressLine1Error = null;
    }

    // City Validation
    if (cityController.text.trim().isEmpty) {
      cityError = "City is required";
      isValid = false;
    } else if (cityController.text.trim().length < 2) {
      cityError = "City name must be at least 2 characters";
      isValid = false;
    } else {
      cityError = null;
    }

    // State Validation
    if (stateController.text.trim().isEmpty) {
      stateError = "State is required";
      isValid = false;
    } else if (stateController.text.trim().length < 2) {
      stateError = "State name must be at least 2 characters";
      isValid = false;
    } else {
      stateError = null;
    }

    // Postcode Validation
    if (postcodeController.text.trim().isEmpty) {
      postcodeError = "Postcode is required";
      isValid = false;
    } else if (postcodeController.text.trim().length < 4) {
      postcodeError = "Please enter a valid postcode";
      isValid = false;
    } else {
      postcodeError = null;
    }

    // Country Validation
    if (countryController.text.trim().isEmpty) {
      countryError = "Country is required";
      isValid = false;
    } else if (countryController.text.trim().length < 2) {
      countryError = "Country name must be at least 2 characters";
      isValid = false;
    } else {
      countryError = null;
    }

    notifyListeners();
    return isValid;
  }

  /// Validate Account Type & Terms (Page 3)
  bool validateAccountTypeAndTerms() {
    bool isValid = true;

    // Doctor-specific validation
    if (selectedAccountType == "doctor") {
      // Specialization Validation
      if (specializationController.text.trim().isEmpty) {
        specializationError = "Specialization is required for doctors";
        isValid = false;
      } else if (specializationController.text.trim().length < 3) {
        specializationError = "Please enter a valid specialization";
        isValid = false;
      } else {
        specializationError = null;
      }

      // Specialization Symptoms Validation
      if (specializationSymptomsController.text.trim().isEmpty) {
        specializationSymptomsError = "Specialization symptoms are required";
        isValid = false;
      } else if (specializationSymptomsController.text.trim().length < 3) {
        specializationSymptomsError = "Please enter valid symptoms";
        isValid = false;
      } else {
        specializationSymptomsError = null;
      }
    } else {
      // Clear doctor-specific errors if Patient is selected
      specializationError = null;
      specializationSymptomsError = null;
    }

    // Terms & Conditions Validation
    if (!acceptTerms) {
      termsError = "You must accept the terms and conditions";
      isValid = false;
    } else {
      termsError = null;
    }

    notifyListeners();
    return isValid;
  }

  /// Validate specific page
  bool validatePage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return validateBasicInformation();
      case 1:
        return validateAddressInformation();
      case 2:
        return validateAccountTypeAndTerms();
      default:
        return false;
    }
  }

  // ==================== HELPER VALIDATION METHODS ====================

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    // At least one uppercase, one lowercase, one number, one special character
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  bool _isValidDate(String date) {
    // Simple date validation for DD/MM/YYYY format
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(date)) {
      return false;
    }

    try {
      final parts = date.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;
      if (year < 1900 || year > DateTime.now().year) return false;

      // Additional validation for valid date
      final parsedDate = DateTime(year, month, day);
      if (parsedDate.year != year ||
          parsedDate.month != month ||
          parsedDate.day != day) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== CLEAR METHODS ====================

  /// Clear all errors
  void clearAllErrors() {
    firstNameError = null;
    lastNameError = null;
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
    dobError = null;
    genderError = null;
    addressLine1Error = null;
    cityError = null;
    stateError = null;
    postcodeError = null;
    countryError = null;
    specializationError = null;
    specializationSymptomsError = null;
    termsError = null;
    notifyListeners();
  }

  /// Clear error for specific field
  void clearFieldError(String fieldName) {
    switch (fieldName) {
      case 'firstName':
        firstNameError = null;
        break;
      case 'lastName':
        lastNameError = null;
        break;
      case 'email':
        emailError = null;
        break;
      case 'password':
        passwordError = null;
        break;
      case 'confirmPassword':
        confirmPasswordError = null;
        break;
      case 'dob':
        dobError = null;
        break;
      case 'gender':
        genderError = null;
        break;
      case 'addressLine1':
        addressLine1Error = null;
        break;
      case 'city':
        cityError = null;
        break;
      case 'state':
        stateError = null;
        break;
      case 'postcode':
        postcodeError = null;
        break;
      case 'country':
        countryError = null;
        break;
      case 'specialization':
        specializationError = null;
        break;
      case 'specializationSymptoms':
        specializationSymptomsError = null;
        break;
    }
    notifyListeners();
  }

  /// Reset all form data
  void resetForm() {
    // Clear all controllers
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    dobController.clear();
    genderController.clear();
    addressLine1Controller.clear();
    cityController.clear();
    stateController.clear();
    postcodeController.clear();
    countryController.clear();
    medicalHistoryController.clear();
    specializationController.clear();
    specializationSymptomsController.clear();

    // Reset other fields
    selectedAccountType = "Patient";
    acceptTerms = false;

    // Clear all errors
    clearAllErrors();

    // Clear registration state
    clearRegistrationState();

    notifyListeners();
  }

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    genderController.dispose();
    addressLine1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postcodeController.dispose();
    countryController.dispose();
    medicalHistoryController.dispose();
    specializationController.dispose();
    specializationSymptomsController.dispose();
    super.dispose();
  }
}
