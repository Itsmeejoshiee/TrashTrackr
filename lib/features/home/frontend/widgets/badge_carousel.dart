import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/badge_box.dart';
import 'package:trashtrackr/features/home/frontend/widgets/section_label.dart';


class BadgeCarousel extends StatefulWidget {
  const BadgeCarousel({super.key});

  @override
  State<BadgeCarousel> createState() => _BadgeCarouselState();
}

class _BadgeCarouselState extends State<BadgeCarousel> {

  final BadgeService _badgeService = BadgeService();

  bool isEmpty = false;

  List<Widget> _badgeBoxBuilder(List<BadgeModel> badges) {
    List<Widget> badgeBoxes = [];
    for (BadgeModel badge in badges) {
      if (badge.percent >= 1) {
        final BadgeBox badgeBox = BadgeBox(
          width: 112,
          height: 112,
          badge: badge,
        );
        badgeBoxes.add(badgeBox);
        badgeBoxes.add(SizedBox(width: 15));
      }
    }
    return badgeBoxes;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BadgeModel>>(
      stream: _badgeService.getBadgeStream(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado,));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Badge data is not available.'));
        }

        final badges = _badgeBoxBuilder(snapshot.data!);

        if (badges.isEmpty) return SizedBox();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SectionLabel(label: 'Earned Badges'),
            ),

            SizedBox(height: 20),


            SizedBox(
              width: double.infinity,
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 32),

                  ...badges,
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}