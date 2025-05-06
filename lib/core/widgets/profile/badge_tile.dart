import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/models/eco_badge.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({
    super.key,
    required this.badge,
  });

  final EcoBadge badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/badges/colored/${badge.imagePath}', width: 53, height: 61.38),
        SizedBox(height: 5),
        Text(
          badge.title,
          style: kLabelSmall.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
