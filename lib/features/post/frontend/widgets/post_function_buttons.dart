import 'package:flutter/material.dart';

class PostFunctionButtons extends StatelessWidget {
  final TextEditingController postController;

  const PostFunctionButtons({super.key, required this.postController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Add image
        GestureDetector(
          onTap: () {
            // Handle adding image
          },
          child: Image.asset('assets/images/gallery-add.png', width: 50),
        ),

        SizedBox(width: 25),

        // Add Emoji
        GestureDetector(
          onTap: () {
            // Handle adding emoji
          },
          child: Image.asset('assets/images/emoji-normal.png', width: 50),
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
            postController.selection = TextSelection.collapsed(offset: selection.start + 2);
          },
          child: Image.asset('assets/images/task-square.png', width: 50),
        ),
      ],
    );
  }
}

