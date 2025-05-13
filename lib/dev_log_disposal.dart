import 'package:flutter/material.dart';

import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    home: DashboardScreen(),
  ));
}