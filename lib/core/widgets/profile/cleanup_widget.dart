import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class CleanupWidget extends StatelessWidget {
  const CleanupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: AssetImage(
                  'assets/images/placeholder_profile.jpg',
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Eco Walk: Clean & Connect',
                style: kTitleMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Saturday, May 4, 2025 UTC 9:00 AM - 12:00 PM',
                style: kPoppinsBodySmall.copyWith(
                  color: kGray.withOpacity(0.5),
                ),
              ),
              Text(
                'Central Riversize Park,EcoZone Area B',
                style: kPoppinsBodySmall.copyWith(color: kAvocado),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
