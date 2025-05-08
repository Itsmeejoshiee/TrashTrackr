import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

enum ProfileSection { posts, wasteLog, cleanup }

class ProfileSwitchTile extends StatelessWidget {
  const ProfileSwitchTile({
    super.key,
    required this.selected,
    required this.onPosts,
    required this.onWasteLog,
    required this.onCleanup,
  });

  final ProfileSection selected;
  final VoidCallback onPosts;
  final VoidCallback onWasteLog;
  final VoidCallback onCleanup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onPosts,
            child: Text(
              'Posts',
              style: kTitleSmall.copyWith(
                color:
                (selected == ProfileSection.posts)
                    ? kAvocado
                    : kGray.withOpacity(0.3),
              ),
            ),
          ),
          TextButton(
            onPressed: onWasteLog,
            child: Text(
              'Waste Log',
              style: kTitleSmall.copyWith(
                color:
                (selected == ProfileSection.wasteLog)
                    ? kAvocado
                    : kGray.withOpacity(0.3),
              ),
            ),
          ),
          TextButton(
            onPressed: onCleanup,
            child: Text(
              'Clean-up',

              style: kTitleSmall.copyWith(
                color:
                (selected == ProfileSection.cleanup)
                    ? kAvocado
                    : kGray.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}