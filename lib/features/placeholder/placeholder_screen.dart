import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Dashboard',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Text(
          'Coming Soon!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
