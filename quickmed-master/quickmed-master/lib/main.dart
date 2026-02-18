import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/core/endpoint/api_endpoints.dart';
import 'package:quickmed/routes/app_routes.dart';
import 'package:quickmed/utils/theme/themes.dart';

import 'app_provider.dart';
import 'core/di/InjectionContainer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final di = InjectionContainer();
  await di.init(baseUrl: ApiEndpoints.baseUrl);
  testServer();
  try {
    await testRegisterApi();
  } catch (e) {
    print('❌ Registration test failed: $e');
  }
  runApp(const MyApp());
}




/// Test if server is reachable
Future<void> testServer() async {
  const String baseUrl = 'http://178.128.3.110/api';
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  try {
    final response = await dio.get('/');
    print('✅ Server is up! Status: ${response.statusCode}');
  } on DioException catch (e) {
    print('❌ Server test failed: ${e.message}');
  } catch (e) {
    print('❌ Unexpected error: $e');
  }
}

/// Test registration API
Future<void> testRegisterApi() async {
  const String baseUrl = 'http://178.128.3.110/api';
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  final request = {
    "user_type": "doctor",
    "first_name": "Martha",
    "last_name": "Chinasa",
    "username":"mar1StWS2ha1",
    "email": "mar2thaWSS11@gmail.com",
    "password": "yourpassword123",
    "dob": "1997-11-21",
    "gender": "male",
    "address": "abc",
    "city": "abc",
    "state": "gb",
    "zipCode": "12345",
    "country": "abc",
    "specialization" : "SICK",
    "specializationIllnessSymptoms":"[CAUGHT , SICK , HJ-SDF]",
  };

  try {
    print('📝 Sending registration request...');
    final response = await dio.post(
      '/auth/register/',
      data: jsonEncode(request),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => true, // Handle all status codes manually
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Registration success: ${response.data}');
    } else {
      print('❌ Registration failed: ${response.statusCode}');
      print('❌ Response data: ${response.data}');
    }
  } on DioException catch (e) {
    print('❌ DioException: ${e.message}');
    print('❌ Response data: ${e.response?.data}');
  } catch (e) {
    print('❌ Unexpected error: $e');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Your App Name',

        // Apply custom themes
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Connect GoRouter
        routerConfig: AppRouter.router,
      ),
    );
  }


}



// import 'package:flutter/material.dart';
// import 'MapScreen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Map Search App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const MapScreen(),
//     );
//   }
// }