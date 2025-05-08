import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class WastelogBoard extends StatelessWidget {
  const WastelogBoard({super.key, this.recylable = 0, this.biodegradable = 0, this.nonbiodegradable = 0});

  final int recylable;
  final int biodegradable;
  final int nonbiodegradable;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/recycling.png',
                  width: 20,
                  height: 20,
                ),
                Text(
                  '$recylable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recyclable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/leaf_brown.png',
                  width: 18,
                  height: 18,
                ),
                Text(
                  '$biodegradable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Biodegradable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/trashcan.png',
                  width: 20,
                  height: 20,
                ),
                Text(
                  '$nonbiodegradable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Non-Biodegradable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
