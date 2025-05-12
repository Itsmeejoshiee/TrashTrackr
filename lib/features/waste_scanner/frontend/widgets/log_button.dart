import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class LogButton extends StatelessWidget {
  LogButton({
    super.key,
    this.title = 'Log This',
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  final ButtonStyle flatButton = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey.shade800,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))
    )
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: flatButton,
        child: Text(
          title,
          style: kBodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
