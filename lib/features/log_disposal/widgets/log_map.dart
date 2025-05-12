import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisposalLocationWidget extends StatelessWidget {
  final String locationName;
  final LatLng coordinates;

  const DisposalLocationWidget({
    super.key,
    required this.locationName,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disposal Locations',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          locationName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        Text(
          'Disposal Location Map',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: coordinates,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('disposalLocation'),
                position: coordinates,
                infoWindow: InfoWindow(title: locationName),
              ),
            },
          ),
        ),
      ],
    );
  }
}