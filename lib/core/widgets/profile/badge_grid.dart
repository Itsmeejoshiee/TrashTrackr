import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/profile/badge_tile.dart';

class BadgeGrid extends StatefulWidget {
  const BadgeGrid({super.key});

  @override
  State<BadgeGrid> createState() => _BadgeGridState();
}

class _BadgeGridState extends State<BadgeGrid> {
  final BadgeService _badgeService = BadgeService();

  bool _isExpanded = false;
  int _visibleBadges = 3;

  List<Widget> _badgeTileBuilder(List<BadgeModel> badges) {
    List<Widget> badgeTiles = [];
    if (badges.length < _visibleBadges) {
      _visibleBadges = badges.length;
    }
    for (int i = 0; i < _visibleBadges; i++) {
      final BadgeModel currentBadge = badges[i];
      print(currentBadge.title);
      badgeTiles.add(BadgeTile(badge: currentBadge));
    }
    return badgeTiles;
  }

  List<BadgeModel> _buildEarnedBadgeList(List<BadgeModel> badges) {
    List<BadgeModel> earnedBadges = [];
    for (BadgeModel badge in badges) {
      if (badge.isEarned) {
        earnedBadges.add(badge);
      }
    }
    return earnedBadges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BadgeModel>>(
      stream: _badgeService.getBadgeStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Badge data is not available.'));
        }

        final badges = _buildEarnedBadgeList(snapshot.data!);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Badges',
                  style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: badges.length > 3,
                  child: TextButton(
                    onPressed: () {
                      if (_isExpanded) {
                        setState(() {
                          _visibleBadges = 3;
                          _isExpanded = false;
                        });
                      } else {
                        setState(() {
                          _visibleBadges = badges.length;
                          _isExpanded = true;
                        });
                      }
                    },
                    child: Text(
                      'Show ${(_isExpanded) ? 'less' : 'more'}',
                      style: kPoppinsBodyMedium.copyWith(color: kAvocado),
                    ),
                  ),
                ),
              ],
            ),
            NeoBox(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                ),
                itemCount: (badges.length < _visibleBadges) ? badges.length : _visibleBadges,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  print(badges.length);
                  if (badge.isEarned) {
                    return BadgeTile(badge: badge);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
