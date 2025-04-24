import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(-2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: kTitleLarge.copyWith(
            color: kAppleGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}