import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/badge_model.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({super.key, required this.badge});

  final BadgeModel badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Image.asset(
              'assets/images/badges/colored/${badge.imagePath}',
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(badge.title, style: kLabelSmall.copyWith(fontSize: 10)),
      ],
    );
  }
}
