import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';
import '../../provider/SignUpProvider.dart';
import 'account_type_screen.dart';
import 'address_info_screen.dart';
import 'basic_information_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Validate current page before proceeding
  bool validateAndProceed(SignUpProvider provider) {
    bool isValid = provider.validatePage(currentPage);

    if (!isValid) {
      // Debug: Print which fields have errors
      print("=== VALIDATION FAILED FOR PAGE $currentPage ===");

      if (currentPage == 0) {
        // Basic Information
        if (provider.firstNameError != null) print("First Name Error: ${provider.firstNameError}");
        if (provider.lastNameError != null) print("Last Name Error: ${provider.lastNameError}");
        if (provider.emailError != null) print("Email Error: ${provider.emailError}");
        if (provider.passwordError != null) print("Password Error: ${provider.passwordError}");
        if (provider.confirmPasswordError != null) print("Confirm Password Error: ${provider.confirmPasswordError}");
        if (provider.dobError != null) print("DOB Error: ${provider.dobError}");
        if (provider.genderError != null) print("Gender Error: ${provider.genderError}");
      } else if (currentPage == 1) {
        // Address Information
        if (provider.addressLine1Error != null) print("Address Line 1 Error: ${provider.addressLine1Error}");
        if (provider.cityError != null) print("City Error: ${provider.cityError}");
        if (provider.stateError != null) print("State Error: ${provider.stateError}");
        if (provider.postcodeError != null) print("Postcode Error: ${provider.postcodeError}");
        if (provider.countryError != null) print("Country Error: ${provider.countryError}");
      } else if (currentPage == 2) {
        // Account Type
        if (provider.termsError != null) print("Terms Error: ${provider.termsError}");
      }
      print("==========================================");

      // Show error message with more specific info
      String errorMessage = 'Please fix the errors before continuing';

      // Count errors
      int errorCount = 0;
      if (currentPage == 0) {
        if (provider.firstNameError != null) errorCount++;
        if (provider.lastNameError != null) errorCount++;
        if (provider.emailError != null) errorCount++;
        if (provider.passwordError != null) errorCount++;
        if (provider.confirmPasswordError != null) errorCount++;
        if (provider.dobError != null) errorCount++;
        if (provider.genderError != null) errorCount++;
      } else if (currentPage == 1) {
        if (provider.addressLine1Error != null) errorCount++;
        if (provider.cityError != null) errorCount++;
        if (provider.stateError != null) errorCount++;
        if (provider.postcodeError != null) errorCount++;
        if (provider.countryError != null) errorCount++;
      } else if (currentPage == 2) {
        if (provider.termsError != null) errorCount++;
      }

      if (errorCount > 0) {
        errorMessage = 'Please fix $errorCount error${errorCount > 1 ? 's' : ''} before continuing';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      print("=== VALIDATION PASSED FOR PAGE $currentPage ===");
    }

    return isValid;
  }
  /// Handle final submission
  void handleSubmit(SignUpProvider provider) async {
    // Validate the final page
    if (!validateAndProceed(provider)) {
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Call the registration API
    bool success = await provider.registerUser();

    // Close loading dialog
    if (mounted) Navigator.of(context).pop();

    if (success) {
      // Registration successful
      print("=== REGISTRATION SUCCESSFUL ===");
      print("Response: ${provider.registrationResponse}");

      // Navigate to success screen
      if (mounted) {

        context.go('/accountCreationSuccessScreen');  // 🔥 Clears entire navigation stack
        // AppRouter.router.pushNamedAndRemoveUntil(
        //   '/accountCreationSuccessScreen',
        //       (route) => false, // 🔥 Clear ALL previous routes
        // );

        // AppRouter.router.pushReplacement('/accountCreationSuccessScreen');
      }
    } else {
      // Registration failed - show error
      print("=== REGISTRATION FAILED ===");
      print("Error: ${provider.registrationError}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.registrationError ?? 'Registration failed. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    final provider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 6),

              /// ---------------- BACK BUTTON ----------------
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (currentPage == 0) {
                      // Show confirmation dialog before exiting
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Cancel Registration?"),
                          content: const Text(
                            "Are you sure you want to cancel? Your progress will be lost.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                provider.resetForm(); // Clear form
                                Navigator.pop(context); // Exit signup
                              },
                              child: const Text(
                                "Yes, Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      previousPage();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Go Back",
                        style: TAppTextStyle.inter(
                          color: isDark ? Colors.white : QColors.lightGray800,
                          fontSize: 16,
                          weight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------- PAGEVIEW ----------------
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swipe
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: const [
                    BasicInformationScreen(),
                    AddressInfoScreen(),
                    AccountTypeScreen(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ---------------- DOTS INDICATOR ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: currentPage == index ? 22 : 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? QColors.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ---------------- BUTTON ----------------
              QButton(
                text: currentPage == 2 ? "Finish" : "Continue",
                onPressed: () {
                  if (currentPage == 2) {
                    // Final page - submit data
                    handleSubmit(provider);
                  } else {
                    // Not final page - validate and proceed
                    if (validateAndProceed(provider)) {
                      nextPage();
                    }
                  }
                },
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}