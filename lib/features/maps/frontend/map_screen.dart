// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trashtrackr/core/services/location_service.dart';
import 'package:trashtrackr/core/services/place_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/maps/frontend/widgets/place_cards.dart';

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
  bool _isCardVisible = false;
  String? _name;
  String? _address;
  double? _longitude;
  double? _latitude;

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

    // ignore: non_constant_identifier_names, deprecated_member_use
    final BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(12, 12)),
      'assets/images/marker.png',
    );

    if (location != null) {
      final markers = await _placesService.getNearbyWasteDisposal(
        location.latitude!,
        location.longitude!,
        (name, address) {
          setState(() {
            _isCardVisible = true;
            _name = name;
            _address = address;
            _longitude = location.longitude;
            _latitude = location.latitude;
          });
        },
        customMarker: customMarker,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'Dashboard',
            style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
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
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _markers,
                  onTap: (_) {
                    setState(() {
                      _isCardVisible = false;
                    });
                  },
                ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              bottom: _isCardVisible ? 100 : -200,
              left: 0,
              right: 0,
              child: PlaceCard(
                placeName: _name ?? "",
                placeAddress: _address ?? "",
                onOpenMap: (String name) async {
                  await _placesService.openGoogleMaps(name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
