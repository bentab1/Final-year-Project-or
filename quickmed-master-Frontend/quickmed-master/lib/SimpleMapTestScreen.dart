import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Simple Google Maps Test Screen
/// Use this to verify your API key and configuration are working
/// If this shows the map, your setup is correct and the issue is elsewhere
/// If this doesn't show the map, follow the troubleshooting guide

class SimpleMapTestScreen extends StatefulWidget {
  const SimpleMapTestScreen({super.key});

  @override
  State<SimpleMapTestScreen> createState() => _SimpleMapTestScreenState();
}

class _SimpleMapTestScreenState extends State<SimpleMapTestScreen> {
  GoogleMapController? _controller;
  bool _mapCreated = false;
  String _status = "Initializing map...";

  // Test locations
  final LatLng _islamabad = const LatLng(33.6844, 73.0479);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupTestMarker();
  }

  void _setupTestMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('test'),
        position: _islamabad,
        infoWindow: const InfoWindow(
          title: 'Test Location',
          snippet: 'Islamabad, Pakistan',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _mapCreated ? Colors.green : Colors.orange,
            child: Text(
              _status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _islamabad,
                zoom: 14,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                setState(() {
                  _mapCreated = true;
                  _status = "✅ Map loaded successfully!";
                });
                print('✅ Google Maps initialized successfully!');
                print('   API key is working correctly');
              },
              onCameraMove: (CameraPosition position) {
                print('📷 Camera moved to: ${position.target}');
              },
              onTap: (LatLng latLng) {
                print('👆 Map tapped at: ${latLng.latitude}, ${latLng.longitude}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped: ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
            ),
          ),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Troubleshooting:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCheckItem('Can you see the map tiles?'),
                _buildCheckItem('Can you see the marker?'),
                _buildCheckItem('Can you zoom in/out?'),
                _buildCheckItem('Can you tap the map?'),
                const SizedBox(height: 12),
                const Text(
                  'If map is blank/gray:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '1. Check Google Cloud Console\n'
                      '2. Enable "Maps SDK for Android"\n'
                      '3. Enable billing\n'
                      '4. Remove API key restrictions\n'
                      '5. Wait 5 minutes & rebuild',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controller?.animateCamera(
            CameraUpdate.newLatLngZoom(_islamabad, 16),
          );
        },
        icon: const Icon(Icons.my_location),
        label: const Text('Reset View'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// HOW TO USE THIS TEST SCREEN:
//
// 1. Add this file to your project
//
// 2. Navigate to it from anywhere in your app:
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SimpleMapTestScreen()),
//    );
//
// 3. Or add a route in your app:
//    '/test-map': (context) => SimpleMapTestScreen(),
//
// WHAT TO LOOK FOR:
//
// ✅ SUCCESS: You see the map with tiles, a marker, and can zoom/pan
//    → Your API key is configured correctly
//    → The issue is in your GetDirectionScreen code
//
// ❌ FAILURE: You see gray screen with controls but no map tiles
//    → API key issue
//    → Follow the API_KEY_VERIFICATION.md guide
//    → Most likely: billing not enabled OR APIs not enabled
//
// 🔍 CHECK CONSOLE: Look for these logs:
//    - "✅ Google Maps initialized successfully!" = Map working
//    - "📷 Camera moved to:" = Map responding to gestures
//    - "👆 Map tapped at:" = Touch events working
//
// If you don't see these logs, check logcat:
//    adb logcat | grep -i "google\|maps\|api"