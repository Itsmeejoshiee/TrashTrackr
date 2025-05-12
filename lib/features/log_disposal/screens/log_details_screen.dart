import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/disposal_guide.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_map.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_image.dart';
import 'package:trashtrackr/features/log_disposal/models/log_utils.dart';

class LogDetailsScreen extends StatefulWidget {
  final LogEntry entry;
  final Function(String) onImageUpdated;
  final Function(String notes, String quantity) onDetailsUpdated;

  const LogDetailsScreen({
    super.key,
    required this.entry,
    required this.onImageUpdated,
    required this.onDetailsUpdated,
  });

  @override
  State<LogDetailsScreen> createState() => _LogDetailsScreenState();
}

class _LogDetailsScreenState extends State<LogDetailsScreen> {
  String? _updatedImageUrl;
  final LatLng _disposalLocationCoordinates = const LatLng(37.7749, -122.4194);

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.entry.notes ?? '';
    _quantityController.text = widget.entry.quantity ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _updateDetails() {
    widget.onDetailsUpdated(_notesController.text, _quantityController.text);
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF4F4F4), // Set the background color
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Space for the fixed arrow and image
                  Center(
                    child: Image.asset(
                      'assets/images/titles/log_details.png', // Replace with the actual path to your image
                      height: 100, // Adjust the height of the image
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImagePickerWidget(
                          initialImageUrl: _updatedImageUrl ?? entry.imageUrl,
                          onImagePicked: (newImageUrl) {
                            setState(() {
                              _updatedImageUrl = newImageUrl;
                            });
                            widget.onImageUpdated(newImageUrl);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Title and Waste Type Icon together
                            Row(
                              children: [
                                Text(
                                  entry.title ?? 'Unknown Title',
                                  style: kTitleLarge.copyWith(
                                    color: kAvocado,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  getWasteTypeImage(entry.wasteType ?? 'unknown'), // Fetch from log_utils
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Edit icon aligned right
                            GestureDetector(
                              onTap: () {
                                print('Edit-default image clicked');
                              },
                              child: Image.asset(
                                'assets/images/icons/edit_default.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        PropertiesTile(
                          materials: entry.productProperties
                              .where((property) => property.startsWith('Material:'))
                              .map((property) => property.replaceFirst('Material: ', ''))
                              .toList(),
                          classification: entry.wasteType,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Product Info',
                          style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          entry.productInfo,
                          style: kTitleSmall.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Recommended Disposal Techniques',
                          style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DisposalGuide(
                          material: entry.wasteType,
                          guide: "Here's how to dispose of ${entry.productProperties} responsibly:",
                          toDo: entry.disposalGuideToDo,
                          notToDo: entry.disposalGuideNotToDo,
                          proTip: entry.disposalGuideProTip,
                        ),
                        const SizedBox(height: 23),
                        const SizedBox(height: 20),
                        Text(
                          'Notes (optional)',
                          style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your notes here',
                          ),
                          maxLines: 3,
                          onChanged: (value) => _updateDetails(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Quantity (optional)',
                          style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter quantity',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _updateDetails(),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Fixed Back Arrow leveled with the image
            Positioned(
              top: 100, // Match the height of the image
              left: 16,
              child: GestureDetector(
                onTap: () {
                  _updateDetails();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
