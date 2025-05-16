import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/frontend/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  runApp(const TrashTrackr());
}

class TrashTrackr extends StatelessWidget {
  const TrashTrackr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrashTrackr',
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: kAvocado,
        scaffoldBackgroundColor: kLightGray,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
