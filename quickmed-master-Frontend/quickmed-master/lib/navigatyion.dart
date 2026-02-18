import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickmed/modules/doctor/dashboard/dash_board_screen.dart';
import 'package:quickmed/modules/doctor/doctorappointment/doctor_appointment_screen.dart';
import 'package:quickmed/modules/doctor/doctorappointmentdetail/doctor_appointment_screen.dart';
import 'package:quickmed/modules/doctor/updateavailabilitycal/update_availability_screen.dart';
import 'package:quickmed/modules/patient/appointment/book_appointment_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_dashboard_screen.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/image_path.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';

import 'modules/patient/dashboard/screens/appointment_screen.dart';

class CommonBottomNavScreen extends StatefulWidget {
  final List<Widget> screens;
  final List<NavigationDestination> navItems;
  final int initialIndex;

  const CommonBottomNavScreen({
    super.key,
    required this.screens,
    required this.navItems,
    this.initialIndex = 0,
  });

  @override
  _CommonBottomNavScreenState createState() => _CommonBottomNavScreenState();
}

class _CommonBottomNavScreenState extends State<CommonBottomNavScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    // Unfocus any text field when switching tabs
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // This prevents the bottom nav from being hidden
      body: IndexedStack(index: _selectedIndex, children: widget.screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: isDark
                ? QColors.darkBackground
                : QColors.lightBackground,
            surfaceTintColor: Colors.transparent,
            shadowColor: isDark
                ? Colors.transparent
                : Colors.black.withOpacity(0.1),
            elevation: isDark ? 0 : 8,
            indicatorColor: isDark
                ? QColors.newPrimary500.withOpacity(0.2)
                : QColors.newPrimary100,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return TAppTextStyle.inter(
                  color: isDark ? QColors.newPrimary500 : QColors.newPrimary600,
                  fontSize: 10.0,
                  weight: FontWeight.w600,
                );
              }
              return TAppTextStyle.inter(
                color: isDark
                    ? QColors.darkTextTertiary
                    : QColors.lightTextSecondary,
                fontSize: 10.0,
                weight: FontWeight.w400,
              );
            }),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? QColors.darkGray700 : QColors.lightGray200,
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            height: 60,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index >= 0 && index < widget.screens.length) {
                _onItemTapped(index);
              }
            },
            destinations: widget.navItems.map((item) {
              return NavigationDestination(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: item.icon,
                ),
                selectedIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: item.selectedIcon,
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
//
// class CommonBottomNavScreen extends StatefulWidget {
//   final List<Widget> screens;
//   final List<NavigationDestination> navItems;
//   final int initialIndex;
//
//   const CommonBottomNavScreen({
//     super.key,
//     required this.screens,
//     required this.navItems,
//     this.initialIndex = 0,
//   });
//
//   @override
//   _CommonBottomNavScreenState createState() => _CommonBottomNavScreenState();
// }
//
// class _CommonBottomNavScreenState extends State<CommonBottomNavScreen> {
//   late int _selectedIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = TDeviceUtils.isDarkMode(context);
//
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: widget.screens,
//       ),
//       bottomNavigationBar: Theme(
//         data: Theme.of(context).copyWith(
//           navigationBarTheme: NavigationBarThemeData(
//             backgroundColor: isDark ? QColors.darkBackground : QColors.lightBackground,
//             surfaceTintColor: Colors.transparent,
//             shadowColor: isDark ? Colors.transparent : Colors.black.withOpacity(0.1),
//             elevation: isDark ? 0 : 8,
//             indicatorColor: isDark
//                 ? QColors.newPrimary500.withOpacity(0.2)
//                 : QColors.newPrimary100,
//             indicatorShape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
//                   (Set<WidgetState> states) {
//                 if (states.contains(WidgetState.selected)) {
//                   return TAppTextStyle.inter(
//                     color: isDark ? QColors.newPrimary500 : QColors.newPrimary600,
//                     fontSize: 10.0,
//                     weight: FontWeight.w600,
//                   );
//                 }
//                 return TAppTextStyle.inter(
//                   color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
//                   fontSize: 10.0,
//                   weight: FontWeight.w400,
//                 );
//               },
//             ),
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: isDark ? QColors.darkGray700 : QColors.lightGray200,
//                 width: 1,
//               ),
//             ),
//           ),
//           child: NavigationBar(
//             height: 60, // Reduced from 70 to 60
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: (index) {
//               if (index >= 0 && index < widget.screens.length) {
//                 _onItemTapped(index);
//               }
//             },
//             destinations: widget.navItems.map((item) {
//               return NavigationDestination(
//                 icon: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 1.0), // Reduced padding
//                   child: item.icon,
//                 ),
//                 selectedIcon: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 1.0), // Reduced padding
//                   child: item.selectedIcon,
//                 ),
//                 label: item.label,
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Navigation configurations for Barber and Customer roles
class NavConfig {
  // Barber Navigation
  static List<NavigationDestination> barberNavItems(bool isDark) => [
    NavigationDestination(
      icon: Image.asset(
        QImagesPath.home,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.home,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Home',
    ),

    NavigationDestination(
      icon: Image.asset(
        QImagesPath.appointment,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.appointment,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Appointment',
    ),
    NavigationDestination(
      icon: Image.asset(
        QImagesPath.booking,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.booking,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Update Availability',
    ),
  ];

  // Customer Navigation
  static List<NavigationDestination> customerNavItems(bool isDark) => [
    NavigationDestination(
      icon: Image.asset(
        QImagesPath.home,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.home,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Home',
    ),

    NavigationDestination(
      icon: Image.asset(
        QImagesPath.appointment,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.appointment,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Appointment',
    ),
    NavigationDestination(
      icon: Image.asset(
        QImagesPath.booking,
        color: isDark ? QColors.darkTextTertiary : QColors.lightTextSecondary,
        width: 24,
        height: 24,
      ),
      selectedIcon: Image.asset(
        QImagesPath.booking,
        color: QColors.newPrimary500,
        width: 24,
        height: 24,
      ),
      label: 'Book Appointment',
    ),
  ];
}

// Barber Bottom Navigation Screen
class DoctorBottomNavScreen extends StatelessWidget {
  const DoctorBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return CommonBottomNavScreen(
      screens: [
        DashBoardScreen(),
        DoctorAppointments(),
        UpdateAvailabilityScreen(),
        // CalendarBookingScreen(),
        // ClientsScreen(),
        // MessagesScreen(),
        // MarketingScreen(),
        // BarberProfileScreen(),
      ],
      navItems: NavConfig.barberNavItems(isDark),
    );
  }
}

// Customer Bottom Navigation Screen
class PatientBottomNavScreen extends StatelessWidget {
  const PatientBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return CommonBottomNavScreen(
      screens: [
        PatientDashboardScreen(),
        AppointmentScreen(),
        BookAppointmentScreen(),
      ],
      navItems: NavConfig.customerNavItems(isDark),
    );
  }
}
