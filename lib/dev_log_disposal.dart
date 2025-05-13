import 'package:flutter/material.dart';
import 'package:trashtrackr/features/feed/frontend/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedScreen(),
  ));
}