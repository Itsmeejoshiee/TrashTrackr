import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Row(
              children: [
                Text('Purple Soda Can'),
                Image.asset('assets/images/icons/bio.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
