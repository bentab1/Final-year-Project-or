import 'package:flutter/material.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

import '../../../utils/widgets/TButton.dart';
import '../../../utils/widgets/text_input_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement your password reset API call here
      // Example:
      // try {
      //   await authService.resetPassword(_emailController.text);
      //   setState(() {
      //     _emailSent = true;
      //     _isLoading = false;
      //   });
      // } catch (e) {
      //   // Handle error
      // }

      setState(() {
        _emailSent = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark
          ? QColors.darkBackground
          : QColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _emailSent
              ? _buildSuccessView(isDark)
              : _buildFormView(isDark, size),
        ),
      ),
    );
  }

  Widget _buildFormView(bool isDark, Size size) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: QColors.newPrimary500.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_reset,
                size: 50,
                color: QColors.newPrimary500,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            'Forgot Password?',
            style: TAppTextStyle.inter(
              fontSize: 28,
              weight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Don\'t worry! It happens. Please enter the email address associated with your account.',
            style: TAppTextStyle.inter(
              fontSize: 14,
              weight: FontWeight.w400,
              color: isDark
                  ? QColors.darkTextSecondary
                  : QColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          const SizedBox(height: 8),

          TextInputWidget(
            dark: isDark,
            controller: _emailController,

            fillColor: Colors.transparent,
            headerText: "Enter your email",
            isEmail: true,
          ),

          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: QButton(
              text: 'Login',
              onPressed: _isLoading ? null : _handleResetPassword,
            ),
          ),
          const SizedBox(height: 24),

          // Back to Login
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: QColors.newPrimary500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Back to Login',
                    style: TAppTextStyle.inter(
                      fontSize: 14,
                      weight: FontWeight.w600,
                      color: QColors.newPrimary500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Success Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, size: 70, color: Colors.green),
        ),
        const SizedBox(height: 32),

        // Success Title
        Text(
          'Check Your Email',
          style: TAppTextStyle.inter(
            fontSize: 28,
            weight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Success Message
        Text(
          'We have sent a password reset link to',
          style: TAppTextStyle.inter(
            fontSize: 14,
            weight: FontWeight.w400,
            color: isDark
                ? QColors.darkTextSecondary
                : QColors.lightTextSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: TAppTextStyle.inter(
            fontSize: 16,
            weight: FontWeight.w600,
            color: QColors.newPrimary500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Please check your inbox and click on the link to reset your password.',
          style: TAppTextStyle.inter(
            fontSize: 14,
            weight: FontWeight.w400,
            color: isDark
                ? QColors.darkTextSecondary
                : QColors.lightTextSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Open Email App Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Open email app
              // You can use url_launcher package: launch('mailto:');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: QColors.newPrimary500,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Open Email App',
              style: TAppTextStyle.inter(
                fontSize: 16,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Resend Email Button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
              _handleResetPassword();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: QColors.newPrimary500,
              side: BorderSide(color: QColors.newPrimary500, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Resend Email',
              style: TAppTextStyle.inter(
                fontSize: 16,
                weight: FontWeight.w600,
                color: QColors.newPrimary500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Back to Login
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 18, color: QColors.newPrimary500),
              const SizedBox(width: 4),
              Text(
                'Back to Login',
                style: TAppTextStyle.inter(
                  fontSize: 14,
                  weight: FontWeight.w600,
                  color: QColors.newPrimary500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
