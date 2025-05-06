import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  Future<Set<Marker>> getNearbyWasteDisposal(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=3000&keyword=waste%20disposal&key=AIzaSyBLNd10Pv_i-aSSOPEFGsCDUmhhte4tim0',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map<Marker>((result) {
        final geometry = result['geometry']['location'];
        final name = result['name'];
        return Marker(
          markerId: MarkerId(result['place_id']),
          position: LatLng(geometry['lat'], geometry['lng']),
          infoWindow: InfoWindow(title: name),
        );
      }).toSet();
    } else {
      print('Failed to load places: ${response.statusCode}');
      return {};
    }
  }
}
