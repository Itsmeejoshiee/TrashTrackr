import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class LogButton extends StatelessWidget {
  const LogButton({
    super.key,
    this.title = 'Log This',
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 150,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: kBodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
