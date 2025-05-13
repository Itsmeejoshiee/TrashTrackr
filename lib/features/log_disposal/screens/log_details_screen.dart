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

  bool _isEditing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _productInfoController = TextEditingController();
  final TextEditingController _toDoController = TextEditingController();
  final TextEditingController _notToDoController = TextEditingController();
  final TextEditingController _proTipController = TextEditingController();



  @override
  void initState() {
  super.initState();
  _notesController.text = widget.entry.notes ?? '';
  _quantityController.text = widget.entry.quantity ?? '';
  _titleController.text = widget.entry.title ?? '';
  _productInfoController.text = widget.entry.productInfo ?? '';
_toDoController.text = widget.entry.disposalGuideToDo.join('\n');
_notToDoController.text = widget.entry.disposalGuideNotToDo.join('\n');
  _proTipController.text = widget.entry.disposalGuideProTip ?? '';
}


  @override
  void dispose() {
  _notesController.dispose();
  _quantityController.dispose();
  _titleController.dispose();
  _productInfoController.dispose();
  _toDoController.dispose();
  _notToDoController.dispose();
  _proTipController.dispose();
  super.dispose();
}


  void _updateDetails() {
  setState(() {
    widget.entry.notes = _notesController.text;
    widget.entry.quantity = _quantityController.text;
    widget.entry.title = _titleController.text;
    widget.entry.productInfo = _productInfoController.text;
    widget.entry.disposalGuideToDo = _toDoController.text.split('\n');
    widget.entry.disposalGuideNotToDo = _notToDoController.text.split('\n');
    widget.entry.disposalGuideProTip = _proTipController.text;
  });

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
                                setState(() {
                                  if (_isEditing) {
                                    _updateDetails(); // Save input
                                  }
                                  _isEditing = !_isEditing;
                                });
                              },
                              child: Image.asset(
                                _isEditing
                                    ? 'assets/images/icons/edit_active.png'
                                    : 'assets/images/icons/edit_default.png',
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
                          _isEditing
                              ? TextField(
                                  controller: _productInfoController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter product info',
                                  ),
                                  maxLines: null,
                                )
                              : Text(
                                  entry.productInfo,
                                  style: kTitleSmall.copyWith(color: Colors.black54),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            'Recommended Disposal Techniques',
                            style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _isEditing
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('To Do:', style: kTitleSmall.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    TextField(
                                      controller: _toDoController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Separate To-Do actions with new lines',
                                      ),
                                      maxLines: null,
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Not To Do:', style: kTitleSmall.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    TextField(
                                      controller: _notToDoController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Separate Not-To-Do actions with new lines',
                                      ),
                                      maxLines: null,
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Pro Tip:', style: kTitleSmall.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    TextField(
                                      controller: _proTipController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter pro tip',
                                      ),
                                      maxLines: null,
                                    ),
                                  ],
                                )
                              : DisposalGuide(
                                  material: entry.wasteType,
                                  guide: "Here's how to dispose of ${entry.productProperties} responsibly:",
                                  toDo: entry.disposalGuideToDo,
                                  notToDo: entry.disposalGuideNotToDo,
                                  proTip: entry.disposalGuideProTip,
                                ),
                          const SizedBox(height: 20),
                          Text(
                            'Notes (optional)',
                            style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _isEditing
                              ? TextField(
                                  controller: _notesController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your notes here',
                                  ),
                                  maxLines: 3,
                                )
                              : (entry.notes != null && entry.notes!.isNotEmpty
                                  ? Text(
                                      entry.notes!,
                                      style: kTitleSmall.copyWith(color: Colors.black54),
                                    )
                                  : const Text("No notes available.")),
                          const SizedBox(height: 20),
                          Text(
                            'Quantity (optional)',
                            style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _isEditing
                              ? TextField(
                                  controller: _quantityController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter quantity',
                                  ),
                                  keyboardType: TextInputType.number,
                                )
                              : (entry.quantity != null && entry.quantity!.isNotEmpty
                                  ? Text(
                                      entry.quantity!,
                                      style: kTitleSmall.copyWith(color: Colors.black54),
                                    )
                                  : const Text("No quantity specified.")),
                          const SizedBox(height: 20),
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
