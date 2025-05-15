// ignore_for_file: unused_field

import 'dart:async';

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
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map/map_config.txt').then((string) {
      _mapStyle = string;
    });

    _placesService = PlacesService();
    _initialize();
  }

  Future<void> _initialize() async {
    final location = await _locationService.getCurrentLocation();

    final BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(12, 12)),
      'assets/images/marker.png',
    );

    if (location != null) {
      final markers = await _placesService.getNearbyWasteDisposal(
        location.latitude!,
        location.longitude!,
        (name, address) {
          if (!mounted) return;
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

      if (mounted) {
        setState(() {
          _currentLocation = location;
          _markers.addAll(markers);
        });
      }
    }

    // ✅ Save and manage the subscription
    _locationSubscription = _locationService.locationStream.listen((
      newLocation,
    ) {
      if (!mounted) return;
      setState(() {
        _currentLocation = newLocation;
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
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
                    if (!mounted) return;
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
