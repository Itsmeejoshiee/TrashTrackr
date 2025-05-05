import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
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

  NavRoute _selectedRoute = NavRoute.badge;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
          backgroundColor: kLightGray,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/classify_title.png',
                    width: 182.27,
                    height: 95.77,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CameraPreview(controller),
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/capture.png',
                      width: 55,
                      height: 55,
                    ),
                    onPressed: () async {
                      try {
                        //file conversion to image > bytes
                        final XFile picture = await controller.takePicture();
                        final bytes = await picture.readAsBytes();

                        //Call the Gemini API to classify the waste
                        final response = await GeminiService().classifyWaste(
                          bytes,
                        );
                        //Temporary UI to show the response
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Waste Classification'),
                                content: Text(response),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
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
                ],
              ),
            ),
          ),
          bottomNavigationBar: MainNavigationBar(
            activeRoute: _selectedRoute,
            onSelect: _selectRoute,
          ),

          floatingActionButton: MultiActionFab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
