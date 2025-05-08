import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ChallengesIntroPage extends StatelessWidget {
  const ChallengesIntroPage({super.key, required this.context});

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
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(-15, -30),
              child: Transform.flip(
                flipX: true,
                child: Transform.rotate(
                  angle: 2.25,
                  child: Image.asset(
                    'assets/images/components/plant.png',
                    width: plantWidth,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.translate(
              offset: Offset(15, 30),
              child: Transform.flip(
                flipX: true,
                child: Transform.rotate(
                  angle: -0.8,
                  child: Image.asset(
                    'assets/images/components/plant.png',
                    width: plantWidth,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset((screenWidth * 0.22), -10),
              child: Image.asset(
                'assets/images/logo/pear_tilt.png',
                width: boxWidth,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset((screenWidth * -0.1), 0),
              child: Container(
                width: boxWidth,
                height: boxWidth,
                padding: EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: kAppleGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(Icons.help_outline, size: boxWidth - 50, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
