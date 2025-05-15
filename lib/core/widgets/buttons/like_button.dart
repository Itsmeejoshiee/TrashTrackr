import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, this.isActive = false, required this.onPressed});

  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        spacing: 5,
        children: [
          Image.asset(
            'assets/images/icons/like_${isActive ? 'active' : 'inactive'}.png',
            height: 16,
          ),
          (!isActive) ? Text(
            'Like  ',
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