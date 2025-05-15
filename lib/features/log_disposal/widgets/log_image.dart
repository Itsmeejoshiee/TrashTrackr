import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String) onImagePicked;

  const ImagePickerWidget({
    super.key,
    required this.initialImageUrl,
    required this.onImagePicked,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _currentImageUrl = image.path;
      });

      // Notify the parent widget about the new image path
      widget.onImagePicked(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_currentImageUrl == null) {
      imageWidget = Image.asset(
        'assets/images/placeholder.png',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (_currentImageUrl!.startsWith('http')) {
      imageWidget = Image.network(
        _currentImageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/placeholder.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      imageWidget = Image.file(
        File(_currentImageUrl!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/placeholder.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageWidget,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.add_a_photo, color: kForestGreen),
            ),
          ),
        ),
      ],
    );
  }
}
