import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class PostBloc {
  Future<Uint8List?> getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    Uint8List? compressedImage = await compressImage(image!);
    return compressedImage;
  }

  Future<Uint8List?> getCameraImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    Uint8List? compressedImage = await compressImage(image!);
    return compressedImage;
  }

  Future<Uint8List?> compressImage(XFile image) async {
    var result = await FlutterImageCompress.compressWithFile(
      image.path,
      quality: 50,
      rotate: 0,
      autoCorrectionAngle: true,
    );
    return result;
  }
}
