import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/eco_badge.dart';
import 'package:trashtrackr/core/widgets/box/badge_box.dart';


class BadgeCarousel extends StatelessWidget {
  const BadgeCarousel({super.key, required this.badgeIdList});

  final List<int> badgeIdList;

  List<Widget> _badgeBoxBuilder() {
    List<Widget> badgeBoxes = [];
    for (int id in badgeIdList) {
      final EcoBadge currentBadge = EcoBadge(id: id);
      final BadgeBox badgeBox = BadgeBox(
        width: 112,
        height: 112,
        badge: currentBadge,
      );
      badgeBoxes.add(badgeBox);
      badgeBoxes.add(SizedBox(width: 15));
    }
    return badgeBoxes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 32),

          ..._badgeBoxBuilder(),
        ],
      ),
    );
  }
}