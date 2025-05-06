import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double plantHeight = screenHeight * 0.55;
    final double logoHeight = screenHeight * 0.2;
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
                child: Image.asset(
                  'assets/images/plant_multicolor.png',
                  height: plantHeight,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: Offset(70, 70),
              child: Transform.rotate(
                angle: -0.4,
                child: Image.asset(
                  'assets/images/plant_multicolor.png',
                  height: plantHeight,
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset('assets/images/logo_white.png', height: logoHeight),
          ),
        ],
      ),
    );
  }
}
