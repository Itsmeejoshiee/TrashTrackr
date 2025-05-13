import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/features/log_disposal/widgets/log_edit.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';

import '../../../core/utils/constants.dart';
import '../../../core/widgets/buttons/disposal_location_button.dart';
import '../../waste_scanner/frontend/widgets/disposal_guide.dart';
import '../models/log_utils.dart';
import '../widgets/log_image.dart';

class LogDetails extends StatefulWidget {
  final ScanResult scanResult;
  final Function(String) onImageUpdated;
  final Function(String notes, String quantity) onDetailsUpdated;

  const LogDetails({
    super.key,
    required this.scanResult,
    required this.onImageUpdated,
    required this.onDetailsUpdated,
  });

  @override
  State<LogDetails> createState() => _LogDetailsState();
}

class _LogDetailsState extends State<LogDetails> {
  String? _updatedImageUrl;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {

    final result = widget.scanResult;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              Center(
                child: Image.asset(
                  'assets/images/titles/log_details.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),

              // Image picker
              ImagePickerWidget(
                initialImageUrl: _updatedImageUrl ?? result.imageUrl,
                onImagePicked: (newImageUrl) {
                  setState(() {
                    _updatedImageUrl = newImageUrl;
                  });
                  widget.onImageUpdated(newImageUrl);
                },
              ),

              SizedBox(height: 10),

              // Item name
              Row(
                children: [
                  Text(
                    result.productName,
                    style: kTitleLarge.copyWith(
                      color: kAvocado,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),

                  Image.asset(
                    getWasteTypeImage(result.classification),
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),

                  Expanded(child: Container()),

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

              // conditon
              _isEditing
              ? LogEdit(
                scanResult: result,
                // onDetailsUpdated: (updatedEntry) {
                //   widget.onDetailsUpdated(
                //     updatedEntry.notes ?? ''
                //     updatedEntry.qty.toString() ?? '',
                //   );
                // },
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertiesTile(
                      materials: result.materials,
                      classification: result.classification
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Recommended Disposal Techniques',
                    style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DisposalGuide(
                    material: result.productName,
                    guide: result.productName,
                    toDo: result.toDo,
                    notToDo: result.notToDo,
                    proTip: result.proTip,
                  ),

                  SizedBox(height: 23),
                  Text(
                    'Disposal Locations',
                    style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DisposalLocationButton(onPressed: () {}),

                  SizedBox(height: 20),

                  // Notes
                  Text(
                    'Notes (optional)',
                    style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  (result.notes != null && result.notes!.isNotEmpty
                      ? Text(
                    result.notes!,
                    style: kTitleSmall.copyWith(color: Colors.black54),
                  )
                      : const Text("No notes available.")),

                  SizedBox(height: 20),
                  // Quantity
                  Text(
                    'Quantity (optional)',
                    style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  (result.qty != null
                      ? Text(
                    result.qty.toString(),
                    style: kTitleSmall.copyWith(color: Colors.black54),
                  )
                      : const Text("No quantity specified.")),

                  SizedBox(height: 50),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }
}
