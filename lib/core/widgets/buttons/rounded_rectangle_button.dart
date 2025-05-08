import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class RoundedRectangleButton extends StatelessWidget {
  const RoundedRectangleButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = kAvocado,
    this.width,
    this.height,
  });

  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
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
            style: kTitleSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
