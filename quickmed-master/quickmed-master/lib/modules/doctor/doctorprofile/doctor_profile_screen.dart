import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:quickmed/utils/widgets/TButton.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/image_path.dart';
import '../../../utils/sizes.dart';
import '../../provider/LoginProvider.dart';
import '../widgets/summary_item.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  Map<String, String?> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    final data = await loginProvider.getUserData();

    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  String get fullName {
    final firstName = userData['first_name'] ?? '';
    final lastName = userData['last_name'] ?? '';
    if (firstName.isEmpty && lastName.isEmpty) {
      return userData['username'] ?? 'User';
    }
    return '$firstName $lastName'.trim();
  }

  Future<void> _handleLogout() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Perform logout
      await loginProvider.logout();

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Navigate to login screen and clear navigation stack
      if (mounted) {
        AppRouter.router.go('/loginScreen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: QSizes.md,
                    vertical: QSizes.md,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: QSizes.fontSizeXESm),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(QImagesPath.profile),
                          child: Text(
                            fullName.isNotEmpty
                                ? fullName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Welcome $fullName',
                        style: TAppTextStyle.inter(
                          color: QColors.newPrimary700,
                          fontSize: 20,
                          weight: FontWeight.w700,
                        ),
                      ),
                      if (userData['email']?.isNotEmpty == true) ...[
                        SizedBox(height: 5),
                        Text(
                          userData['email']!,
                          style: TAppTextStyle.inter(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                      SizedBox(height: 25),
                      SummaryItem(
                        title: 'Specialization',
                        value: userData['user_type'] ?? 'Doctor',
                      ),
                      SummaryItem(title: 'Experience'),
                      SummaryItem(title: 'Location', value: _buildLocation()),
                      SummaryItem(title: 'My Bio'),
                      SummaryItem(title: 'My Rating'),
                      SummaryItem(title: 'Privacy'),
                      SummaryItem(title: 'Follow'),
                      SummaryItem(title: 'Chat Patient'),
                      SummaryItem(
                        title: 'Account Settings',
                        onTap: () {
                          AppRouter.router.push('/doctorAccountSetting');
                        },
                      ),

                      QButton(
                        text: 'Log Out',
                        onPressed: _handleLogout,
                        borderColor: Colors.red,
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "1.0 QuickMed",
                        style: TAppTextStyle.inter(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 18,
                          weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  String? _buildLocation() {
    List<String> locationParts = [];

    if (userData['city']?.isNotEmpty == true) {
      locationParts.add(userData['city']!);
    }
    if (userData['state']?.isNotEmpty == true) {
      locationParts.add(userData['state']!);
    }
    if (userData['country']?.isNotEmpty == true) {
      locationParts.add(userData['country']!);
    }

    return locationParts.isNotEmpty ? locationParts.join(', ') : null;
  }
}
