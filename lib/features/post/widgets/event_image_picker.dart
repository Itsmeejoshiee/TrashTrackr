import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';

class EventImagePicker extends StatefulWidget {
  const EventImagePicker({
    super.key,
    this.eventEntry,
    this.image,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final EventModel? eventEntry;
  final Uint8List? image;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  @override
  State<EventImagePicker> createState() => _EventImagePickerState();
}

class _EventImagePickerState extends State<EventImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPickImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
        widget.image != null
            ? Stack(
          children: [
            Image.memory(
              widget.image!,
              width: double.infinity, // Make it wide
              height: 180,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: kLightGray,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: widget.onRemoveImage,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        )
            : (widget.eventEntry?.imageUrl != null &&
            widget.eventEntry!.imageUrl.isNotEmpty)
            ? Stack(
          children: [
            Image.network(
              widget.eventEntry!.imageUrl,
              width: double.infinity, // Make it wide
              height: 180,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: kLightGray,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: widget.onRemoveImage,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        )
            : Container(
          width: double.infinity, // Make it wide
          height: 180,
          color: kForestGreenLight.withOpacity(0.1),
          child: const Icon(
            Icons.add_a_photo,
            color: kForestGreenLight,
            size: 40,
          ),
        ),
      ),
    );
  }
}