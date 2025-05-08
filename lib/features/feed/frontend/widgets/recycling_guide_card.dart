import 'package:flutter/material.dart';

class RecyclingGuideCard extends StatelessWidget {
  const RecyclingGuideCard({super.key, this.index = 1});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 141,
      height: 174,
      margin: EdgeInsets.only(right: 17),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/images/recycling_guide/guide$index.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}