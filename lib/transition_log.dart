import 'package:flutter/material.dart';

import 'package:trashtrackr/features/dashboard/frontend/dashboard_screen.dart';
import 'package:trashtrackr/features/placeholder/delete_transition_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeleteTransitionScreen(),
    ),
  );
}
