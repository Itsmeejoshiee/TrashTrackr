import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(-70, -70),
              child: Transform.rotate(
                angle: 2.8,
                child: Image.asset('assets/images/plant_multicolor.png'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: Offset(70, 70),
              child: Transform.rotate(
                angle: -0.4,
                child: Image.asset('assets/images/plant_multicolor.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/pear_white.png'),
                Text(
                  'TrashTrackr',
                  style: kDisplaySmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
