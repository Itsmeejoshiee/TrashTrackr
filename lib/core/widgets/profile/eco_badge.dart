import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/profile/backend/user_badge_data.dart';

class EcoBadge extends StatelessWidget {
  const EcoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/sample_badge.png', width: 53, height: 61.38),
        SizedBox(height: 5),
        Text(
          UserBadgeData().userBadges[0].badgeName,
          style: kLabelSmall.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
