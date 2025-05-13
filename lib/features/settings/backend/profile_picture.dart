import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/user_provider.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePicture {

  Future<Uint8List?> selectImage(ImageSource source) async {
    // Pick an image from source (gallery or camera)
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {

      // Crop image and transform it into Uint8List
      final File croppedImage = await cropImage(pickedImage);

      var imageBytes = await FlutterImageCompress.compressWithFile(
        croppedImage.path,
        quality: 50,
        rotate: 0,
        autoCorrectionAngle: true,
      );

      return imageBytes;
    }

    return null;
  }

  Future<File> cropImage(XFile? imageFile) async {
    final ImageCropper cropper = ImageCropper();
    final CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: kAvocado,
          backgroundColor: kLightGray,
          activeControlsWidgetColor: kAppleGreen,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    return File(croppedImage!.path);
  }

  Future<void> update(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final UserService userService = UserService(context);
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await ProfilePicture().selectImage(ImageSource.gallery);
                  await userService.uploadProfileImage(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await ProfilePicture().selectImage(ImageSource.camera);
                  await userService.uploadProfileImage(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }

}