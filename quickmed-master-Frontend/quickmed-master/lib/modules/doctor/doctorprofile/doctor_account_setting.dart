import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';
import '../widgets/summary_item.dart';

class DoctorAccountSetting extends StatelessWidget {
  const DoctorAccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                /// BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                SizedBox(height: 20),

                const SizedBox(height: 20),

                /// ACCOUNT SETTINGS
                Text(
                  "Account Settings",
                  style: TAppTextStyle.inter(
                    fontSize: 19,
                    weight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 16),

                SummaryItem(
                  title: 'Security',
                  onTap: () {
                    _showSecurityDialog(context, isDark);
                  },
                ),

                SummaryItem(
                  title: 'Personal Information',
                  onTap: () {
                    _showPersonalInfoDialog(context, isDark);
                  },
                ),

                SummaryItem(
                  title: 'Address',
                  onTap: () {
                    _showAddressDialog(context, isDark);
                  },
                ),

                SummaryItem(
                  title: 'Close Account',
                  onTap: () {
                    _showCloseAccountDialog(context, isDark);
                  },
                ),

                SizedBox(height: 20),

                Text(
                  "QuickMed user since 6 feb 2025",
                  style: TAppTextStyle.inter(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 20,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Security Dialog
  void _showSecurityDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Security Settings',
            style: TAppTextStyle.inter(
              fontSize: 18,
              weight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogOption(
                context,
                isDark,
                Icons.lock_outline,
                'Change Password',
                    () {
                  Navigator.pop(context);
                  // Navigate to change password screen
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.fingerprint,
                'Enable Biometric Login',
                    () {
                  Navigator.pop(context);
                  // Enable biometric
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.phonelink_lock,
                'Two-Factor Authentication',
                    () {
                  Navigator.pop(context);
                  // Setup 2FA
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TAppTextStyle.inter(
                  color: QColors.lightGray800,
                  fontSize: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Personal Information Dialog
  void _showPersonalInfoDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Personal Information',
            style: TAppTextStyle.inter(
              fontSize: 18,
              weight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogOption(
                context,
                isDark,
                Icons.person_outline,
                'Edit Profile',
                    () {
                  Navigator.pop(context);
                  // Navigate to edit profile
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.email_outlined,
                'Change Email',
                    () {
                  Navigator.pop(context);
                  // Change email
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.phone_outlined,
                'Update Phone Number',
                    () {
                  Navigator.pop(context);
                  // Update phone
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TAppTextStyle.inter(
                  color: QColors.lightGray800,
                  fontSize: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Address Dialog
  void _showAddressDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Address Management',
            style: TAppTextStyle.inter(
              fontSize: 18,
              weight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogOption(
                context,
                isDark,
                Icons.home_outlined,
                'View All Addresses',
                    () {
                  Navigator.pop(context);
                  // View addresses
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.add_location_outlined,
                'Add New Address',
                    () {
                  Navigator.pop(context);
                  // Add address
                },
              ),
              SizedBox(height: 12),
              _buildDialogOption(
                context,
                isDark,
                Icons.edit_location_outlined,
                'Edit Primary Address',
                    () {
                  Navigator.pop(context);
                  // Edit primary address
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TAppTextStyle.inter(
                  color: QColors.lightGray800,
                  fontSize: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Close Account Dialog (with confirmation)
  void _showCloseAccountDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Close Account',
                style: TAppTextStyle.inter(
                  fontSize: 18,
                  weight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to close your account? This action cannot be undone and all your data will be permanently deleted.',
            style: TAppTextStyle.inter(
              fontSize: 14,
              weight: FontWeight.w400,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TAppTextStyle.inter(
                  color: QColors.lightGray800,
                  fontSize: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle account closure
                _handleAccountClosure(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Close Account',
                style: TAppTextStyle.inter(
                  color: Colors.white,
                  fontSize: 14,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Helper widget for dialog options
  Widget _buildDialogOption(
      BuildContext context,
      bool isDark,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white70 : Colors.black87,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TAppTextStyle.inter(
                  fontSize: 15,
                  weight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white54 : Colors.black54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Handle account closure
  void _handleAccountClosure(BuildContext context) {
    // Add your account closure logic here
    // For example: API call, clear local data, navigate to login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account closure initiated...'),
        backgroundColor: Colors.red,
      ),
    );
  }
}