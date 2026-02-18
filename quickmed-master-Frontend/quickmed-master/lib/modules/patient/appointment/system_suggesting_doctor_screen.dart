import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmed/data/models/models/DoctorModel.dart';
import 'package:quickmed/modules/patient/appointment/widgets/DoctorCard.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';
import '../../provider/DoctorProvider.dart';

// Main Screen
class SystemSuggestingDoctorScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const SystemSuggestingDoctorScreen({super.key, this.extra});

  @override
  State<SystemSuggestingDoctorScreen> createState() => _SystemSuggestingDoctorScreenState();
}

class _SystemSuggestingDoctorScreenState extends State<SystemSuggestingDoctorScreen> {
  @override
  void initState() {
    super.initState();

    // If doctors haven't been loaded yet and we have symptoms data, load them
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DoctorProvider>();

      // 🔍 Log all data received from previous screen
      print('═══════════════════════════════════════════════════');
      print('📋 DATA FROM PREVIOUS SCREEN:');
      print('═══════════════════════════════════════════════════');
      print('🔹 Extra data null? ${widget.extra == null}');
      print('🔹 Extra data: ${widget.extra}');

      if (widget.extra != null) {
        print('🔹 Symptoms key exists? ${widget.extra!.containsKey('symptoms')}');
        print('🔹 Symptoms value: ${widget.extra!['symptoms']}');
        print('🔹 Medical History key exists? ${widget.extra!.containsKey('medicalHistory')}');
        print('🔹 Medical History value: ${widget.extra!['medicalHistory']}');
        print('🔹 All keys: ${widget.extra!.keys.toList()}');
      }
      print('═══════════════════════════════════════════════════');

      // Only fetch if we don't have doctors and we have the necessary data
      if (provider.doctors.isEmpty &&
          !provider.isLoading &&
          widget.extra != null &&
          widget.extra!['symptoms'] != null) {
        final symptoms = widget.extra!['symptoms'] as String;
        final medicalHistory = widget.extra!['medicalHistory'] as String?;

        print('');
        print('🚀 CALLING FIND DOCTORS API:');
        print('🔹 Symptoms: $symptoms');
        print('🔹 Medical History: $medicalHistory');
        print('🔹 Medical History is empty? ${medicalHistory?.isEmpty ?? true}');
        print('🔹 Will pass medical history: ${medicalHistory?.isNotEmpty == true ? medicalHistory : null}');
        print('═══════════════════════════════════════════════════');

        provider.findDoctors(
          symptoms,
          medicalHistory: medicalHistory?.isNotEmpty == true ? medicalHistory : null,
        );
      } else {
        print('');
        print('⚠️ SKIPPING API CALL - REASON:');
        print('🔹 Doctors already loaded? ${provider.doctors.isNotEmpty}');
        print('🔹 Already loading? ${provider.isLoading}');
        print('🔹 Extra is null? ${widget.extra == null}');
        print('🔹 Symptoms is null? ${widget.extra?['symptoms'] == null}');
        print('═══════════════════════════════════════════════════');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _SystemSuggestingDoctorScreenContent();
  }
}

class _SystemSuggestingDoctorScreenContent extends StatelessWidget {
  const _SystemSuggestingDoctorScreenContent();

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              Center(
                child: Text(
                  "Suggested Doctors",
                  style: TAppTextStyle.inter(
                    fontSize: 22,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Center(
                child: Text(
                  "Based on your symptoms",
                  style: TAppTextStyle.inter(
                    fontSize: 14,
                    weight: FontWeight.w400,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Doctor List, Loading, or Error
              Expanded(
                child: Consumer<DoctorProvider>(
                  builder: (context, provider, child) {
                    // Loading State
                    if (provider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: QColors.newPrimary500,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Finding the best doctors for you...",
                              style: TAppTextStyle.inter(
                                fontSize: 14,
                                weight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Error State
                    if (provider.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Oops! Something went wrong",
                              style: TAppTextStyle.inter(
                                fontSize: 18,
                                weight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                provider.errorMessage ?? "Unknown error occurred",
                                textAlign: TextAlign.center,
                                style: TAppTextStyle.inter(
                                  fontSize: 14,
                                  weight: FontWeight.w400,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                provider.clearError();
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Go Back"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: QColors.newPrimary500,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Empty State
                    if (provider.doctors.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No doctors found",
                              style: TAppTextStyle.inter(
                                fontSize: 18,
                                weight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Try searching with different symptoms",
                              style: TAppTextStyle.inter(
                                fontSize: 14,
                                weight: FontWeight.w400,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Success State - Show Doctor List
                    return Column(
                      children: [
                        // Results count
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Found ${provider.totalCount} doctor${provider.totalCount != 1 ? 's' : ''}",
                            style: TAppTextStyle.inter(
                              fontSize: 14,
                              weight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),

                        // Doctor list
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.doctors.length,
                            itemBuilder: (context, index) {
                              final doctor = provider.doctors[index];
                              // Fix: Ensure consistent type comparison
                              final isSelected = provider.selectedDoctorId == doctor.id.toString();

                              return DoctorCard(
                                doctor: doctor,
                                isSelected: isSelected,
                                isDark: isDark,
                                onTap: () {
                                  // Debug print
                                  print('🔍 Selected doctor ID: ${doctor.id}');
                                  provider.selectDoctor(doctor.id.toString());
                                  print('🔍 Provider selected ID: ${provider.selectedDoctorId}');
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Book Appointment Button
              Consumer<DoctorProvider>(
                builder: (context, provider, child) {
                  // Debug print
                  print('🔍 Button - Selected ID: ${provider.selectedDoctorId}');
                  print('🔍 Button - Doctors count: ${provider.doctors.length}');
                  print('🔍 Button - Is Loading: ${provider.isLoading}');
                  print('🔍 Button - Has Error: ${provider.hasError}');

                  // Don't show button if loading, has error, or no doctor selected
                  if (provider.isLoading ||
                      provider.hasError ||
                      provider.doctors.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Show button but only enable if doctor is selected
                  final bool hasSelection = provider.selectedDoctorId != null;

                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child:  // In SystemSuggestingDoctorScreen, update the Book Appointment button:
                    QButton(
                      text: "Book Appointment",
                      onPressed: hasSelection ? () {
                        print('🔍 Book button pressed');
                        final selectedDoctor = provider.selectedDoctor;
                        print('🔍 Selected doctor: ${selectedDoctor?.fullName}');
                        print('🔍 Selected doctor ID: ${selectedDoctor?.id}');

                        if (selectedDoctor != null) {
                          // Get the extra data from widget
                          final screenExtra = context.findAncestorStateOfType<_SystemSuggestingDoctorScreenState>()?.widget.extra;

                          print('');
                          print('🚀 NAVIGATING TO APPOINTMENT SCREEN:');
                          print('═══════════════════════════════════════════════════');
                          print('🔹 Doctor ID: ${selectedDoctor.id}');
                          print('🔹 Doctor Name: ${selectedDoctor.fullName}');
                          print('🔹 Specialization: ${selectedDoctor.specialization}');
                          print('🔹 location: ${selectedDoctor.location}');
                          print('🔹 location: ${selectedDoctor.longitude}');
                          print('🔹 location: ${selectedDoctor.latitude}');
                          print('🔹 Passing Medical History: ${screenExtra?['medicalHistory']}');
                          print('🔹 Passing Symptoms: ${screenExtra?['symptoms']}');
                          print('═══════════════════════════════════════════════════');

                          context.push(
                            '/selectAppointmentScreen',
                            extra: {
                              'doctor': selectedDoctor,
                              'doctorId': selectedDoctor.id,
                              'doctorName': selectedDoctor.fullName,
                              'specialization': selectedDoctor.specialization,
                              'location': selectedDoctor.location,
                              'email': selectedDoctor.email,
                              'imageUrl': selectedDoctor.imageUrl,
                              'latitude': selectedDoctor.latitude,     // ✅ Add this
                              'longitude': selectedDoctor.longitude,   // ✅ Add this
                              'medicalHistory': screenExtra?['medicalHistory'] ?? '',
                              'symptoms': screenExtra?['symptoms'] ?? '',
                            },
                          );

                          // // // Navigate to appointment selection screen
                          // context.push(
                          //   '/selectAppointmentScreen',
                          //   extra: {
                          //     'doctor': selectedDoctor,
                          //     'doctorId': selectedDoctor.id, // This is the key fix
                          //     'doctorName': selectedDoctor.fullName,
                          //     'specialization': selectedDoctor.specialization,
                          //     'location': selectedDoctor.location,
                          //     'email': selectedDoctor.email,
                          //     'imageUrl': selectedDoctor.imageUrl,
                          //     'medicalHistory': screenExtra?['medicalHistory'] ?? '',
                          //     'symptoms': screenExtra?['symptoms'] ?? '',
                          //   },
                          // );
                        } else {
                          print('❌ Doctor not found in list');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a doctor first'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } : null,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}