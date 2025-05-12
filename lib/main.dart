import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/user_provider.dart';
import 'package:trashtrackr/features/about/frontend/about_screen.dart';
import 'package:trashtrackr/features/auth/backend/auth_manager.dart';
import 'package:trashtrackr/features/badges/frontend/badge_screen.dart';
import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';
import 'package:trashtrackr/features/faqs/frontend/faq_screen.dart';
import 'package:trashtrackr/features/feed/frontend/feed_screen.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_disposal_screen.dart';
import 'package:trashtrackr/features/notifs/frontend/notif_screen.dart';
import 'package:trashtrackr/features/profile/frontend/profile_screen.dart';
import 'package:trashtrackr/features/settings/frontend/edit_profile_screen.dart';
import 'package:trashtrackr/features/settings/frontend/privacy_screen.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/scan_result_screen.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/waste_scanner_screen.dart';
import 'package:trashtrackr/features/maps/frontend/map_screen.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/auth/frontend/splash_screen.dart';
import 'package:trashtrackr/features/auth/frontend/welcome_screen.dart';
import 'package:trashtrackr/features/waste_scanner/backend/camera_module.dart';
import 'package:trashtrackr/features/intro/frontend/intro_screen.dart';
import 'package:trashtrackr/features/waste_stats/frontend/waste_stats_screen.dart';

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
