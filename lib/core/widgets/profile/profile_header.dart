import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.username,
    required this.image,
    required this.followers,
    required this.following,
  });

  final String username;
  final ImageProvider image;
  final int followers;
  final int following;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            username,
            style: kHeadlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$followers',
                  style: kTitleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Followers',
                  style: kLabelLarge.copyWith(
                    color: kAvocado.withOpacity(0.3),
                  ),
                ),
              ],
            ),
            CircleAvatar(
              foregroundImage: image,
              radius: 46,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$following',
                  style: kTitleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Following',
                  style: kLabelLarge.copyWith(
                    color: kAvocado.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
