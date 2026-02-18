
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/widgets/text_input_widget.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../provider/SignUpProvider.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

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
                  "Choose Account Type",
                  style: TAppTextStyle.inter(
                    color: isDark ? Colors.white70 : Colors.black,
                    fontSize: 16,
                    weight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// ---------------- PATIENT & DOCTOR BUTTONS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _typeButton(
                    context,
                    "patient",
                    isDark,
                    provider.selectedAccountType,
                        () => provider.setAccountType("patient"),
                  ),
                  _typeButton(
                    context,
                    "doctor",
                    isDark,
                    provider.selectedAccountType,
                        () => provider.setAccountType("doctor"),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ---------------- DOCTOR SPECIALIZATION FIELDS ----------------
              if (provider.selectedAccountType == "doctor") ...[
                Center(
                  child: Text(
                    "Doctor Information",
                    style: TAppTextStyle.inter(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontSize: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextInputWidget(
                  dark: isDark,
                  fillColor: Colors.transparent,
                  headerText: "Specialization",
                  hintText: "e.g. Cardiologist, Neurologist",
                  controller: provider.specializationController,
                ),

                const SizedBox(height: 16),

                TextInputWidget(
                  dark: isDark,
                  fillColor: Colors.transparent,
                  headerText: "Specialization Symptoms",
                  hintText: "e.g. Heart disease, Chest pain",
                  controller: provider.specializationSymptomsController,
                ),

                const SizedBox(height: 32),
              ],

              /// ---------------- MEDICAL HISTORY (for Patients) ----------------
              if (provider.selectedAccountType == "patient") ...[
                Center(
                  child: Text(
                    "Medical History",
                    style: TAppTextStyle.inter(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontSize: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextInputWidget(
                  dark: isDark,
                  fillColor: Colors.transparent,
                  headerText: "Enter Health Issues (optional)",
                  hintText: "e.g. Hypertension",
                  controller: provider.medicalHistoryController,
                ),

                const SizedBox(height: 24),
              ],

              /// ---------------- TERMS & CONDITIONS ----------------
              Row(
                children: [
                  Checkbox(
                    value: provider.acceptTerms,
                    activeColor: QColors.primary,
                    onChanged: (val) {
                      provider.setAcceptTerms(val ?? false);
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        provider.setAcceptTerms(!provider.acceptTerms);
                      },
                      child: Text(
                        "Accept terms and Conditions",
                        style: TAppTextStyle.inter(
                          color: QColors.primary,
                          fontSize: 16,
                          weight: FontWeight.w500,
                          shouldUnderline: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// ---------------- TERMS ERROR MESSAGE ----------------
              if (provider.termsError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    provider.termsError!,
                    style: TAppTextStyle.inter(
                      color: Colors.red,
                      fontSize: 12,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton(
      BuildContext context,
      String type,
      bool isDark,
      String selectedType,
      VoidCallback onTap,
      ) {
    bool selected = selectedType == type;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? QColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? QColors.primary : Colors.grey.shade400,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TAppTextStyle.inter(
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}