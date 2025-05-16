import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/services/public_user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/badge_model.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/profile/badge_tile.dart';

class PublicBadgeGrid extends StatefulWidget {
  const PublicBadgeGrid({super.key, required this.uid});

  final String uid;

  @override
  State<PublicBadgeGrid> createState() => _PublicBadgeGridState();
}

class _PublicBadgeGridState extends State<PublicBadgeGrid> {

  final PublicUserService _publicUserService = PublicUserService();
  
  bool _isExpanded = false;
  int _visibleBadges = 3;

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
    return StreamBuilder(
      stream: _publicUserService.getBadgeStream(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Badge data is not available.'));
        }

        final badges = _buildEarnedBadgeList(snapshot.data!);
        if (badges.isEmpty) return SizedBox();

        return Column(
          children: [
            SizedBox(height: 32),
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
