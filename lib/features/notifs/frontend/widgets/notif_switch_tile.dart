import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class NotifSwitchTile extends StatelessWidget {
  const NotifSwitchTile({
    super.key,
    required this.value,
    required this.onUpdates,
    required this.onBookmarks,
  });

  final bool value;
  final VoidCallback onUpdates;
  final VoidCallback onBookmarks;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onUpdates,
            child: Text(
              'Updates',
              style:
              (value) ? kBodyLarge.copyWith(color: kAvocado) : kBodyLarge,
            ),
          ),
          SizedBox(),
          GestureDetector(
            onTap: onBookmarks,
            child: Text(
              'Bookmarks',
              style:
              (!value) ? kBodyLarge.copyWith(color: kAvocado) : kBodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}