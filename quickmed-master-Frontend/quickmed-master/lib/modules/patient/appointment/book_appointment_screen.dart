

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../../../utils/widgets/TButton.dart';
import '../../../utils/widgets/text_input_widget.dart';
import '../../provider/DoctorProvider.dart';
import '../dashboard/widgets/profile_pic.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController historyController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    historyController.dispose();
    symptomsController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    // Validate that symptoms are entered
    if (symptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your current symptoms'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final doctorProvider = context.read<DoctorProvider>();

      print('═══════════════════════════════════════════════════');
      print('📤 PREPARING TO SEND DATA:');
      print('═══════════════════════════════════════════════════');
      print('🔹 Symptoms: ${symptomsController.text.trim()}');
      print('🔹 Medical History: ${historyController.text.trim()}');
      print('🔹 Medical History is empty? ${historyController.text.trim().isEmpty}');
      print('═══════════════════════════════════════════════════');

      // Clear previous search results
      doctorProvider.clearSearch();

      // Find doctors based on symptoms and medical history
      await doctorProvider.findDoctors(
        symptomsController.text.trim(),
        medicalHistory: historyController.text.trim().isNotEmpty
            ? historyController.text.trim()
            : null,
      );

      if (!mounted) return;

      print('');
      print('📊 API CALL COMPLETED:');
      print('═══════════════════════════════════════════════════');
      print('🔹 Has Error: ${doctorProvider.hasError}');
      print('🔹 Error Message: ${doctorProvider.errorMessage}');
      print('🔹 Doctors Count: ${doctorProvider.doctors.length}');
      print('═══════════════════════════════════════════════════');

      // Check the result and navigate accordingly
      if (doctorProvider.hasError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(doctorProvider.errorMessage ?? 'Failed to find doctors'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (doctorProvider.doctors.isEmpty) {
        print('❌ No doctors found - navigating to no available doctor screen');
        // No doctors found - navigate to no available doctor screen
        context.push('/noAvailableDoctorScreen');
      } else {
        // Prepare the data to send
        final dataToSend = {
          'medicalHistory': historyController.text.trim(),
          'symptoms': symptomsController.text.trim(),
        };

        print('');
        print('🚀 NAVIGATING TO SYSTEM SUGGESTING DOCTOR SCREEN:');
        print('═══════════════════════════════════════════════════');
        print('🔹 Data being sent: $dataToSend');
        print('🔹 Medical History value: ${dataToSend['medicalHistory']}');
        print('🔹 Symptoms value: ${dataToSend['symptoms']}');
        print('═══════════════════════════════════════════════════');

        // Doctors found - navigate to system suggesting doctor screen
        // FIXED: Use context.push instead of AppRouter.router.push
        context.push(
          '/systemSuggestingDoctorScreen',
          extra: dataToSend,
        );

        print('✅ Navigation triggered successfully');
      }
    } catch (e) {
      print('❌ ERROR OCCURRED: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

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
              /// Top Bar
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfilePic(
                    imagePath: QImagesPath.profileImg,
                    onTap: () => context.push('/patientProfileScreen'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          context.push('/notificationScreen');
                        },
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: QColors.newPrimary500,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// Title
              Center(
                child: Text(
                  "Book Appointment",
                  style: TAppTextStyle.inter(
                    fontSize: 20,
                    weight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Medical History Input
              TextInputWidget(
                controller: historyController,
                headerText: "Enter Your Medical History (optional)",
                hintText: "e.g. Hypertension, Diabetes",
                dark: isDark,
                fillColor: Colors.transparent,

              ),

              const SizedBox(height: 30),

              /// Symptoms Input
              TextInputWidget(
                controller: symptomsController,
                headerText: "Enter Current Symptoms*",
                hintText: "e.g. Cough, Chest pain, Head ache etc",
                dark: isDark,
                fillColor: Colors.transparent,
              ),

              Spacer(),

              /// Continue button with loading state
              QButton(
                text: _isSearching ? "Searching..." : "Continue",
                onPressed: _isSearching ? null : _handleContinue,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}