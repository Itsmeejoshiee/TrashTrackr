import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostBloc {
  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    return image;
  }

  Future<XFile?> getCameraImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    return image;
  }
}
