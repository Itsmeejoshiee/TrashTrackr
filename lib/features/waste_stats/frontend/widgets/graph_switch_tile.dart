import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class GraphSwitchTile extends StatelessWidget {
  const GraphSwitchTile({
    super.key,
    this.child,
    required this.value,
    required this.firstViewTitle,
    required this.secondViewTitle,
    required this.onFirstView,
    required this.onSecondView,
  });

  final Widget? child;
  final bool value;
  final String firstViewTitle;
  final String secondViewTitle;
  final VoidCallback onFirstView;
  final VoidCallback onSecondView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        // Weekly
        GestureDetector(
          onTap: onFirstView,
          child: Text(
            firstViewTitle,
            style:
            (value) ? kTitleSmall.copyWith(color: kAvocado, fontWeight: FontWeight.w800) : kTitleSmall,
          ),
        ),

        SizedBox(width: 30),

        // Monthly
        GestureDetector(
          onTap: onSecondView,
          child: Text(
            secondViewTitle,
            style:
            (!value) ? kTitleSmall.copyWith(color: kAvocado, fontWeight: FontWeight.w800) : kTitleSmall,
          ),
        )
      ],
    );
  }
}
