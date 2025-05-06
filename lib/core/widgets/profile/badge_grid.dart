import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/profile/eco_badge.dart';

class BadgeGrid extends StatelessWidget {
  const BadgeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: [EcoBadge(), EcoBadge(), EcoBadge()],
      ),
    );
  }
}
