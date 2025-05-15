import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.fullName,
    required this.profilePicture,
    required this.dropdown,
  });

  final String fullName;
  final String profilePicture;
  final Widget dropdown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage:
          (profilePicture.isNotEmpty)
              ? NetworkImage(profilePicture)
              : AssetImage('assets/images/placeholder_profile.jpg'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullName, style: kNameTextStyle),
            SizedBox(width: 220, child: dropdown),
          ],
        ),
      ],
    );
  }
}