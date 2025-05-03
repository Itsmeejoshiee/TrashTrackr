import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class WastelogWidget extends StatelessWidget {
  const WastelogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NeoBoxSmall(
          child: Column(
            children: [
              Image.asset('assets/images/recycling.png', width: 20, height: 20),
              Text(
                '32',
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

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        NeoBoxSmall(
          child: Column(
            children: [
              Image.asset(
                'assets/images/leaf_brown.png',
                width: 18,
                height: 18,
              ),
              Text(
                '80',
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

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        NeoBoxSmall(
          child: Column(
            children: [
              Image.asset('assets/images/trashcan.png', width: 20, height: 20),
              Text(
                '12',
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

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
