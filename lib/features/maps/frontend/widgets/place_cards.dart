import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';

class PlaceCard extends StatelessWidget {
  final String placeName;
  final String placeAddress;
  final Future<void> Function(String placeName) onOpenMap;

  const PlaceCard({
    super.key,
    required this.placeName,
    required this.placeAddress,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: NeoBox(
        width: screenWidth * 0.8,
        height: screenHeight * 0.25,
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.3,
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://media.istockphoto.com/id/1191815103/vector/waste-recycling-plant-on-a-white-background.jpg?s=612x612&w=0&k=20&c=iL3_xthspmUI2iqxUtMGl38aWSWwGe3Lr1iaIV1ssLo=',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    placeName,
                    style: kTitleSmall.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text(
                    placeAddress,
                    style: kBodyMedium.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  RoundedRectangleButton(
                    title: 'Check in Google Maps',
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.04,
                    onPressed: () {
                      onOpenMap(placeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
