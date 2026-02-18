import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../provider/SignUpProvider.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);
    final provider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Basic Information",
                  style: TAppTextStyle.inter(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                    weight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ---------------- FIRST NAME ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "First Name",
                controller: provider.firstNameController,
                errorText: provider.firstNameError,
                onChanged: (value) {
                  // Clear error when user starts typing
                  if (provider.firstNameError != null) {
                    provider.clearFieldError('firstName');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- LAST NAME ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Last Name",
                controller: provider.lastNameController,
                errorText: provider.lastNameError,
                onChanged: (value) {
                  if (provider.lastNameError != null) {
                    provider.clearFieldError('lastName');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- EMAIL ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Email",
                isEmail: true,
                controller: provider.emailController,
                errorText: provider.emailError,
                onChanged: (value) {
                  if (provider.emailError != null) {
                    provider.clearFieldError('email');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- PASSWORD ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Password",
                isPassword: true,
                hintText: "Strong password",
                controller: provider.passwordController,
                errorText: provider.passwordError,
                onChanged: (value) {
                  if (provider.passwordError != null) {
                    provider.clearFieldError('password');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- CONFIRM PASSWORD ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Confirm Password",
                isPassword: true,
                controller: provider.confirmPasswordController,
                errorText: provider.confirmPasswordError,
                onChanged: (value) {
                  if (provider.confirmPasswordError != null) {
                    provider.clearFieldError('confirmPassword');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- DATE OF BIRTH ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Date of Birth",
                hintText: "DD/MM/YYYY",
                controller: provider.dobController,
                onChanged: (value) {
                  if (provider.dobError != null) {
                    provider.clearFieldError('dob');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- GENDER ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Gender",
                hintText: "e.g. Male, Female, Other",
                controller: provider.genderController,
                onChanged: (value) {
                  if (provider.genderError != null) {
                    provider.clearFieldError('gender');
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