import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:flutter/services.dart';

class PostImagePreview extends StatelessWidget {
  final Uint8List image;
  final VoidCallback onRemove;

  const PostImagePreview({required this.image, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            image,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: kLightGray,
              borderRadius: BorderRadius.circular(30),
            ),
            child: GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, color: Colors.black, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}