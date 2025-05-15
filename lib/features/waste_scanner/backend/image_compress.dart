import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

Future<File?> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${file.parent.path}/compressed_${file.path.split('/').last}',
    quality: 70,
  );
  return result != null ? File(result.path) : null;
}
