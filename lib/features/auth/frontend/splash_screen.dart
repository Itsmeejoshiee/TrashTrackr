import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/backend/auth_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _welcomeUser(BuildContext context) async {
    // 5 second delay
    final delay = Duration(seconds: 5);
    await Future.delayed(delay);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthManager()),
    );
  }

  @override
  void initState() {
    super.initState();
    _welcomeUser(context);
  }

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
                  'assets/images/components/plant_multicolor.png',
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
                  'assets/images/components/plant_multicolor.png',
                  height: plantHeight,
                ),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/logo/logo_white.png',
              height: logoHeight,
            ),
          ),
        ],
      ),
    );
  }
}
