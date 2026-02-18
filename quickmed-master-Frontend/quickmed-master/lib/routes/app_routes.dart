import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmed/SimpleMapTestScreen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/chat_doctor_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/chat_doctor_select_appointment_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_account_setting_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_appointment_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_dashboard_screen.dart';
import 'package:quickmed/modules/patient/dashboard/screens/patient_profile_screen.dart';
import 'package:quickmed/modules/patient/appointment/book_appointment_screen.dart'
    hide SystemSuggestingDoctorScreen;
import 'package:quickmed/routes/routes.dart';
import '../MapScreen.dart';
import '../core/global.dart';
import '../modules/patient/appointment/appointment_success_screen.dart';
import '../modules/patient/appointment/no_available_doctor_screen.dart';
import '../modules/patient/appointment/select_appointment_screen.dart';
import '../modules/patient/appointment/suggested_doctor_screen.dart';
import '../modules/patient/appointment/system_suggesting_doctor_screen.dart';
import '../modules/patient/dashboard/screens/DirectionOptionsScreen.dart';
import '../modules/patient/dashboard/screens/ViewAllAppointmentsScreen.dart';
import '../modules/patient/notification/notification_screen.dart';
import '../modules/doctor/acceptappointment/accept_appointment.dart';
import '../modules/doctor/appointmentaccepted/appointment_accepted_screen.dart';
import '../modules/doctor/dashboard/dash_board_screen.dart';
import '../modules/doctor/doctorappointment/doctor_appointment_screen.dart';
import '../modules/doctor/doctorappointmentdetail/doctor_appointment_screen.dart';
import '../modules/doctor/doctormap/get_direction_screen.dart';
import '../modules/doctor/doctorprofile/doctor_account_setting.dart';
import '../modules/doctor/doctorprofile/doctor_profile_screen.dart';
import '../modules/doctor/rejectappointment/appointment_rejected_screen.dart';
import '../modules/doctor/rejectappointment/reject_appointment_screen.dart';
import '../modules/doctor/updateavailabilitycal/availability_updated_screen.dart';
import '../modules/doctor/updateavailabilitycal/update_availability_screen.dart';
import '../modules/shared/error/general_error_screen.dart';
import '../modules/shared/forget_password_screen/forget_password_screen.dart';
import '../modules/shared/login/login_screen.dart';
import '../modules/shared/otp/otp_verification_screen.dart';
import '../modules/shared/signup/signup_screen.dart';
import '../modules/shared/splash/splash_screen.dart';
import '../modules/shared/success_screen/account_creation_success_screen.dart';
import '../navigatyion.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splashScreen',
    routes: [
      GoRoute(
        path: '/splashScreen',
        name: Routes.splashScreen.name,
        builder: (context, state) => SplashScreen(),
      ),        GoRoute(
        path: '/mapScreen',
        name: Routes.mapScreen.name,
        builder: (context, state) => MapScreen(),
      ),      GoRoute(
        path: '/simpleMapTestScreen',
        name: Routes.simpleMapTestScreen.name,
        builder: (context, state) => SimpleMapTestScreen(),
      ),
      GoRoute(
        path: '/doctorBottomNavScreen',
        name: Routes.doctorBottomNavScreen.name,
        builder: (context, state) => DoctorBottomNavScreen(),
      ),
      GoRoute(
        path: '/patientBottomNavScreen',
        name: Routes.patientBottomNavScreen.name,
        builder: (context, state) => PatientBottomNavScreen(),
      ),

      GoRoute(
        path: '/loginScreen',
        name: Routes.loginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgotPasswordScreen',
        name: Routes.forgotPasswordScreen.name,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/bookAppointmentScreen',
        name: Routes.bookAppointmentScreen.name,
        builder: (context, state) => const BookAppointmentScreen(),
      ),
      // FIXED ROUTE CONFIGURATION
      GoRoute(
        path: '/systemSuggestingDoctorScreen',
        name: Routes.systemSuggestingDoctorScreen.name,
        builder: (context, state) {
          // Extract the extra data from state
          final extra = state.extra as Map<String, dynamic>?;

          // Add logging to verify data is received in route
          print('═══════════════════════════════════════════════════');
          print('🛣️ ROUTE: systemSuggestingDoctorScreen');
          print('═══════════════════════════════════════════════════');
          print('🔹 Extra data received: $extra');
          if (extra != null) {
            print('🔹 Medical History: ${extra['medicalHistory']}');
            print('🔹 Symptoms: ${extra['symptoms']}');
          }
          print('═══════════════════════════════════════════════════');

          // Pass the extra data to the widget
          return SystemSuggestingDoctorScreen(extra: extra);
        },
      ),
      GoRoute(
        path: '/directionOptions',
        builder: (context, state) {
          final locationData = state.extra as Map<String, dynamic>?;
          return DirectionOptionsScreen(locationData: locationData);
        },
      ),
      GoRoute(
        path: '/getDirection',
        builder: (context, state) {
          final locationData = state.extra as Map<String, dynamic>?;
          return GetDirectionScreen(locationData: locationData);
        },
      ),
      GoRoute(
        path: '/directionOptions',
        builder: (context, state) {
          final locationData = state.extra as Map<String, dynamic>?;
          return DirectionOptionsScreen(locationData: locationData);
        },
      ),
      GoRoute(
        path: '/getDirectionScreen',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return GetDirectionScreen(
            locationData: extra,
          );
        },
      ),
      GoRoute(
        path: '/viewAllAppointments',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ViewAllAppointmentsScreen(
            filterType: extra?['filterType'],
          );
        },
      ),
      // GoRoute(
      //   path: '/systemSuggestingDoctorScreen',
      //   name: Routes.systemSuggestingDoctorScreen.name,
      //   builder: (context, state) => const SystemSuggestingDoctorScreen(),
      // ),
      GoRoute(
        path: '/noAvailableDoctorScreen',
        name: Routes.noAvailableDoctorScreen.name,
        builder: (context, state) => const NoAvailableDoctorScreen(),
      ),
      GoRoute(
        path: '/suggestedDoctorScreen',
        name: Routes.suggestedDoctorScreen.name,
        builder: (context, state) => const SuggestedDoctorScreen(),
      ),
      // In your router file (app_routes.dart or wherever your routes are defined)
      GoRoute(
        path: '/selectAppointmentScreen',
        builder: (context, state) {
          print('🔍 Route extra data: ${state.extra}');
          return SelectAppointmentScreen(
            doctorData: state.extra as Map<String, dynamic>?,
          );
        },
      ),
      // GoRoute(
      //   path: '/selectAppointmentScreen',
      //   name: Routes.selectAppointmentScreen.name,
      //   builder: (context, state) => const SelectAppointmentScreen(),
      // ),
      GoRoute(
        path: '/appointmentSuccessScreen',
        name: Routes.appointmentSuccessScreen.name,
        builder: (context, state) => const AppointmentSuccessScreen(),
      ),
      GoRoute(
        path: '/signUpScreen',
        name: Routes.signUpScreen.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/oTPVerificationScreen',
        name: Routes.oTPVerificationScreen.name,
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: '/notificationScreen',
        name: Routes.notificationScreen.name,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/accountCreationSuccessScreen',
        name: Routes.accountCreationSuccessScreen.name,
        builder: (context, state) => const AccountCreationSuccessScreen(),
      ),
      GoRoute(
        path: '/patientDashboardScreen',
        name: Routes.patientDashboardScreen.name,
        builder: (context, state) => const PatientDashboardScreen(),
      ),
      GoRoute(
        path: '/patientProfileScreen',
        name: Routes.patientProfileScreen.name,
        builder: (context, state) => const PatientProfileScreen(),
      ),
      GoRoute(
        path: '/appointmentSuccessScreen',
        builder: (context, state) {
          print('🔍 Route state.extra: ${state.extra}');
          print('🔍 Extra type: ${state.extra.runtimeType}');

          final extra = state.extra as Map<String, dynamic>?;
          return AppointmentSuccessScreen(
            bookingData: extra,
          );
        },
      ),
      GoRoute(
        path: '/patientAccountSettingScreen',
        name: Routes.patientAccountSettingScreen.name,
        builder: (context, state) => const PatientAccountSettingScreen(),
      ),
      GoRoute(
        path: '/patientAppointmentScreen',
        name: Routes.patientAppointmentScreen.name,
        builder: (context, state) => const PatientAppointmentScreen(),
      ),
      GoRoute(
        path: '/chatDoctorScreen',
        name: Routes.chatDoctorScreen.name,
        builder: (context, state) => const ChatDoctorScreen(),
      ),
      GoRoute(
        path: '/chatDoctorSelectAppointmentScreen',
        name: Routes.chatDoctorSelectAppointmentScreen.name,
        builder: (context, state) => const ChatDoctorSelectAppointmentScreen(),
      ),
      GoRoute(
        path: '/dashBoardScreen',
        name: Routes.dashBoardScreen.name,
        builder: (context, state) => const DashBoardScreen(),
      ),
      GoRoute(
        path: '/doctorProfileScreen',
        name: Routes.doctorProfileScreen.name,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        path: '/doctorAccountSetting',
        name: Routes.doctorAccountSetting.name,
        builder: (context, state) => const DoctorAccountSetting(),
      ),
      GoRoute(
        path: '/doctorAppointments',
        name: Routes.doctorAppointments.name,
        builder: (context, state) => const DoctorAppointments(),
      ),
      GoRoute(
        path: '/DoctorAppointmentScreen',
        name: Routes.DoctorAppointmentScreen.name,
        builder: (context, state) => const DoctorAppointmentScreen(),
      ),
      GoRoute(
        path: '/acceptAppointment',
        name: Routes.acceptAppointment.name,
        builder: (context, state) => const AcceptAppointment(),
      ),
      GoRoute(
        path: '/appointmentAcceptedScreen',
        name: Routes.appointmentAcceptedScreen.name,
        builder: (context, state) => const AppointmentAcceptedScreen(),
      ),
      GoRoute(
        path: '/rejectAppointment',
        name: Routes.rejectAppointmentScreen.name,
        builder: (context, state) => const RejectAppointmentScreen(),
      ),
      GoRoute(
        path: '/updateAvailabilityScreen',
        name: Routes.updateAvailabilityScreen.name,
        builder: (context, state) => const UpdateAvailabilityScreen(),
      ),
      GoRoute(
        path: '/availabilityUpdatedScreen',
        name: Routes.availabilityUpdatedScreen.name,
        builder: (context, state) => const AvailabilityUpdatedScreen(),
      ),
      GoRoute(
        path: '/appointmentRejectedScreen',
        name: Routes.appointmentRejectedScreen.name,
        builder: (context, state) => const AppointmentRejectedScreen(),
      ),
      GoRoute(
        path: '/getDirectionScreen',
        name: Routes.getDirectionScreen.name,
        builder: (context, state) => const GetDirectionScreen(),
      ),
      GoRoute(
        path: '/generalErrorScreen',
        name: Routes.generalErrorScreen.name,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;

          return GeneralErrorScreen(
            title: data?['title'] ?? "Error",
            message: data?['message'] ?? "Something went wrong.",
            icon: data?['icon'] ?? Icons.error_outline,
            buttonText: data?['buttonText'] ?? "Retry",
            onRetry: data?['onRetry'] ?? () {},
          );
        },
      ),
    ],
  );
}
