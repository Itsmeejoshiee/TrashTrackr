import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class RoundedRectangleButton extends StatelessWidget {
  const RoundedRectangleButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = kAvocado,
  });

  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(3, 3),
              blurRadius: 3,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(-1, -1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: kTitleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}