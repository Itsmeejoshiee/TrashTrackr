import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/widgets/box/badge_box.dart';

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  final BadgeService _badgeService = BadgeService();

  List<Widget> _badgeBoxBuilder(List<BadgeModel>? badges) {
    List<Widget> badgeBoxes = [];
    for (BadgeModel badge in badges!) {
      // TODO: Check if badge is earned by referencing user badges in database
      final BadgeModel currentBadge = BadgeModel(
        id: badge.id,
        percent: badge.percent,
      );
      final badgeBox = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BadgeBox(badge: currentBadge),
      );
      if (currentBadge.percent >= 1) {
        badgeBoxes.insert(0, badgeBox);
      } else {
        badgeBoxes.add(badgeBox);
      }
    }
    return badgeBoxes;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double badgeTitleOffset =
        screenHeight / ((screenHeight < 800) ? 40 : 20);
    final double imageSize = (screenWidth / 2.5) + 60;
    return StreamBuilder(
      stream: _badgeService.getBadgeStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Badge data is not available.'));
        }

        final badges = snapshot.data;
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: badgeTitleOffset),
              Image.asset(
                'assets/images/badges/badges_title.png',
                width: imageSize,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: _badgeBoxBuilder(badges),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
