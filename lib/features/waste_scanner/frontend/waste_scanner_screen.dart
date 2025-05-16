// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/badge_service.dart';


import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/features/waste_scanner/backend/camera_module.dart';
import 'package:trashtrackr/features/waste_scanner/backend/gemini_service.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/scan_result_screen.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import '../backend/image_compress.dart';

class WasteScannerScreen extends StatefulWidget {
  const WasteScannerScreen({super.key});

  @override
  _WasteScannerScreenState createState() => _WasteScannerScreenState();
}

class _WasteScannerScreenState extends State<WasteScannerScreen> {


  final ActivityService _activityService = ActivityService();
  final BadgeService _badgeService = BadgeService();
  late final Future<CameraController> _controllerFuture;
  final _service = CameraModule();
  NavRoute _selectedRoute = NavRoute.badge;
  bool _isProcessing = false;

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
            body: Center(child: CircularProgressIndicator(color: kAvocado)),
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              'Dashboard',
              style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/titles/classify_title.png',
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

                  _isProcessing
                      ? CircularProgressIndicator(color: kAvocado)
                      : IconButton(
                        icon: Image.asset(
                          'assets/images/icons/capture.png',
                          width: 55,
                          height: 55,
                        ),
                        onPressed: () async {
                          setState(() {
                            _isProcessing = true;
                            _activityService.logActivity('scan');
                          });
                          try {
                            final XFile picture =
                                await controller.takePicture();
                            final file = File(picture.path);

                            final File? compressedFile = await compressImage(
                              file,
                            );
                            if (compressedFile == null) {
                              throw Exception("Image compression failed.");
                            }

                            final Uint8List compressedBytes =
                                await compressedFile.readAsBytes();

                            final ref = FirebaseStorage.instance.ref().child(
                              'scanned_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
                            );
                            await ref.putData(
                              compressedBytes,
                              SettableMetadata(contentType: 'image/jpeg'),
                            );

                            final imageUrl = await ref.getDownloadURL();

                            final result = await GeminiService().classifyWaste(
                              compressedBytes,
                            );

                            final resultWithImage = ScanResult(
                              productName: result.productName,
                              materials: result.materials,
                              prodInfo: result.prodInfo,
                              classification: result.classification,
                              toDo: result.toDo,
                              notToDo: result.notToDo,
                              proTip: result.proTip,
                              timestamp: result.timestamp,
                              imageUrl: imageUrl,
                            );

                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ScanResultScreen(
                                        scanResult: resultWithImage,
                                      ),
                                ),
                              );
                            }
                            await _activityService.logActivity('scan');
                            _badgeService.checkTrashTrackrOg();
                            _badgeService.checkScannerRookie();
                            _badgeService.checkGreenStreaker();
                            _badgeService.checkDailyDiligent();
                            _badgeService.checkWeekendWarrior();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isProcessing = false;
                              });
                            }
                          }
                        },
                      ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
