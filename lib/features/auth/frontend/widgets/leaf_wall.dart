import 'package:flutter/widgets.dart';

class LeafWall extends StatelessWidget {
  const LeafWall({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.65, // Set this to control how much vertical space the image takes
      width: double.infinity, // Full screen width
      child: Stack(
        clipBehavior: Clip.none, // Important: Allow overflow
        alignment: Alignment.bottomCenter, // Align to bottom for proper stacking
        children: [
          Positioned(
            bottom: -50, // Overflow to top by 50px (adjust as needed)
            left: -80, // Overflow to left by 20px
            right: -80, // Overflow to right by 20px
            child: Image.asset(
              'assets/images/leaf_wall.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}