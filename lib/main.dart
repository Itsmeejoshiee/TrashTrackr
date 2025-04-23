import 'package:flutter/material.dart';
import 'package:trashtrackr/features/auth/frontend/splash_screen.dart';
import 'package:trashtrackr/features/camera_module/backend/camera_module.dart';

void main() {
  runApp(const TrashTrackr());
}

class TrashTrackr extends StatelessWidget {
  const TrashTrackr({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}
