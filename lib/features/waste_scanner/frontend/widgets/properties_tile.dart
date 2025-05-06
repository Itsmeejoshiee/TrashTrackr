import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class PropertiesTile extends StatelessWidget {
  const PropertiesTile({
    super.key,
    required this.material,
    required this.savedEmissions,
  });

  final String material;
  final String savedEmissions;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Materials',
                style: kPoppinsBodyMedium.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                material,
                style: kTitleLarge.copyWith(
                  color: kAvocado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(width: 3, height: 40, color: kLightGray),

          Column(
            children: [
              Text(
                'Saved CO2',
                style: kPoppinsBodyMedium.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                savedEmissions,
                style: kTitleLarge.copyWith(
                  color: kAvocado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}