import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../provider/SignUpProvider.dart';

class AddressInfoScreen extends StatelessWidget {
  const AddressInfoScreen({super.key});

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
                  "Address",
                  style: TAppTextStyle.inter(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                    weight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ---------------- ADDRESS LINE 1 ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Address Line 1",
                hintText: "e.g. Torkia Street North bank",
                controller: provider.addressLine1Controller,
                errorText: provider.addressLine1Error,
                onChanged: (value) {
                  if (provider.addressLine1Error != null) {
                    provider.clearFieldError('addressLine1');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- CITY ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "City",
                hintText: "e.g. Makurdi",
                controller: provider.cityController,
                errorText: provider.cityError,
                onChanged: (value) {
                  if (provider.cityError != null) {
                    provider.clearFieldError('city');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- STATE ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "State",
                hintText: "e.g. Benue",
                controller: provider.stateController,
                errorText: provider.stateError, // ← ADDED THIS LINE
                onChanged: (value) {
                  if (provider.stateError != null) {
                    provider.clearFieldError('state');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- POSTCODE ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Postcode",
                hintText: "e.g. 970101",
                controller: provider.postcodeController,
                errorText: provider.postcodeError,
                onChanged: (value) {
                  if (provider.postcodeError != null) {
                    provider.clearFieldError('postcode');
                  }
                },
              ),
              const SizedBox(height: 12),

              /// ---------------- COUNTRY ----------------
              TextInputWidget(
                dark: isDark,
                fillColor: Colors.transparent,
                headerText: "Country",
                hintText: "e.g. Nigeria",
                controller: provider.countryController,
                errorText: provider.countryError,
                onChanged: (value) {
                  if (provider.countryError != null) {
                    provider.clearFieldError('country');
                  }
                },
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}