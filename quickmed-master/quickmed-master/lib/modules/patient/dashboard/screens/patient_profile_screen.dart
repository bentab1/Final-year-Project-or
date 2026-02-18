import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/custom_back_button.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/heading_text.dart';
import 'package:quickmed/modules/patient/dashboard/widgets/profile_pic.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import '../../../../data/models/models/user.dart';
import '../../../provider/LoginProvider.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  UserData? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    try {
      // ✅ Get the UserData object (not bool)
      final userData = await loginProvider.getCachedUserProfile();

      print('✅ User data loaded: ${userData?.fullName}');

      if (mounted) {
        setState(() {
          _userData = userData; // ⬅️ Set the user data
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      await loginProvider.logout();

      if (mounted) {
        context.go('/loginScreen');
      }
    }
  }

  /// Get display name
  String _getDisplayName() {
    if (_userData == null) return 'User';

    // Use the fullName getter from UserData
    final fullName = _userData!.fullName;

    if (fullName.isNotEmpty && fullName != ' ') {
      return fullName;
    }

    return _userData!.username;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const CustomBackButton(),
                const SizedBox(height: 20),
                Center(
                  child: ProfilePic(
                    imagePath: QImagesPath.profileImg,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 10),

                /// ---------------- WELCOME HEADING ---------------- ///
                HeadingText(
                  text: "Welcome ${_getDisplayName()}",
                  textColor: QColors.newPrimary500,
                ),

                /// Email if available
                if (_userData?.email != null &&
                    _userData!.email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _userData!.email,
                    style: TAppTextStyle.inter(
                      color: isDark
                          ? Colors.white70
                          : Colors.grey.shade600,
                      fontSize: 14,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                /// ---------------- SETTING BUTTONS ---------------- ///
                QButton(
                  text: "Medical History",
                  buttonType: QButtonType.social,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Rate Appointment",
                  buttonType: QButtonType.social,
                  onPressed: () =>
                      context.push('/patientAppointmentScreen'),
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "My Bio",
                  buttonType: QButtonType.social,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Privacy",
                  buttonType: QButtonType.social,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Follow",
                  buttonType: QButtonType.social,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Chat Doctor",
                  buttonType: QButtonType.social,
                  onPressed: () =>
                      context.push('/chatDoctorSelectAppointmentScreen'),
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Account Settings",
                  buttonType: QButtonType.social,
                  onPressed: () =>
                      context.push('/patientAccountSettingScreen'),
                ),
                const SizedBox(height: 10),
                QButton(
                  text: "Log Out",
                  buttonType: QButtonType.secondary,
                  onPressed: _handleLogout,
                ),

                /// ---------------- SETTING BUTTONS ---------------- ///
                const SizedBox(height: 110),
                Center(
                  child: Text(
                    "1.0 QuickMed",
                    style: TAppTextStyle.inter(
                      color: isDark
                          ? QColors.lightBackground
                          : Colors.black,
                      fontSize: 20,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}