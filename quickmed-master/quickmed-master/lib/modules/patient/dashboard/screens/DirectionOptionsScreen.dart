// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quickmed/utils/app_text_style.dart';
// import 'package:quickmed/utils/device_utility.dart';
// import 'package:quickmed/utils/theme/colors/q_color.dart';
// import 'package:quickmed/utils/widgets/TButton.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class DirectionOptionsScreen extends StatelessWidget {
//   final Map<String, dynamic>? locationData;
//
//   const DirectionOptionsScreen({
//     super.key,
//     this.locationData,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = TDeviceUtils.isDarkMode(context);
//
//     // Enhanced logging
//     print('═══════════════════════════════════════════');
//     print('📍 DirectionOptionsScreen - Data Received');
//     print('═══════════════════════════════════════════');
//     print('Full locationData: $locationData');
//     print('-------------------------------------------');
//     print('Latitude: ${locationData?['doctorLatitude']}');
//     print('Longitude: ${locationData?['doctorLongitude']}');
//     print('Location: ${locationData?['location']}');
//     print('Doctor Name: ${locationData?['doctorName']}');
//     print('Specialization: ${locationData?['specialization']}');
//     print('═══════════════════════════════════════════');
//
//     // Validate data
//     if (locationData == null) {
//       print('❌ ERROR: locationData is null!');
//     } else if (locationData!['latitude'] == null || locationData!['longitude'] == null) {
//       print('❌ ERROR: latitude or longitude is null!');
//       print('   Latitude: ${locationData!['latitude']}');
//       print('   Longitude: ${locationData!['longitude']}');
//     } else {
//       print('✅ Location data is valid');
//     }
//
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           child: Column(
//             children: [
//               // Back Button
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   onTap: () => context.pop(),
//                   child: Row(
//                     children: [
//                       Icon(Icons.arrow_back,
//                           color: isDark ? Colors.white : Colors.black),
//                       const SizedBox(width: 6),
//                       Text(
//                         "Go Back",
//                         style: TAppTextStyle.inter(
//                           color: isDark ? Colors.white : QColors.lightGray800,
//                           fontSize: 16,
//                           weight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Title
//               Text(
//                 "Choose Direction Option",
//                 style: TAppTextStyle.inter(
//                   weight: FontWeight.w700,
//                   color: isDark ? Colors.white : Colors.black,
//                   fontSize: 24,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Show location info if available
//               if (locationData != null) ...[
//                 Text(
//                   "📍 ${locationData!['location'] ?? 'Location'}",
//                   style: TAppTextStyle.inter(
//                     color: isDark ? Colors.white70 : Colors.grey.shade600,
//                     fontSize: 14,
//                     weight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Lat: ${locationData!['latitude']}, Lng: ${locationData!['longitude']}",
//                   style: TAppTextStyle.inter(
//                     color: isDark ? Colors.white60 : Colors.grey.shade500,
//                     fontSize: 12,
//                     weight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 10),
//
//               Text(
//                 "Select how you want to get directions",
//                 style: TAppTextStyle.inter(
//                   color: isDark ? Colors.white70 : Colors.grey.shade600,
//                   fontSize: 14,
//                   weight: FontWeight.w400,
//                 ),
//               ),
//
//               const SizedBox(height: 40),
//
//               // Options
//               Expanded(
//                 child: Column(
//                   children: [
//                     // Option 1: In-App Map
//                     _buildOptionCard(
//                       context: context,
//                       isDark: isDark,
//                       icon: Icons.map,
//                       title: "In-App Navigation",
//                       description: "View directions within the app with map preview",
//                       color: Colors.blue,
//                       onTap: () {
//                         final dataWithRole = {
//                           ...?locationData,       // spread existing locationData
//                           'userRole': 'doctor',   // inject role
//                         };
//                         context.push('/getDirection', extra: dataWithRole);
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Option 2: Google Maps
//                     _buildOptionCard(
//                       context: context,
//                       isDark: isDark,
//                       icon: Icons.map_outlined,
//                       title: "Google Maps",
//                       description: "Open in Google Maps for turn-by-turn navigation",
//                       color: Colors.green,
//                       onTap: () {
//                         _openGoogleMaps(context);
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Option 3: Other Maps
//                     _buildOptionCard(
//                       context: context,
//                       isDark: isDark,
//                       icon: Icons.share_location,
//                       title: "Other Map Apps",
//                       description: "Choose from available map applications",
//                       color: Colors.orange,
//                       onTap: () {
//                         _openOtherMaps(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionCard({
//     required BuildContext context,
//     required bool isDark,
//     required IconData icon,
//     required String title,
//     required String description,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//             width: 1.5,
//           ),
//           color: isDark ? Colors.grey.shade800 : Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 size: 32,
//                 color: color,
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Text content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TAppTextStyle.inter(
//                       fontSize: 18,
//                       weight: FontWeight.w600,
//                       color: isDark ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     description,
//                     style: TAppTextStyle.inter(
//                       fontSize: 13,
//                       weight: FontWeight.w400,
//                       color: isDark ? Colors.white70 : Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Arrow icon
//             Icon(
//               Icons.arrow_forward_ios,
//               size: 18,
//               color: isDark ? Colors.white54 : Colors.grey.shade400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _openGoogleMaps(BuildContext context) async {
//     final latitude = locationData?['latitude'];
//     final longitude = locationData?['longitude'];
//
//     print('🗺️ Opening Google Maps');
//     print('   Latitude: $latitude');
//     print('   Longitude: $longitude');
//
//     if (latitude == null || longitude == null) {
//       print('❌ ERROR: Coordinates are null');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location coordinates not available'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final url = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
//     );
//
//     print('🔗 URL: $url');
//
//     try {
//       final canLaunch = await canLaunchUrl(url);
//       if (canLaunch) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//         print('✅ Google Maps opened successfully');
//       } else {
//         throw 'Could not launch Google Maps';
//       }
//     } catch (e) {
//       print('❌ ERROR: $e');
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error opening Google Maps: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   void _openOtherMaps(BuildContext context) async {
//     final latitude = locationData?['latitude'];
//     final longitude = locationData?['longitude'];
//
//     print('🗺️ Opening Other Maps');
//     print('   Latitude: $latitude');
//     print('   Longitude: $longitude');
//
//     if (latitude == null || longitude == null) {
//       print('❌ ERROR: Coordinates are null');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location coordinates not available'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final url = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
//
//     print('🔗 URL: $url');
//
//     try {
//       final canLaunch = await canLaunchUrl(url);
//       if (canLaunch) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//         print('✅ Map app opened successfully');
//       } else {
//         final webUrl = Uri.parse(
//           'https://maps.google.com/?q=$latitude,$longitude',
//         );
//         await launchUrl(webUrl, mode: LaunchMode.externalApplication);
//       }
//     } catch (e) {
//       print('❌ ERROR: $e');
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error opening maps: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmed/utils/app_text_style.dart';
import 'package:quickmed/utils/device_utility.dart';
import 'package:quickmed/utils/theme/colors/q_color.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionOptionsScreen extends StatelessWidget {
  final Map<String, dynamic>? locationData;

  const DirectionOptionsScreen({
    super.key,
    this.locationData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    /// ✅ Safely extract coordinates
    final double? latitude =
    (locationData?['latitude'] as num?)?.toDouble();
    final double? longitude =
    (locationData?['longitude'] as num?)?.toDouble();

    /// 🔍 Debug Logs
    print('═══════════════════════════════════════════');
    print('📍 DirectionOptionsScreen - Data Received');
    print('═══════════════════════════════════════════');
    print('Full locationData: $locationData');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Location: ${locationData?['location']}');
    print('Doctor Name: ${locationData?['doctorName']}');
    print('Specialization: ${locationData?['specialization']}');
    print('═══════════════════════════════════════════');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              /// 🔙 Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back,
                          color: isDark ? Colors.white : Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        "Go Back",
                        style: TAppTextStyle.inter(
                          color:
                          isDark ? Colors.white : QColors.lightGray800,
                          fontSize: 16,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// 🏷 Title
              Text(
                "Choose Direction Option",
                style: TAppTextStyle.inter(
                  weight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 12),

              /// 📍 Location Info
              if (latitude != null && longitude != null) ...[
                Text(
                  "📍 ${locationData?['location'] ?? 'Location'}",
                  style: TAppTextStyle.inter(
                    color:
                    isDark ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 14,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lat: $latitude, Lng: $longitude",
                  style: TAppTextStyle.inter(
                    color:
                    isDark ? Colors.white60 : Colors.grey.shade500,
                    fontSize: 12,
                    weight: FontWeight.w400,
                  ),
                ),
              ],

              const SizedBox(height: 40),

              /// 🚀 Options
              Expanded(
                child: Column(
                  children: [
                    /// 1️⃣ In-App Navigation
                    _buildOptionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.map,
                      title: "In-App Navigation",
                      description:
                      "View directions within the app with map preview",
                      color: Colors.blue,
                      onTap: () {
                        if (latitude == null || longitude == null) {
                          _showError(context);
                          return;
                        }

                        context.push(
                          '/getDirection',
                          extra: {
                            ...?locationData,
                            'userRole': 'doctor',
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// 2️⃣ Google Maps
                    _buildOptionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.map_outlined,
                      title: "Google Maps",
                      description:
                      "Open in Google Maps for turn-by-turn navigation",
                      color: Colors.green,
                      onTap: () =>
                          _openGoogleMaps(context, latitude, longitude),
                    ),

                    const SizedBox(height: 20),

                    /// 3️⃣ Other Map Apps
                    _buildOptionCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.share_location,
                      title: "Other Map Apps",
                      description:
                      "Choose from available map applications",
                      color: Colors.orange,
                      onTap: () =>
                          _openOtherMaps(context, latitude, longitude),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Option Card Widget
  Widget _buildOptionCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
            isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TAppTextStyle.inter(
                      fontSize: 18,
                      weight: FontWeight.w600,
                      color:
                      isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TAppTextStyle.inter(
                      fontSize: 13,
                      weight: FontWeight.w400,
                      color: isDark
                          ? Colors.white70
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: isDark
                  ? Colors.white54
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔴 Error Snackbar
  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location coordinates not available'),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// 🗺 Google Maps
  void _openGoogleMaps(
      BuildContext context, double? lat, double? lng) async {
    if (lat == null || lng == null) {
      _showError(context);
      return;
    }

    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');

    try {
      await launchUrl(url,
          mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError(context);
    }
  }

  /// 🌍 Other Maps
  void _openOtherMaps(
      BuildContext context, double? lat, double? lng) async {
    if (lat == null || lng == null) {
      _showError(context);
      return;
    }

    final Uri geoUrl =
    Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    try {
      if (await canLaunchUrl(geoUrl)) {
        await launchUrl(geoUrl,
            mode: LaunchMode.externalApplication);
      } else {
        final Uri fallback = Uri.parse(
            'https://maps.google.com/?q=$lat,$lng');
        await launchUrl(fallback,
            mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      _showError(context);
    }
  }
}
