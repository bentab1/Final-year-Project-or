import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooglePlacesService {
  // IMPORTANT: Replace with your actual Google API key
  // static const String apiKey = 'AIzaSyBWDXrXqG4AaEi67QoHYaOptrVRY4DPRL8';
  static const String apiKey = 'AIzaSyDFjiumSr8mpIQYMoNgwnRJax3NPMFkvvU';

  // New Places API (v1) endpoints
  static const String autocompleteUrl =
      'https://places.googleapis.com/v1/places:autocomplete';

  static const String placeDetailsUrl =
      'https://places.googleapis.com/v1/places';

  /// Fetch place suggestions based on user input using NEW Places API
  Future<List<PlaceSuggestion>> getAutocompleteSuggestions(String input) async {
    if (input.isEmpty) return [];

    try {
      final response = await http.post(
        Uri.parse(autocompleteUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
        },
        body: json.encode({
          'input': input,
          'includedPrimaryTypes': ['restaurant', 'lodging', 'tourist_attraction', 'locality', 'administrative_area_level_1', 'country'],
          'languageCode': 'en',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['suggestions'] != null) {
          final suggestions = data['suggestions'] as List;
          return suggestions
              .map((s) => PlaceSuggestion.fromNewApiJson(s))
              .where((s) => s != null)
              .cast<PlaceSuggestion>()
              .toList();
        } else {
          return [];
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  /// Get place details including coordinates using NEW Places API
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse('$placeDetailsUrl/$placeId'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'id,displayName,formattedAddress,location',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlaceDetails.fromNewApiJson(data);
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }
}

/// Model for place suggestions
class PlaceSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String? secondaryText;

  PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    this.secondaryText,
  });

  // Parse from NEW Places API response
  static PlaceSuggestion? fromNewApiJson(Map<String, dynamic> json) {
    try {
      final placePrediction = json['placePrediction'];
      if (placePrediction == null) return null;

      final placeId = placePrediction['placeId'] ?? placePrediction['place'];
      final text = placePrediction['text'];

      if (placeId == null || text == null) return null;

      final mainText = text['text'] ?? '';
      final structuredFormat = placePrediction['structuredFormat'];
      final secondaryText = structuredFormat?['secondaryText']?['text'];

      return PlaceSuggestion(
        placeId: placeId.toString().replaceAll('places/', ''),
        description: text['text'] ?? '',
        mainText: structuredFormat?['mainText']?['text'] ?? mainText,
        secondaryText: secondaryText,
      );
    } catch (e) {
      print('Error parsing suggestion: $e');
      return null;
    }
  }

  // Legacy format (kept for backwards compatibility)
  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      placeId: json['place_id'],
      description: json['description'],
      mainText: json['structured_formatting']['main_text'],
      secondaryText: json['structured_formatting']['secondary_text'],
    );
  }
}

/// Model for place details with coordinates
class PlaceDetails {
  final String name;
  final LatLng location;
  final String formattedAddress;

  PlaceDetails({
    required this.name,
    required this.location,
    required this.formattedAddress,
  });

  // Parse from NEW Places API response
  factory PlaceDetails.fromNewApiJson(Map<String, dynamic> json) {
    final location = json['location'];

    return PlaceDetails(
      name: json['displayName']?['text'] ?? 'Unknown Place',
      location: LatLng(
        location['latitude'].toDouble(),
        location['longitude'].toDouble(),
      ),
      formattedAddress: json['formattedAddress'] ?? '',
    );
  }

  // Legacy format (kept for backwards compatibility)
  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return PlaceDetails(
      name: json['name'],
      location: LatLng(
        location['lat'].toDouble(),
        location['lng'].toDouble(),
      ),
      formattedAddress: json['formatted_address'],
    );
  }
}