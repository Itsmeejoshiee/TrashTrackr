import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ProfileSectionLabel extends StatelessWidget {
  const ProfileSectionLabel({
    super.key,
    required this.label,
    this.onShowMore,
  });

  final String label;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: kTitleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        (onShowMore != null) ? TextButton(
          onPressed: () {},
          child: Text(
            'Show more',
            style: kPoppinsBodyMedium.copyWith(color: kAvocado),
          ),
        ) : SizedBox(),
      ],
    );
  }
}
