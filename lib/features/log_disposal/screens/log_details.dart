import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/core/services/waste_entry_service.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_disposal_screen.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/log_button.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/widgets/properties_tile.dart';
import 'package:trashtrackr/features/waste_stats/frontend/waste_stats_screen.dart';

import '../../../core/utils/constants.dart';
import '../../../core/widgets/buttons/disposal_location_button.dart';
import '../../waste_scanner/frontend/widgets/disposal_guide.dart';
import '../../waste_scanner/frontend/widgets/scan_result_field.dart';
import '../models/log_utils.dart';
import '../widgets/log_image.dart';

class LogDetails extends StatefulWidget {
  final ScanResult scanResult;
  final Function(String) onImageUpdated;
  final VoidCallback? onDelete;
  final String fromScreen;

  final Function(String notes, String quantity) onDetailsUpdated;

  const LogDetails({
    super.key,
    required this.scanResult,
    required this.onImageUpdated,
    required this.onDetailsUpdated,
    this.onDelete,
    required this.fromScreen,
  });

  @override
  State<LogDetails> createState() => _LogDetailsState();
}

class _LogDetailsState extends State<LogDetails> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.scanResult.notes;
    _quantityController.text = widget.scanResult.qty.toString();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _quantityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _updatedImageUrl;
  bool _isEditing = false;

  void _delDisposal() {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Want to delete this log?",
      desc: "You can’t undo this!",
      image: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
        child: Image.asset("assets/images/icons/logDelete.png", width: 90),
      ),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFFE6E6E6),
          radius: BorderRadius.circular(30),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: kTitleSmall),
        ),
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xffEA4A57),
          radius: BorderRadius.circular(30),
          onPressed: () async {
            if (widget.scanResult.id != null) {
              await WasteEntryService().deleteWasteEntry(widget.scanResult.id!);
            } else {
              print('No ID found on entry, cannot delete.');
            }
            if (mounted) {
              Navigator.pop(context);
            }

            if (widget.fromScreen == 'history') {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WasteStatsScreen(updateView: false),
                  ),
                );
              }
            } else if (widget.fromScreen == 'disposal') {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogDisposalScreen()),
                );
              }
              widget.onDelete?.call();
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Delete',
              style: kTitleSmall.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.scanResult;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),
        child: SingleChildScrollView(
          controller: _scrollController,
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
                  result.productName.length > 30
                      ? Flexible(
                        child: Text(
                          result.productName,
                          style: kTitleLarge.copyWith(
                            color: kAvocado,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                      : Text(
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
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
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

              // Details
              PropertiesTile(
                materials: result.materials,
                classification: result.classification,
              ),

              SizedBox(height: 23),

              Text(
                'Product Info',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                result.prodInfo,
                style: kPoppinsBodyMedium.copyWith(color: Colors.black54),
              ),

              SizedBox(height: 23),

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

              DisposalLocationButton(),

              SizedBox(height: 20),

              // Notes
              Text(
                'Notes (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ScanResultField(controller: _noteController),

              SizedBox(height: 20),

              // Quantity
              Text(
                'Quantity (optional)',
                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ScanResultField(controller: _quantityController, width: 80),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LogButton(
                    title: 'Delete',
                    backgroundColor: Colors.white,
                    textColor: Colors.grey.shade800,
                    onPressed: () {
                      _delDisposal();
                    },
                  ),

                  LogButton(
                    title: 'Save',
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final wasteEntryService = WasteEntryService();

                      if (user == null) return;

                      final updatedNotes = _noteController.text.trim();
                      final updatedQty = _quantityController.text.trim();

                      final updatedResult = widget.scanResult.copyWith(
                        notes: updatedNotes,
                        qty: int.tryParse(updatedQty) ?? 1,
                        imageUrl:
                            _updatedImageUrl ?? widget.scanResult.imageUrl,
                      );

                      try {
                        await wasteEntryService.updateWasteEntries(
                          user,
                          updatedResult,
                        );
                        widget.onDetailsUpdated(updatedNotes, updatedQty);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to update entry for ID: ${updatedResult.id ?? "unknown"} & ${user.uid}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
