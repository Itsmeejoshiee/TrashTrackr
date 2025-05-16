import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/disposal_guide.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_image.dart';
import 'package:trashtrackr/features/log_disposal/models/log_utils.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_editable.dart';

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
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF4F4F4),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Image.asset(
                      'assets/images/titles/log_details.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image picker
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
                        // Title row with edit icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.title,
                                      style: kTitleLarge.copyWith(
                                        color: kAvocado,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      // No overflow or maxLines, so the title is fully shown
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    getWasteTypeImage(entry.wasteType),
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
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
                        const SizedBox(
                          height: 4,
                        ), // Make materials closer to the title
                        _isEditing
                            ? LogEditableFields(
                              logEntry: widget.entry,
                              onDetailsUpdated: (updatedEntry) {
                                setState(() {
                                  widget.entry.title = updatedEntry.title;
                                  widget.entry.productProperties =
                                      updatedEntry.productProperties;
                                  widget.entry.productInfo =
                                      updatedEntry.productInfo;
                                  widget.entry.notes = updatedEntry.notes;
                                  widget.entry.quantity = updatedEntry.quantity;
                                  widget.entry.disposalGuideProTip =
                                      updatedEntry.disposalGuideProTip;
                                  widget.entry.disposalGuideToDo =
                                      updatedEntry.disposalGuideToDo;
                                  widget.entry.disposalGuideNotToDo =
                                      updatedEntry.disposalGuideNotToDo;
                                  widget.entry.wasteType =
                                      updatedEntry.wasteType;
                                });
                                widget.onDetailsUpdated(
                                  updatedEntry.notes ?? '',
                                  updatedEntry.quantity ?? '',
                                );
                              },
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Materials (no border)
                                const SizedBox(height: 4),
                                PropertiesTile(
                                  materials:
                                      entry.productProperties
                                          .where(
                                            (p) => p.startsWith('Material:'),
                                          )
                                          .map(
                                            (p) => p.replaceFirst(
                                              'Material: ',
                                              '',
                                            ),
                                          )
                                          .toList(),
                                  classification: entry.wasteType,
                                ),
                                const SizedBox(height: 16),
                                // Product Info
                                Text(
                                  'Product Info',
                                  style: kBodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  entry.productInfo,
                                  style: kTitleSmall.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Disposal Guide
                                Text(
                                  'Recommended Disposal Techniques',
                                  style: kBodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DisposalGuide(
                                  material: entry.wasteType,
                                  guide:
                                      "Here's how to dispose of ${entry.productProperties} responsibly:",
                                  toDo: entry.disposalGuideToDo,
                                  notToDo: entry.disposalGuideNotToDo,
                                  proTip: entry.disposalGuideProTip,
                                ),
                                const SizedBox(height: 20),
                                // Notes
                                Text(
                                  'Notes (optional)',
                                  style: kBodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                (entry.notes != null && entry.notes!.isNotEmpty
                                    ? Text(
                                      entry.notes!,
                                      style: kTitleSmall.copyWith(
                                        color: Colors.black54,
                                      ),
                                    )
                                    : const Text("No notes available.")),
                                const SizedBox(height: 20),
                                // Quantity
                                Text(
                                  'Quantity (optional)',
                                  style: kBodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                (entry.quantity != null &&
                                        entry.quantity!.isNotEmpty
                                    ? Text(
                                      entry.quantity!,
                                      style: kTitleSmall.copyWith(
                                        color: Colors.black54,
                                      ),
                                    )
                                    : const Text("No quantity specified.")),
                                const SizedBox(height: 20),
                              ],
                            ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Back button
            Positioned(
              top: 100,
              left: 16,
              child: GestureDetector(
                onTap: () {
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
