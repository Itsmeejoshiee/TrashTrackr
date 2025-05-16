import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/comment/frontend/comment_screen.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    super.key,
    this.isActive = false,
    required this.onPressed,
    required this.label,
  });

  final bool isActive;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        spacing: 5,
        children: [
          Image.asset(
            'assets/images/icons/comment_${isActive ? 'active' : 'inactive'}.png',
            height: 19,
          ),
          (!isActive) ? Text(
            label,
            style:
            (!isActive)
                ? kPoppinsBodySmall
                : kPoppinsBodySmall.copyWith(
              color: kAvocado,
              fontWeight: FontWeight.bold,
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}