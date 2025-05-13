import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class BadgeIntroPage extends StatelessWidget {
  const BadgeIntroPage({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final plantWidth = screenWidth * 0.60;
    final boxWidth = screenWidth * 0.4;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kLightGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(15, -20),
              child: Transform.rotate(
                angle: 2.25,
                child: Image.asset(
                  'assets/images/components/plant.png',
                  width: plantWidth,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: Offset(-15, 20),
              child: Transform.rotate(
                angle: -0.8,
                child: Image.asset(
                  'assets/images/components/plant.png',
                  width: plantWidth,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/images/icons/leaf_badge.png'),
                ),
                Container(
                  width: boxWidth,
                  padding: EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/images/icons/fire_badge.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
