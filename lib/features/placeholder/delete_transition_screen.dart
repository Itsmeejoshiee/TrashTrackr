import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class DeleteTransitionScreen extends StatelessWidget {
  const DeleteTransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: kAppleGreen, strokeWidth: 5),
            SizedBox(height: 20),
            Text(
              "Thanks for tracking with TrashTrackr.\nYour data is heading safely to the bin.",
              style: kTitleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
