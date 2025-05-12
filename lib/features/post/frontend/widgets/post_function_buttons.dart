import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/features/post/backend/post_bloc.dart';

class PostFunctionButtons extends StatelessWidget {
  final TextEditingController postController;
  final VoidCallback? onAddImage;
  final VoidCallback? onCaptureImage;

  const PostFunctionButtons({
    super.key,
    required this.postController,
    this.onCaptureImage,
    this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Add image from Camera
        GestureDetector(
          onTap: onCaptureImage,
          child: Image.asset('assets/images/gallery-add.png', width: 50),
        ),

        SizedBox(width: 25),

        // Add  Image from Gallery
        GestureDetector(
          onTap: onAddImage,
          child: Image.asset('assets/images/gallery-add.png', width: 50),
        ),

        SizedBox(width: 25),

        // Add List (bullet point)
        GestureDetector(
          onTap: () {
            // Insert bullet list when tapped
            final currentText = postController.text;
            final selection = postController.selection;
            final newText = currentText.replaceRange(
              selection.start,
              selection.end,
              '• ', // Bullet point
            );

            postController.text = newText;

            // Place the cursor right after the bullet
            postController.selection = TextSelection.collapsed(
              offset: selection.start + 2,
            );
          },
          child: Image.asset('assets/images/task-square.png', width: 50),
        ),
      ],
    );
  }
}
