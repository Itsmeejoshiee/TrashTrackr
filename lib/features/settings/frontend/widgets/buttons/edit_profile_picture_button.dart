import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class EditProfilePictureButton extends StatelessWidget {
  const EditProfilePictureButton({
    super.key,
    required this.image,
    required this.onPressed,
  });

  final ImageProvider image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundImage: image,
        radius: 50,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(Icons.edit, color: Colors.black, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}