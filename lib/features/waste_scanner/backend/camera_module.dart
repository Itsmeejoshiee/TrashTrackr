import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraModule {
  //Initializes the camera controller with the given resolution preset and camera index.
  Future<CameraController> initializeController({
    ResolutionPreset preset = ResolutionPreset.high,
    int cameraIndex = 0, //Back CAMERA is 0, Front Camera is 1
  }) async {
    // Asks for permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw CameraException('PERMISSION_DENIED', 'Camera permission denied');
    }

    // Get available cameras
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('NO_CAMERA', 'No camera found on device');
    }

    // Create & initialize
    final controller = CameraController(cameras[cameraIndex], preset);
    await controller.initialize();
    return controller;
  }
}
