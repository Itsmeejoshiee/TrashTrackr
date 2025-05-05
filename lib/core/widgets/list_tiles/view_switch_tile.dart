import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class ViewSwitchTile extends StatelessWidget {
  const ViewSwitchTile({
    super.key,
    required this.value,
    required this.firstViewTitle,
    required this.secondViewTitle,
    required this.onFirstView,
    required this.onSecondView,
  });

  final bool value;
  final String firstViewTitle;
  final String secondViewTitle;
  final VoidCallback onFirstView;
  final VoidCallback onSecondView;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onFirstView,
            child: Text(
              firstViewTitle,
              style:
              (value) ? kBodyLarge.copyWith(color: kAvocado) : kBodyLarge,
            ),
          ),
          SizedBox(),
          GestureDetector(
            onTap: onSecondView,
            child: Text(
              secondViewTitle,
              style:
              (!value) ? kBodyLarge.copyWith(color: kAvocado) : kBodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}