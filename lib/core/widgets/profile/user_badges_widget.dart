import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/profile/badge_widget.dart';

class UserBadgesWidget extends StatelessWidget {
  const UserBadgesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: [BadgeWidget(), BadgeWidget(), BadgeWidget()],
      ),
    );
  }
}
