// camera_service.dart
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraModule {
  /// Requests permission, finds a camera, initializes it, or throws.
  Future<CameraController> initializeController({
    ResolutionPreset preset = ResolutionPreset.high,
    int cameraIndex = 0,
  }) async {
    // 1. Ask for permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw CameraException('PERMISSION_DENIED', 'Camera permission denied');
    }

    // 2. Get available cameras
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('NO_CAMERA', 'No camera found on device');
    }

    // 3. Create & initialize
    final controller = CameraController(cameras[cameraIndex], preset);
    await controller.initialize();
    return controller;
  }
}
