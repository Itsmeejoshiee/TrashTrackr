import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label, this.onShowMore});

  final String label;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: kTitleLarge.copyWith(fontWeight: FontWeight.bold)),
        (onShowMore != null)
            ? GestureDetector(
          onTap: () {},
          child: Text(
            'Show more',
            style: kPoppinsBodyMedium.copyWith(color: Colors.black),
          ),
        )
            : SizedBox(),
      ],
    );
  }
}