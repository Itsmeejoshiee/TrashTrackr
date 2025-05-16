import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class LogButton extends StatelessWidget {
  const LogButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButton = TextButton.styleFrom(
      foregroundColor: textColor ?? Colors.white,
      backgroundColor: backgroundColor ?? Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(color: borderColor ?? Colors.grey.shade800, width: 2),
      ),
    );

    return SizedBox(
      width: 150,
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: flatButton,
        child: Text(
          title,
          style: kBodyLarge.copyWith(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
