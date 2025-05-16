import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class PropertiesTile extends StatelessWidget {
  const PropertiesTile({
    super.key,
    required this.materials,
    required this.classification,
  });

  final List<String> materials;
  final String classification;

  List<Widget> _listBuilder(List<String> list) {
    List<Widget> listItems = [];
    for (String item in list) {
      String textContent = item;
      listItems.add(
        Text(
          textContent,
          style: kTitleMedium.copyWith(
            color: kAvocado,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return listItems;
  }

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
              ..._listBuilder(materials),
            ],
          ),

          Container(width: 3, height: 40, color: kLightGray),

          Column(
            children: [
              Text(
                'Classification',
                style: kPoppinsBodyMedium.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                classification,
                style: kTitleMedium.copyWith(
                  color: kAvocado,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
