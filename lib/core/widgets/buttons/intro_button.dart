import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class IntroButton extends StatelessWidget {
  const IntroButton({
    super.key,
    required this.title,
    this.backgroundColor,
    this.color,
    required this.onPressed,
  });

  final String title;
  final Color? backgroundColor;
  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor ?? kLightGreen,
          borderRadius: BorderRadius.circular(90),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          title,
          style: kBodyLarge.copyWith(color: color ?? kDarkTeal),
        ),
      ),
    );
  }
}