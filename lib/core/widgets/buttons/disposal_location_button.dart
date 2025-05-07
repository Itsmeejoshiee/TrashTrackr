import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class DisposalLocationButton extends StatelessWidget {
  const DisposalLocationButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/covers/map.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}