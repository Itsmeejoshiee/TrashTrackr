import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/services/image_service.dart';
import 'package:trashtrackr/core/utils/event_type.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';
import 'package:flutter/services.dart';

// const String kFontUrbanist = 'Urbanist';

class EventForm extends StatefulWidget {
  final EventModel? eventEntry;
  final Function(String)? onTitleChanged;
  final Function(String)? onDescChanged;
  final Function(EventType?)? onTypeSelect;
  final Function(DateTimeRange?)? onDateTimeRangeSelect;
  final Function(Uint8List?)? onImageSelect;

  const EventForm({
    super.key,
    this.eventEntry,
    this.onTitleChanged,
    this.onDescChanged,
    this.onTypeSelect,
    this.onDateTimeRangeSelect,
    this.onImageSelect,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late TextEditingController _eventTitleController;
  late TextEditingController _eventDescController;
  EventType? _eventType;
  DateTimeRange? _eventDateRange;
  Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();
    _eventTitleController = TextEditingController(
      text: widget.eventEntry?.title ?? '',
    );
    _eventDescController = TextEditingController(
      text: widget.eventEntry?.desc ?? '',
    );
    _eventType = widget.eventEntry?.type;
    _eventDateRange = widget.eventEntry?.dateRange;
  }

  @override
  void dispose() {
    _eventTitleController.dispose();
    _eventDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImageService().getImage();
      setState(() {
        _pickedImage = image;
      });
      widget.onImageSelect!(_pickedImage);
    } catch (e) {
      print("Error getting image: $e");
    }
  }

  Widget _iconNeoButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kForestGreenLight.withOpacity(0.13),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kForestGreenLight, size: 24),
      ),
    );
  }

  InputDecoration _customFieldDecoration({
    required String label,
    bool isDropdown = false,
    bool isMultiline = false,
    Color borderColor = Colors.grey,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: kPoppinsLabel,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kForestGreenLight, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  _pickedImage != null
                      ? Stack(
                        children: [
                          Image.memory(
                            _pickedImage!,
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
                                onTap: () {
                                  setState(() {
                                    _pickedImage = null;
                                  });
                                  widget.onImageSelect!(_pickedImage);
                                },
                                child: Icon(Icons.close, color: Colors.black, size: 30),
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
                                onTap: () {
                                  setState(() {
                                    _pickedImage = null;
                                  });
                                  widget.onImageSelect!(_pickedImage);
                                },
                                child: Icon(Icons.close, color: Colors.black, size: 30),
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
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "Event Details",
            style: kTitleMedium,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _eventTitleController,
          style: kPoppinsLabel,
          cursorColor: kForestGreenLight,
          // <-- Add this line
          decoration: _customFieldDecoration(label: "Event Name"),
          onChanged: (value) {
            widget.onTitleChanged!(_eventTitleController.text);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<EventType>(
          value: _eventType,
          items:
              EventType.values
                  .map(
                    (event) => DropdownMenuItem(
                      value: event,
                      child: Text(
                        event.name.capitalize(),
                        style: kPoppinsLabel,
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) {
            setState(() => _eventType = val);
            widget.onTypeSelect!(_eventType);
          },
          decoration: _customFieldDecoration(label: "Event Type"),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    datePickerTheme: DatePickerThemeData(
                      rangeSelectionBackgroundColor: kAppleGreen.withOpacity(0.5),
                    ),
                    colorScheme: ColorScheme.light(
                      primary: kForestGreenLight, // header background color
                      onPrimary: Colors.white, // header text color
                      onSurface: kAvocado,
                      onBackground: kAppleGreen, // body text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: kForestGreenLight, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() => _eventDateRange = picked);
              widget.onDateTimeRangeSelect!(_eventDateRange);
            }
          },
          child: AbsorbPointer(
            child: TextField(
              style: kPoppinsLabel,
              cursorColor: kForestGreenLight,
              // <-- Add this line
              readOnly: true,
              decoration: _customFieldDecoration(
                label: "Select date and time",
              ).copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: kForestGreenLight,
                ),
                hintText:
                    _eventDateRange == null
                        ? "Pick a date range"
                        : "${_eventDateRange!.start.month}/${_eventDateRange!.start.day}/${_eventDateRange!.start.year} - "
                            "${_eventDateRange!.end.month}/${_eventDateRange!.end.day}/${_eventDateRange!.end.year}",
                hintStyle: kPoppinsLabel,
              ),
              controller: TextEditingController(
                text:
                    _eventDateRange == null
                        ? ""
                        : "${_eventDateRange!.start.month}/${_eventDateRange!.start.day}/${_eventDateRange!.start.year} - "
                            "${_eventDateRange!.end.month}/${_eventDateRange!.end.day}/${_eventDateRange!.end.year}",
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _eventDescController,
          style: kPoppinsLabel,
          cursorColor: kForestGreenLight,
          // <-- Add this line
          decoration: _customFieldDecoration(
            label: "Event description",
            borderColor: kForestGreenLight,
          ),
          maxLines: 3,
          onChanged: (value) {
            widget.onDescChanged!(_eventDescController.text);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
