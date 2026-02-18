// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:quickmed/utils/widgets/TButton.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../utils/app_text_style.dart';
// import '../../../utils/device_utility.dart';
// import '../../../utils/theme/colors/q_color.dart';
//
// class GetDirectionScreen extends StatefulWidget {
//   final Map<String, dynamic>? locationData;
//
//   const GetDirectionScreen({
//     super.key,
//     this.locationData,
//   });
//
//   @override
//   State<GetDirectionScreen> createState() => _GetDirectionScreenState();
// }
//
// class _GetDirectionScreenState extends State<GetDirectionScreen> {
//   int selectedTransport = 0;
//
//   final Completer<GoogleMapController> mapController = Completer();
//
//   // Dynamic locations
//   LatLng? currentLocation;
//   LatLng? destinationLocation;
//
//   Set<Polyline> mapPolylines = {};
//   Set<Marker> mapMarkers = {};
//
//   bool isLoadingLocation = true;
//   String? locationError;
//   String distanceText = "Calculating...";
//   String durationText = "Calculating...";
//   String currentAddress = "Getting your location...";
//   String destinationAddress = "Loading...";
//
//   // Get location data from route
//   String get doctorName =>
//       widget.locationData?['doctorName'] ??
//           widget.locationData?['doctor_name'] ??
//           'Doctor';
//
//   String get locationName {
//     String? location = widget.locationData?['location'] ??
//         widget.locationData?['address'] ??
//         widget.locationData?['clinic_address'] ??
//         widget.locationData?['hospital_address'];
//
//     if (location != null && location.isNotEmpty) {
//       return location;
//     }
//
//     String? city = widget.locationData?['city'];
//     String? country = widget.locationData?['country'];
//
//     if (city != null && country != null) {
//       return '$city, $country';
//     }
//
//     return 'Hospital Location';
//   }
//
//   String get specialization =>
//       widget.locationData?['specialization'] ??
//           widget.locationData?['specialty'] ??
//           'Specialist';
//
//   // Get coordinates - safely handle different types
//   double? get destinationLat {
//     var lat = widget.locationData?['latitude'] ?? widget.locationData?['lat'];
//     return _parseCoordinate(lat);
//   }
//
//   double? get destinationLng {
//     var lng = widget.locationData?['longitude'] ??
//         widget.locationData?['lng'] ??
//         widget.locationData?['lon'];
//     return _parseCoordinate(lng);
//   }
//
//   // Helper method to safely parse coordinates
//   double? _parseCoordinate(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _debugPrintLocationData();
//     _initializeLocations();
//   }
//
//   void _debugPrintLocationData() {
//     print('═══════════════════════════════════════');
//     print('📋 GET DIRECTION SCREEN - Location Data');
//     print('═══════════════════════════════════════');
//     print('Doctor Name: $doctorName');
//     print('Location Name: $locationName');
//     print('Specialization: $specialization');
//     print('Latitude: $destinationLat (${destinationLat?.runtimeType})');
//     print('Longitude: $destinationLng (${destinationLng?.runtimeType})');
//     print('Full Data: ${widget.locationData}');
//     print('═══════════════════════════════════════');
//   }
//
//   Future<void> _initializeLocations() async {
//     try {
//       setState(() {
//         isLoadingLocation = true;
//         locationError = null;
//       });
//
//       print('🚀 Starting location initialization...');
//
//       // Step 1: Get current location
//       await _getCurrentLocation();
//       print('✅ Current location obtained: $currentLocation');
//
//       // Step 2: Get destination coordinates (only from provided lat/long)
//       await _getDestinationCoordinates();
//       print('✅ Destination location obtained: $destinationLocation');
//
//       // Step 3: Get addresses
//       await _getCurrentAddress();
//       await _getDestinationAddress();
//
//       // Step 4: Initialize map if both locations are available
//       if (currentLocation != null && destinationLocation != null) {
//         _initializeMap();
//         _calculateDistance();
//         print('✅ Map initialized successfully');
//       } else {
//         throw Exception('Failed to get both locations');
//       }
//
//       setState(() {
//         isLoadingLocation = false;
//       });
//     } catch (e) {
//       print('❌ Error in _initializeLocations: $e');
//       setState(() {
//         locationError = e.toString();
//         isLoadingLocation = false;
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Location error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       print('📍 Getting current location...');
//
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         print('⚠️ Location services disabled');
//         throw Exception('Location services are disabled');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         print('⚠️ Requesting location permission...');
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permission denied');
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permission permanently denied');
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 15),
//       );
//
//       setState(() {
//         currentLocation = LatLng(position.latitude, position.longitude);
//       });
//
//       print('✅ Current location: ${position.latitude}, ${position.longitude}');
//     } catch (e) {
//       print('❌ Error getting current location: $e');
//       setState(() {
//         currentLocation = const LatLng(33.6844, 73.0479);
//       });
//       print('⚠️ Using fallback current location: Islamabad');
//     }
//   }
//
//   Future<void> _getCurrentAddress() async {
//     if (currentLocation == null) return;
//
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         currentLocation!.latitude,
//         currentLocation!.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         setState(() {
//           currentAddress = _formatAddress(place);
//         });
//         print('✅ Current address: $currentAddress');
//       }
//     } catch (e) {
//       print('❌ Error getting current address: $e');
//       setState(() {
//         currentAddress = 'Your Current Location';
//       });
//     }
//   }
//
//   Future<void> _getDestinationAddress() async {
//     if (destinationLocation == null) return;
//
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         destinationLocation!.latitude,
//         destinationLocation!.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         setState(() {
//           destinationAddress = _formatAddress(place);
//         });
//         print('✅ Destination address: $destinationAddress');
//       }
//     } catch (e) {
//       print('❌ Error getting destination address: $e');
//       setState(() {
//         destinationAddress = locationName;
//       });
//     }
//   }
//
//   String _formatAddress(Placemark place) {
//     List<String> parts = [];
//
//     if (place.street != null && place.street!.isNotEmpty) {
//       parts.add(place.street!);
//     }
//     if (place.locality != null && place.locality!.isNotEmpty) {
//       parts.add(place.locality!);
//     }
//     if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
//       parts.add(place.administrativeArea!);
//     }
//
//     if (parts.isEmpty) {
//       return 'Location';
//     }
//
//     return parts.join(', ');
//   }
//
//   Future<void> _getDestinationCoordinates() async {
//     try {
//       print('📍 Getting destination coordinates...');
//
//       // Use only provided coordinates - no fallback, no geocoding
//       if (destinationLat != null && destinationLng != null) {
//         setState(() {
//           destinationLocation = LatLng(destinationLat!, destinationLng!);
//         });
//         print('✅ Using provided coordinates:');
//         print('   Latitude: $destinationLat');
//         print('   Longitude: $destinationLng');
//         return;
//       }
//
//       // If no coordinates provided, throw error
//       throw Exception('No coordinates provided for destination');
//     } catch (e) {
//       print('❌ Error: No valid coordinates available');
//       print('   Latitude: $destinationLat');
//       print('   Longitude: $destinationLng');
//
//       throw Exception('Destination coordinates are required');
//     }
//   }
//
//   void _initializeMap() {
//     if (currentLocation == null || destinationLocation == null) {
//       print('❌ Cannot initialize map: locations are null');
//       return;
//     }
//
//     print('🗺️ Initializing map with markers...');
//
//     mapMarkers.clear();
//     mapPolylines.clear();
//
//     // Add marker for current location (Blue)
//     mapMarkers.add(
//       Marker(
//         markerId: const MarkerId('current'),
//         position: currentLocation!,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         infoWindow: InfoWindow(
//           title: '📍 Your Location',
//           snippet: currentAddress,
//         ),
//       ),
//     );
//
//     // Add marker for destination (Red)
//     mapMarkers.add(
//       Marker(
//         markerId: const MarkerId('destination'),
//         position: destinationLocation!,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         infoWindow: InfoWindow(
//           title: '🏥 $doctorName',
//           snippet: destinationAddress,
//         ),
//       ),
//     );
//
//     // Add polyline between points
//     mapPolylines.add(
//       Polyline(
//         polylineId: const PolylineId('route'),
//         points: [currentLocation!, destinationLocation!],
//         color: Colors.blue,
//         width: 4,
//         patterns: [PatternItem.dash(20), PatternItem.gap(10)],
//       ),
//     );
//
//     print('✅ Map initialized with ${mapMarkers.length} markers');
//     print('   Current: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
//     print('   Destination: ${destinationLocation!.latitude}, ${destinationLocation!.longitude}');
//
//     setState(() {});
//   }
//
//   void _calculateDistance() {
//     if (currentLocation == null || destinationLocation == null) return;
//
//     double distanceInMeters = Geolocator.distanceBetween(
//       currentLocation!.latitude,
//       currentLocation!.longitude,
//       destinationLocation!.latitude,
//       destinationLocation!.longitude,
//     );
//
//     double distanceInKm = distanceInMeters / 1000;
//
//     print('📏 Distance calculated: ${distanceInKm.toStringAsFixed(2)} km');
//
//     setState(() {
//       if (distanceInKm < 1) {
//         distanceText = '${distanceInMeters.toStringAsFixed(0)} m';
//       } else {
//         distanceText = '${distanceInKm.toStringAsFixed(1)} km';
//       }
//
//       // Estimate duration based on transport mode
//       double durationInMinutes;
//       switch (selectedTransport) {
//         case 0: // Car
//           durationInMinutes = (distanceInKm / 50 * 60);
//           break;
//         case 1: // Bike
//           durationInMinutes = (distanceInKm / 20 * 60);
//           break;
//         case 2: // Walk
//           durationInMinutes = (distanceInKm / 5 * 60);
//           break;
//         default:
//           durationInMinutes = (distanceInKm / 50 * 60);
//       }
//
//       if (durationInMinutes < 60) {
//         durationText = '${durationInMinutes.toStringAsFixed(0)} min';
//       } else {
//         double hours = durationInMinutes / 60;
//         durationText = '${hours.toStringAsFixed(1)} hr';
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = TDeviceUtils.isDarkMode(context);
//
//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.grey.shade50,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             _buildHeader(isDark),
//
//             // Scrollable Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//
//                     // Location Route Card
//                     _buildLocationRouteCard(isDark),
//
//                     const SizedBox(height: 20),
//
//                     // Map Section
//                     _buildMapSection(isDark),
//
//                     const SizedBox(height: 20),
//
//                     // Stats Card (Distance & Duration)
//                     _buildStatsCard(isDark),
//
//                     const SizedBox(height: 20),
//
//                     // Transport Options
//                     _buildTransportOptions(isDark),
//
//                     const SizedBox(height: 24),
//
//                     // Start Navigation Button
//                     _buildNavigationButton(),
//
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Header with back button and title
//   Widget _buildHeader(bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade900 : Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: isDark ? Colors.white : Colors.black,
//                     size: 20,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Get Direction",
//                       style: TAppTextStyle.inter(
//                         weight: FontWeight.w700,
//                         color: isDark ? Colors.white : Colors.black,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       "Navigate to doctor's location",
//                       style: TAppTextStyle.inter(
//                         color: isDark ? Colors.white70 : Colors.grey.shade600,
//                         fontSize: 12,
//                         weight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Location Route Card with improved design
//   Widget _buildLocationRouteCard(bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: LinearGradient(
//           colors: isDark
//               ? [Colors.grey.shade900, Colors.grey.shade800]
//               : [Colors.white, Colors.blue.shade50],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // From Location
//           _buildLocationRow(
//             icon: Icons.my_location,
//             iconColor: Colors.blue,
//             label: "From",
//             title: currentAddress,
//             subtitle: currentLocation != null
//                 ? "Lat: ${currentLocation!.latitude.toStringAsFixed(4)}, Lng: ${currentLocation!.longitude.toStringAsFixed(4)}"
//                 : null,
//             isDark: isDark,
//           ),
//
//           // Divider with icon
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 1,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.transparent,
//                           isDark ? Colors.white24 : Colors.grey.shade300,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.route,
//                       size: 20,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     height: 1,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           isDark ? Colors.white24 : Colors.grey.shade300,
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // To Location
//           _buildLocationRow(
//             icon: Icons.location_on,
//             iconColor: Colors.red,
//             label: "To",
//             title: "🏥 $doctorName",
//             subtitle: destinationAddress,
//             specialization: specialization,
//             coordinates: destinationLocation != null
//                 ? "Lat: ${destinationLocation!.latitude.toStringAsFixed(4)}, Lng: ${destinationLocation!.longitude.toStringAsFixed(4)}"
//                 : null,
//             isDark: isDark,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationRow({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required String title,
//     String? subtitle,
//     String? specialization,
//     String? coordinates,
//     required bool isDark,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Icon
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: iconColor.withOpacity(0.3),
//               width: 2,
//             ),
//           ),
//           child: Icon(
//             icon,
//             size: 24,
//             color: iconColor,
//           ),
//         ),
//
//         const SizedBox(width: 12),
//
//         // Text content
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Label
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: isDark ? Colors.white60 : Colors.grey.shade600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 4),
//
//               // Title
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: isDark ? Colors.white : Colors.black87,
//                 ),
//               ),
//
//               if (specialization != null) ...[
//                 const SizedBox(height: 2),
//                 Text(
//                   specialization,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.blue.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//
//               if (subtitle != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: isDark ? Colors.white70 : Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//
//               if (coordinates != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   coordinates,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontFamily: 'monospace',
//                     color: isDark ? Colors.white54 : Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Map Section
//   Widget _buildMapSection(bool isDark) {
//     if (isLoadingLocation) {
//       return _buildLoadingState(isDark);
//     } else if (locationError != null) {
//       return _buildErrorState(isDark);
//     } else {
//       return _buildMapDisplay();
//     }
//   }
//
//   Widget _buildLoadingState(bool isDark) {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const CircularProgressIndicator(
//               color: Colors.blue,
//               strokeWidth: 3,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Loading map...',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: isDark ? Colors.white : Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               'Getting your location and doctor\'s location',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: isDark ? Colors.white60 : Colors.grey.shade600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(bool isDark) {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red.shade200, width: 2),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade100,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.error_outline,
//                   size: 48,
//                   color: Colors.red.shade700,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Location Not Available',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'No coordinates provided for destination',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.arrow_back, size: 18),
//                 label: const Text('Go Back'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 14,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMapDisplay() {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: currentLocation ?? const LatLng(33.6844, 73.0479),
//             zoom: 12,
//           ),
//           markers: mapMarkers,
//           polylines: mapPolylines,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           zoomControlsEnabled: true,
//           compassEnabled: true,
//           mapToolbarEnabled: false,
//           mapType: MapType.normal,
//           onMapCreated: (controller) {
//             if (!mapController.isCompleted) {
//               mapController.complete(controller);
//               _fitMapBounds(controller);
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   // Stats Card (Distance & Duration)
//   Widget _buildStatsCard(bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: isDark ? Colors.grey.shade900 : Colors.white,
//         border: Border.all(
//           color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Distance
//           Expanded(
//             child: _buildStatItem(
//               icon: Icons.straighten,
//               iconColor: Colors.green,
//               label: "Distance",
//               value: distanceText,
//               isDark: isDark,
//             ),
//           ),
//
//           // Divider
//           Container(
//             width: 1,
//             height: 60,
//             color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//           ),
//
//           // Duration
//           Expanded(
//             child: _buildStatItem(
//               icon: Icons.access_time,
//               iconColor: Colors.orange,
//               label: "Duration",
//               value: durationText,
//               isDark: isDark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required String value,
//     required bool isDark,
//   }) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             size: 24,
//             color: iconColor,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: isDark ? Colors.white60 : Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: isDark ? Colors.white : Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Transport Options
//   Widget _buildTransportOptions(bool isDark) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Choose Transport Mode",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: isDark ? Colors.white : Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildTransportOption(
//               icon: Icons.directions_car,
//               label: "Car",
//               index: 0,
//               isDark: isDark,
//             ),
//             _buildTransportOption(
//               icon: Icons.directions_bike,
//               label: "Bike",
//               index: 1,
//               isDark: isDark,
//             ),
//             _buildTransportOption(
//               icon: Icons.directions_walk,
//               label: "Walk",
//               index: 2,
//               isDark: isDark,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTransportOption({
//     required IconData icon,
//     required String label,
//     required int index,
//     required bool isDark,
//   }) {
//     final bool isSelected = selectedTransport == index;
//
//     return GestureDetector(
//       onTap: isLoadingLocation
//           ? null
//           : () {
//         setState(() {
//           selectedTransport = index;
//         });
//         _calculateDistance();
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 105,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(
//             colors: [Colors.blue.shade400, Colors.blue.shade600],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )
//               : null,
//           color: isSelected
//               ? null
//               : (isDark ? Colors.grey.shade900 : Colors.grey.shade100),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected
//                 ? Colors.blue.shade300
//                 : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
//             width: 2,
//           ),
//           boxShadow: isSelected
//               ? [
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ]
//               : null,
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 32,
//               color: isSelected
//                   ? Colors.white
//                   : (isDark ? Colors.white70 : Colors.black87),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//                 color: isSelected
//                     ? Colors.white
//                     : (isDark ? Colors.white70 : Colors.black87),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (isSelected) ...[
//               const SizedBox(height: 4),
//               Text(
//                 durationText,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 11,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Navigation Button
//   Widget _buildNavigationButton() {
//     return QButton(
//       text: 'Start Navigation',
//       onPressed: isLoadingLocation ? null : _openExternalMaps,
//     );
//   }
//
//   // Fit map bounds to show both markers
//   void _fitMapBounds(GoogleMapController controller) async {
//     if (currentLocation == null || destinationLocation == null) return;
//
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     try {
//       final bounds = LatLngBounds(
//         southwest: LatLng(
//           currentLocation!.latitude < destinationLocation!.latitude
//               ? currentLocation!.latitude
//               : destinationLocation!.latitude,
//           currentLocation!.longitude < destinationLocation!.longitude
//               ? currentLocation!.longitude
//               : destinationLocation!.longitude,
//         ),
//         northeast: LatLng(
//           currentLocation!.latitude > destinationLocation!.latitude
//               ? currentLocation!.latitude
//               : destinationLocation!.latitude,
//           currentLocation!.longitude > destinationLocation!.longitude
//               ? currentLocation!.longitude
//               : destinationLocation!.longitude,
//         ),
//       );
//
//       controller.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 100),
//       );
//
//       print('✅ Camera bounds fitted to show both markers');
//     } catch (e) {
//       print('❌ Error fitting map bounds: $e');
//     }
//   }
//
//   // Open external maps app for navigation
//   void _openExternalMaps() async {
//     if (currentLocation == null || destinationLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location not available. Please wait.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Get travel mode
//     String travelMode = 'driving';
//     switch (selectedTransport) {
//       case 0:
//         travelMode = 'driving';
//         break;
//       case 1:
//         travelMode = 'bicycling';
//         break;
//       case 2:
//         travelMode = 'walking';
//         break;
//     }
//
//     // Create Google Maps URL with both current and destination
//     final url = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1'
//           '&origin=${currentLocation!.latitude},${currentLocation!.longitude}'
//           '&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}'
//           '&travelmode=$travelMode',
//     );
//
//     print('🗺️ Opening Google Maps with URL: $url');
//
//     try {
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//         print('✅ Google Maps opened successfully');
//       } else {
//         throw 'Could not launch Google Maps';
//       }
//     } catch (e) {
//       print('❌ Error opening maps: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Could not open maps: $e'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/utils/widgets/TButton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';

class GetDirectionScreen extends StatefulWidget {
  final Map<String, dynamic>? locationData;
  final String userRole; // 'patient' or 'doctor'

  const GetDirectionScreen({
    super.key,
    this.locationData,
    this.userRole = 'patient',
  });

  @override
  State<GetDirectionScreen> createState() => _GetDirectionScreenState();
}

class _GetDirectionScreenState extends State<GetDirectionScreen> {
  int selectedTransport = 0;

  final Completer<GoogleMapController> mapController = Completer();

  LatLng? currentLocation;
  LatLng? destinationLocation;

  Set<Polyline> mapPolylines = {};
  Set<Marker> mapMarkers = {};

  bool isLoadingLocation = true;
  String? locationError;
  String distanceText = "Calculating...";
  String durationText = "Calculating...";
  String currentAddress = "Getting your location...";
  String destinationAddress = "Loading...";

  // ─── Role helpers ──────────────────────────────────────────────────────────

  bool get isDoctor => widget.userRole == 'doctor';

  String get destinationPersonName => isDoctor
      ? (widget.locationData?['patientName'] ??
      widget.locationData?['patient_name'] ??
      'Patient')
      : (widget.locationData?['doctorName'] ??
      widget.locationData?['doctor_name'] ??
      'Doctor');

  String get navigationSubtitle =>
      isDoctor ? "Navigate to patient's location" : "Navigate to doctor's location";

  String get destinationMarkerTitle =>
      isDoctor ? '🧑 $destinationPersonName' : '🏥 $destinationPersonName';

  String get specialization => isDoctor
      ? ''
      : (widget.locationData?['specialization'] ??
      widget.locationData?['specialty'] ??
      '');

  String get locationName {
    if (isDoctor) return 'Patient Location';

    String? location = widget.locationData?['location'] ??
        widget.locationData?['address'] ??
        widget.locationData?['clinic_address'] ??
        widget.locationData?['hospital_address'];

    if (location != null && location.isNotEmpty) return location;

    String? city = widget.locationData?['city'];
    String? country = widget.locationData?['country'];
    if (city != null && country != null) return '$city, $country';

    return 'Hospital Location';
  }

  // ─── Coordinates ───────────────────────────────────────────────────────────

  double? get destinationLat {
    if (isDoctor) {
      var lat = widget.locationData?['patientLat'] ??
          widget.locationData?['patient_latitude'];
      return _parseCoordinate(lat);
    } else {
      var lat =
          widget.locationData?['latitude'] ?? widget.locationData?['lat'];
      return _parseCoordinate(lat);
    }
  }

  double? get destinationLng {
    if (isDoctor) {
      var lng = widget.locationData?['patientLng'] ??
          widget.locationData?['patient_longitude'];
      return _parseCoordinate(lng);
    } else {
      var lng = widget.locationData?['longitude'] ??
          widget.locationData?['lng'] ??
          widget.locationData?['lon'];
      return _parseCoordinate(lng);
    }
  }

  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initializeLocations();
  }

  // ─── Location logic ────────────────────────────────────────────────────────

  Future<void> _initializeLocations() async {
    try {
      setState(() {
        isLoadingLocation = true;
        locationError = null;
      });

      await _getCurrentLocation();
      await _getDestinationCoordinates();
      await _getCurrentAddress();
      await _getDestinationAddress();

      if (currentLocation != null && destinationLocation != null) {
        _initializeMap();
        _calculateDistance();
      } else {
        throw Exception('Failed to get both locations');
      }

      setState(() => isLoadingLocation = false);
    } catch (e) {
      setState(() {
        locationError = e.toString();
        isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Fallback to Islamabad
      setState(() {
        currentLocation = const LatLng(33.6844, 73.0479);
      });
    }
  }

  Future<void> _getDestinationCoordinates() async {
    if (destinationLat != null && destinationLng != null) {
      setState(() {
        destinationLocation = LatLng(destinationLat!, destinationLng!);
      });
      return;
    }
    throw Exception('Destination coordinates are required');
  }

  Future<void> _getCurrentAddress() async {
    if (currentLocation == null) return;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() => currentAddress = _formatAddress(placemarks.first));
      }
    } catch (e) {
      setState(() => currentAddress = 'Your Current Location');
    }
  }

  Future<void> _getDestinationAddress() async {
    if (destinationLocation == null) return;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        destinationLocation!.latitude,
        destinationLocation!.longitude,
      );
      if (placemarks.isNotEmpty) {
        setState(() => destinationAddress = _formatAddress(placemarks.first));
      }
    } catch (e) {
      setState(() => destinationAddress = locationName);
    }
  }

  String _formatAddress(Placemark place) {
    List<String> parts = [];
    if (place.street != null && place.street!.isNotEmpty) parts.add(place.street!);
    if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }
    return parts.isEmpty ? 'Location' : parts.join(', ');
  }

  void _initializeMap() {
    if (currentLocation == null || destinationLocation == null) return;

    mapMarkers.clear();
    mapPolylines.clear();

    // Current location marker (Blue)
    mapMarkers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: '📍 Your Location',
          snippet: currentAddress,
        ),
      ),
    );

    // Destination marker (Red) — doctor for patient, patient for doctor
    mapMarkers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: destinationMarkerTitle,
          snippet: destinationAddress,
        ),
      ),
    );

    // Dashed polyline
    mapPolylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [currentLocation!, destinationLocation!],
        color: Colors.blue,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );

    setState(() {});
  }

  void _calculateDistance() {
    if (currentLocation == null || destinationLocation == null) return;

    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation!.latitude,
      currentLocation!.longitude,
      destinationLocation!.latitude,
      destinationLocation!.longitude,
    );

    double distanceInKm = distanceInMeters / 1000;

    setState(() {
      distanceText = distanceInKm < 1
          ? '${distanceInMeters.toStringAsFixed(0)} m'
          : '${distanceInKm.toStringAsFixed(1)} km';

      double durationInMinutes;
      switch (selectedTransport) {
        case 0:
          durationInMinutes = distanceInKm / 50 * 60;
          break;
        case 1:
          durationInMinutes = distanceInKm / 20 * 60;
          break;
        case 2:
          durationInMinutes = distanceInKm / 5 * 60;
          break;
        default:
          durationInMinutes = distanceInKm / 50 * 60;
      }

      durationText = durationInMinutes < 60
          ? '${durationInMinutes.toStringAsFixed(0)} min'
          : '${(durationInMinutes / 60).toStringAsFixed(1)} hr';
    });
  }

  void _fitMapBounds(GoogleMapController controller) async {
    if (currentLocation == null || destinationLocation == null) return;
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final bounds = LatLngBounds(
        southwest: LatLng(
          currentLocation!.latitude < destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude < destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
        northeast: LatLng(
          currentLocation!.latitude > destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude > destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
      );
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (e) {
      debugPrint('Error fitting map bounds: $e');
    }
  }

  void _openExternalMaps() async {
    if (currentLocation == null || destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available. Please wait.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String travelMode;
    switch (selectedTransport) {
      case 1:
        travelMode = 'bicycling';
        break;
      case 2:
        travelMode = 'walking';
        break;
      default:
        travelMode = 'driving';
    }

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
          '&origin=${currentLocation!.latitude},${currentLocation!.longitude}'
          '&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}'
          '&travelmode=$travelMode',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildLocationRouteCard(isDark),
                    const SizedBox(height: 20),
                    _buildMapSection(isDark),
                    const SizedBox(height: 20),
                    _buildStatsCard(isDark),
                    const SizedBox(height: 20),
                    _buildTransportOptions(isDark),
                    const SizedBox(height: 24),
                    _buildNavigationButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Widgets ───────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get Direction",
                  style: TAppTextStyle.inter(
                    weight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                  ),
                ),
                // Text(
                //   navigationSubtitle,
                //   style: TAppTextStyle.inter(
                //     color: isDark ? Colors.white70 : Colors.grey.shade600,
                //     fontSize: 12,
                //     weight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ),
          // Role badge
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: isDoctor
          //         ? Colors.teal.withOpacity(0.1)
          //         : Colors.blue.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(20),
          //     border: Border.all(
          //       color: isDoctor
          //           ? Colors.teal.withOpacity(0.4)
          //           : Colors.blue.withOpacity(0.4),
          //     ),
          //   ),
          //   child: Text(
          //     isDoctor ? '👨‍⚕️ Doctor' : '🧑 Patient',
          //     style: TextStyle(
          //       fontSize: 11,
          //       fontWeight: FontWeight.w600,
          //       color: isDoctor ? Colors.teal : Colors.blue,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLocationRouteCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.grey.shade900, Colors.grey.shade800]
              : [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // From — always current GPS location
          _buildLocationRow(
            icon: Icons.my_location,
            iconColor: Colors.blue,
            label: "From",
            title: currentAddress,
            subtitle: currentLocation != null
                ? "Lat: ${currentLocation!.latitude.toStringAsFixed(4)}, "
                "Lng: ${currentLocation!.longitude.toStringAsFixed(4)}"
                : null,
            isDark: isDark,
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          isDark ? Colors.white24 : Colors.grey.shade300,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.route, size: 20, color: Colors.blue),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark ? Colors.white24 : Colors.grey.shade300,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // To — doctor (patient view) or patient (doctor view)
          _buildLocationRow(
            icon: Icons.location_on,
            iconColor: Colors.red,
            label: "To",
            title: destinationMarkerTitle,
            subtitle: destinationAddress,
            specialization: specialization.isEmpty ? null : specialization,
            coordinates: destinationLocation != null
                ? "Lat: ${destinationLocation!.latitude.toStringAsFixed(4)}, "
                "Lng: ${destinationLocation!.longitude.toStringAsFixed(4)}"
                : null,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String title,
    String? subtitle,
    String? specialization,
    String? coordinates,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, size: 24, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              if (specialization != null) ...[
                const SizedBox(height: 2),
                Text(
                  specialization,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
              if (coordinates != null) ...[
                const SizedBox(height: 4),
                Text(
                  coordinates,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(bool isDark) {
    if (isLoadingLocation) return _buildLoadingState(isDark);
    if (locationError != null) return _buildErrorState(isDark);
    return _buildMapDisplay();
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading map...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isDoctor
                  ? 'Getting your location and patient\'s location'
                  : 'Getting your location and doctor\'s location',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
              ),
              const SizedBox(height: 20),
              const Text(
                'Location Not Available',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                locationError ?? 'No coordinates provided for destination',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapDisplay() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation ?? const LatLng(33.6844, 73.0479),
            zoom: 12,
          ),
          markers: mapMarkers,
          polylines: mapPolylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            if (!mapController.isCompleted) {
              mapController.complete(controller);
              _fitMapBounds(controller);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.straighten,
              iconColor: Colors.green,
              label: "Distance",
              value: distanceText,
              isDark: isDark,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.access_time,
              iconColor: Colors.orange,
              label: "Duration",
              value: durationText,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: iconColor),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTransportOptions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Transport Mode",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTransportOption(
                icon: Icons.directions_car, label: "Car", index: 0, isDark: isDark),
            _buildTransportOption(
                icon: Icons.directions_bike, label: "Bike", index: 1, isDark: isDark),
            _buildTransportOption(
                icon: Icons.directions_walk, label: "Walk", index: 2, isDark: isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildTransportOption({
    required IconData icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final bool isSelected = selectedTransport == index;

    return GestureDetector(
      onTap: isLoadingLocation
          ? null
          : () {
        setState(() => selectedTransport = index);
        _calculateDistance();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected
              ? null
              : (isDark ? Colors.grey.shade900 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.blue.shade300
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                durationText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return QButton(
      text: 'Start Navigation',
      onPressed: isLoadingLocation ? null : _openExternalMaps,
    );
  }
}