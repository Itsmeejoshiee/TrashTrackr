import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashtrackr/features/auth/backend/auth_manager.dart';
import 'package:trashtrackr/features/intro/frontend/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;

    await Future.delayed(const Duration(seconds: 5)); // Optional: splash delay

    if (isFirstRun) {
      await prefs.setBool('is_first_run', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthManager()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _navigate();
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
