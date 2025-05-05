import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/providers/user_provider.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/features/auth/backend/auth_bloc.dart';
import 'package:trashtrackr/features/profile/frontend/profile_page.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/waste_scanner.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/frontend/splash_screen.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/waste_scanner/backend/camera_module.dart';
import 'package:trashtrackr/features/intro/frontend/intro_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthBloc()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const TrashTrackr(),
    ),
  );
}

class TrashTrackr extends StatelessWidget {
  const TrashTrackr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
      theme: ThemeData(primaryColor: kAvocado),
    );
  }
}
