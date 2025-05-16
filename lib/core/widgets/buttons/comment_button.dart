import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/comment/frontend/comment_screen.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    super.key,
    this.isActive = false,
    required this.onPressed,
    required this.count,
  });

  final bool isActive;
  final VoidCallback onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Image.asset(
            'assets/images/icons/comment_${isActive ? 'active' : 'inactive'}.png',
            height: 19,
          ),
          SizedBox(width: 5),
          Text(
            (count > 0) ? '$count  ' : 'Comment  ',
            style: kPoppinsBodySmall.copyWith(
              color: isActive ? kAvocado : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
