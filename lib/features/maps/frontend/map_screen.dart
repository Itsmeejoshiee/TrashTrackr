import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trashtrackr/core/services/location_service.dart';
import 'package:trashtrackr/core/services/place_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Set<Marker> _markers = {};
  String? _mapStyle;

  final _locationService = LocationService();
  late final PlacesService _placesService;

  @override
  void initState() {
    rootBundle.loadString('assets/map/map_config.txt').then((string) {
      _mapStyle = string;
    });

    super.initState();
    _placesService = PlacesService();
    _initialize();
  }

  // Fetch current location initially and set markers
  Future<void> _initialize() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      final markers = await _placesService.getNearbyWasteDisposal(
        location.latitude!,
        location.longitude!,
      );

      setState(() {
        _currentLocation = location;
        _markers.addAll(markers);
      });
    }

    // Start streaming location updates
    _locationService.locationStream.listen((newLocation) {
      setState(() {
        _currentLocation = newLocation;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(newLocation.latitude!, newLocation.longitude!),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Waste Disposal')),
      body:
          _currentLocation == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                style: _mapStyle,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  zoom: 14,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: _markers,
              ),
    );
  }
}
