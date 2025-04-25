import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/waste_scanner.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/frontend/splash_screen.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/waste_scanner/backend/camera_module.dart';
import 'package:trashtrackr/features/intro/frontend/intro_screen.dart';

Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
  //...runapp
  runApp(const TrashTrackr());
}

class TrashTrackr extends StatelessWidget {
  const TrashTrackr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WasteScannerPage(),
      theme: ThemeData(primaryColor: kAvocado),
    );
  }
}
