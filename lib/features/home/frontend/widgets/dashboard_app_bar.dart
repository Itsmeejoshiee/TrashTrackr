import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({
    super.key,
    required this.username,
    required this.onNotifs,
  });

  final String username;
  final VoidCallback onNotifs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            RichText(
              text: TextSpan(
                style: kHeadlineSmall.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: 'Good Morning,'),
                  TextSpan(
                    text: ' $username!',
                    style: TextStyle(color: kAppleGreen),
                  ),
                ],
              ),
            ),
            Text('App motto or smt'),
          ],
        ),
        IconButton(
          onPressed: onNotifs,
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}