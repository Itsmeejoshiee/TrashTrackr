import 'package:flutter/material.dart';
import 'package:trashtrackr/features/post/models/post_entry.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

const kForestGreen = Color(0xFF819D39);
const String kFontUrbanist = 'Urbanist';
const String kFontPoppins = 'Poppins';

class EventForm extends StatefulWidget {
  final EventEntry? eventEntry;

  const EventForm({super.key, this.eventEntry});

  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  late TextEditingController _eventNameController;
  late TextEditingController _eventDescController;
  String? _eventType;
  DateTimeRange? _eventDateRange;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(
      text: widget.eventEntry?.eventType ?? '',
    );
    _eventDescController = TextEditingController(
      text: widget.eventEntry?.eventDescription ?? '',
    );
    _eventType = widget.eventEntry?.eventType;
    _eventDateRange = widget.eventEntry?.dateRange;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
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
          color: kForestGreen.withOpacity(0.13),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kForestGreen, size: 24),
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
      labelStyle: const TextStyle(
        fontFamily: kFontPoppins,
        color: Colors.black87,
      ),
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
        borderSide: BorderSide(color: kForestGreen, width: 2),
      ),
    );
  }

  /// 🔹 This is the method PostScreen will call using the GlobalKey
  EventEntry? getEventEntry() {
    if (_eventType == null || _eventDateRange == null) return null;

    return EventEntry(
      imageUrl: '', // To be updated if uploading to storage
      eventType: _eventType!,
      dateRange: _eventDateRange!,
      eventDescription: _eventDescController.text,
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
                      ? Image.file(
                        _pickedImage!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                      : widget.eventEntry?.imageUrl != null &&
                          widget.eventEntry!.imageUrl.isNotEmpty
                      ? Image.network(
                        widget.eventEntry!.imageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: double.infinity,
                        height: 180,
                        color: kForestGreen.withOpacity(0.1),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: kForestGreen,
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
            style: TextStyle(
              fontFamily: kFontUrbanist,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _eventNameController,
          style: const TextStyle(fontFamily: kFontPoppins),
          cursorColor: kForestGreen,
          decoration: _customFieldDecoration(label: "Event Name"),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _eventType,
          items:
              ["Cleanup", "Workshop", "Donation"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(fontFamily: kFontPoppins),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) => setState(() => _eventType = val),
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
                    colorScheme: ColorScheme.light(
                      primary: kForestGreen,
                      onPrimary: Colors.white,
                      onSurface: const Color(0xFF779235),
                      onBackground: const Color(0xFFF6F6F6),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: kForestGreen,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) setState(() => _eventDateRange = picked);
          },
          child: AbsorbPointer(
            child: TextField(
              style: const TextStyle(fontFamily: kFontPoppins),
              cursorColor: kForestGreen,
              readOnly: true,
              decoration: _customFieldDecoration(
                label: "Select date and time",
              ).copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: kForestGreen,
                ),
                hintText:
                    _eventDateRange == null
                        ? "Pick a date range"
                        : "${_eventDateRange!.start.month}/${_eventDateRange!.start.day}/${_eventDateRange!.start.year} - "
                            "${_eventDateRange!.end.month}/${_eventDateRange!.end.day}/${_eventDateRange!.end.year}",
                hintStyle: const TextStyle(
                  fontFamily: kFontPoppins,
                  color: Colors.black54,
                ),
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
          style: const TextStyle(fontFamily: kFontPoppins),
          cursorColor: kForestGreen,
          decoration: _customFieldDecoration(
            label: "Event description",
            borderColor: kForestGreen,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
