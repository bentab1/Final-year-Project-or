import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quickmed/modules/provider/DoctorProvider.dart';
import 'package:quickmed/modules/provider/LoginProvider.dart';

import 'core/di/InjectionContainer.dart';
import 'modules/provider/BookingProvider.dart';
import 'modules/provider/SignUpProvider.dart';

/// Centralized provider configuration
/// This class manages all app providers in one place
class AppProviders {
  /// Returns a list of all providers for the app
  /// Note: InjectionContainer must be initialized before calling this
  static List<SingleChildWidget> getProviders() {
    final di = InjectionContainer();

    return [
      // SignUp Provider
      ChangeNotifierProvider<SignUpProvider>.value(
        value: di.signUpProvider,
      ),
      ChangeNotifierProvider<LoginProvider>.value(
        value: di.loginProvider,
      ),
      ChangeNotifierProvider<DoctorProvider>.value(
        value: di.doctorProvider,
      ),      ChangeNotifierProvider<BookingProvider>.value(
        value: di.bookingProvider,
      ),

      // Add more providers here as your app grows
      // Example:
      // ChangeNotifierProvider<LoginProvider>.value(
      //   value: di.loginProvider,
      // ),
      // ChangeNotifierProvider<ProfileProvider>.value(
      //   value: di.profileProvider,
      // ),
      // ChangeNotifierProvider<AppointmentProvider>.value(
      //   value: di.appointmentProvider,
      // ),
    ];
  }

  /// Alternative: Returns MultiProvider widget directly
  /// Use this if you want to wrap your entire app
  static Widget wrapWithProviders({required Widget child}) {
    return MultiProvider(
      providers: getProviders(),
      child: child,
    );
  }
}