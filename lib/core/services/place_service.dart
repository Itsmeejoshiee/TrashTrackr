import 'dart:convert';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtrackr/features/maps/frontend/widgets/place_cards.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesService {
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  // Fetch nearby waste disposal locations using Google Places API
  Future<Set<Marker>> getNearbyWasteDisposal(
    double lat,
    double lng,
    void Function(String name, String address) onMarkerTap, {
    BitmapDescriptor? customMarker,
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&&radius=3000&keyword=recycling%20center&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map<Marker>((result) {
        final geometry = result['geometry']['location'];
        final name = result['name'];

        final vicinity = result['vicinity'];
        return Marker(
          markerId: MarkerId(result['place_id']),
          position: LatLng(geometry['lat'], geometry['lng']),
          icon: customMarker ?? BitmapDescriptor.defaultMarker,
          onTap: () => onMarkerTap(name, vicinity),
        );
      }).toSet();
    } else {
      print('Failed to load places: ${response.statusCode}');
      return {};
    }
  }

  //Open Google Maps with the given shop name
  Future<void> openGoogleMaps(String shopName) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$shopName',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
