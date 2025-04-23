import 'package:flutter/material.dart';
import 'package:trashtrackr/features/camera_module/frontend/waste_scanner.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WasteScannerPage());
  }
}
