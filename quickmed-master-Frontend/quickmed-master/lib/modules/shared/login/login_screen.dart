import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/routes/app_routes.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/quick_med_logo.dart';
import '../../provider/LoginProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _dotsController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  /// Handle login button press
  Future<void> _handleLogin(LoginProvider provider) async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Attempt login (this now includes profile fetch)
    final success = await provider.loginUser();

    if (!mounted) return;

    if (success) {
      // Get user data to determine navigation
      final userData = await provider.getUserData();
      final userType = userData['user_type'];
      final firstName = userData['first_name'];
      final email = userData['email'];

      // Determine welcome message
      String welcomeName = '';
      if (firstName != null && firstName.isNotEmpty) {
        welcomeName = firstName;
      } else if (email != null) {
        welcomeName = email;
      } else {
        welcomeName = 'back';
      }

      // Login successful - show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back, $welcomeName!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate based on user type
      if (userType == 'doctor') {
        // Navigate to doctor dashboard
        AppRouter.router.pushReplacement('/doctorBottomNavScreen');
      } else if (userType == 'patient') {
        // Navigate to patient dashboard
        AppRouter.router.pushReplacement('/patientBottomNavScreen');
      } else {
        // Default navigation (if user_type is not set or unknown)
        AppRouter.router.pushReplacement('/patientBottomNavScreen');
      }
    } else {
      // Login failed - show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.loginError ?? 'Login failed. Please try again.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 46),

                /// ---------------- LOGO ----------------
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: QuickMedLogo(
                    fadeAnimation: _fadeAnimation,
                    isDark: isDark,
                    logoSize: 100,
                    textSize: 54,
                  ),
                ),

                /// ---------------- EMAIL ----------------
                TextInputWidget(
                  dark: isDark,
                  fillColor: Colors.transparent,
                  headerText: "Email",
                  isEmail: true,
                  controller: provider.emailController,
                  validator: provider.validateEmail,
                ),
                const SizedBox(height: 16),

                /// ---------------- PASSWORD ----------------
                TextInputWidget(
                  dark: isDark,
                  fillColor: Colors.transparent,
                  headerText: "Password",
                  isPassword: true,
                  controller: provider.passwordController,
                  validator: provider.validatePassword,
                ),

                /// ---------------- FORGOT PASSWORD ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        AppRouter.router.push('/forgotPasswordScreen');
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TAppTextStyle.inter(
                          color: QColors.primary,
                          fontSize: 14,
                          height: 1.4,
                          weight: FontWeight.w500,
                          shouldUnderline: true,
                          underlineColor: QColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- ERROR MESSAGE (if any) ----------------
                if (provider.loginError != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.loginError!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                /// ---------------- LOGIN BUTTON ----------------
                provider.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : QButton(
                  text: 'Login',
                  onPressed: () => _handleLogin(provider),
                ),

                const SizedBox(height: 24),

                /// ---------------- NO ACCOUNT TEXT ----------------
                Text(
                  "Don't have an account?",
                  style: TAppTextStyle.inter(
                    color: isDark ? Colors.white : QColors.lightGray800,
                    fontSize: 16.0,
                    height: 1.2,
                    weight: FontWeight.w500,
                  ),
                ),

                /// ---------------- CREATE ACCOUNT ----------------
                GestureDetector(
                  onTap: () {
                    AppRouter.router.push('/signUpScreen');
                  },
                  child: Text(
                    "Create an Account",
                    style: TAppTextStyle.inter(
                      color: QColors.primary,
                      fontSize: 16.0,
                      height: 1.8,
                      weight: FontWeight.w500,
                      shouldUnderline: true,
                      underlineColor: QColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ---------------- NEED HELP BUTTON ----------------
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to support/help page
                  },
                  child: Text(
                    "Need Help?",
                    style: TAppTextStyle.inter(
                      color: isDark ? Colors.white : QColors.lightGray800,
                      fontSize: 15.0,
                      height: 1.8,
                      weight: FontWeight.w500,
                      shouldUnderline: true,
                      underlineColor:
                      isDark ? Colors.white : QColors.lightGray800,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}