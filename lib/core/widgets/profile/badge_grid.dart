import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/eco_badge.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/profile/badge_tile.dart';

class BadgeGrid extends StatefulWidget {
  const BadgeGrid({super.key, required this.badgeIdList});

  final List<int> badgeIdList;

  @override
  State<BadgeGrid> createState() => _BadgeGridState();
}

class _BadgeGridState extends State<BadgeGrid> {

  bool _isExpanded = false;
  int _visibleBadges = 3;

  List<Widget> _badgeTileBuilder() {
    List<Widget> badgeTiles = [];
    for (int i = 0; i < _visibleBadges; i++) {
      final id = widget.badgeIdList[i];
      final EcoBadge currentBadge = EcoBadge(id: id);
      badgeTiles.add(BadgeTile(badge: currentBadge));
    }
    return badgeTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Badges',
          style: kTitleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            if (_isExpanded) {
              setState(() {
                _visibleBadges = 3;
                _isExpanded = false;
              });
            } else {
              setState(() {
                _visibleBadges = widget.badgeIdList.length;
                _isExpanded = true;
              });
            }
          },
          child: Text(
            'Show ${(_isExpanded) ? 'less' : 'more'}',
            style: kPoppinsBodyMedium.copyWith(color: kAvocado),
          ),
        ),
      ],
    ),
        NeoBox(
          child: GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            physics: NeverScrollableScrollPhysics(),
            children: _badgeTileBuilder(),
          ),
        ),
      ],
    );
  }
}
