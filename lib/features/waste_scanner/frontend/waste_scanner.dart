import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/features/waste_scanner/backend/camera_module.dart';
import 'package:trashtrackr/features/waste_scanner/backend/gemini_service.dart';

class WasteScannerPage extends StatefulWidget {
  const WasteScannerPage({Key? key}) : super(key: key);

  @override
  _WasteScannerPageState createState() => _WasteScannerPageState();
}

class _WasteScannerPageState extends State<WasteScannerPage> {
  late final Future<CameraController> _controllerFuture;
  final _service = CameraModule();

  @override
  void initState() {
    super.initState();
    _controllerFuture = _service.initializeController();
  }

  @override
  void dispose() {
    // dispose once the Future completes
    _controllerFuture.then((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraController>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final controller = snapshot.data!;

        return Scaffold(
          body: Column(
            children: [
              Expanded(child: CameraPreview(controller)),
              const SizedBox(height: 40),
              IconButton(
                icon: const Icon(Icons.camera_alt, size: 50),
                onPressed: () async {
                  try {
                    //file conversion to image > bytes
                    final XFile picture = await controller.takePicture();
                    final bytes = await picture.readAsBytes();

                    //Call the Gemini API to classify the waste
                    final response = await GeminiService().classifyWaste(bytes);
                    //Temporary UI to show the response
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Waste Classification'),
                            content: Text(response),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error taking picture: $e')),
                    );
                  }
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
