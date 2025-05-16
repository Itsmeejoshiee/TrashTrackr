import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/services/image_service.dart';
import 'package:trashtrackr/core/utils/event_type.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:flutter/services.dart';
import 'package:trashtrackr/features/post/widgets/event_date_range_picker.dart';
import 'package:trashtrackr/features/post/widgets/event_image_picker.dart';
import 'package:trashtrackr/features/post/widgets/event_time_range_picker.dart';
import 'package:trashtrackr/features/post/widgets/event_type_dropdown.dart';

// const String kFontUrbanist = 'Urbanist';

class EventForm extends StatefulWidget {
  final EventModel? eventEntry;
  final Function(String)? onTitleChanged;
  final Function(String)? onDescChanged;
  final Function(EventType?)? onTypeSelect;
  final Function(String?)? onAddressChanged;
  final Function(DateTimeRange?)? onDateTimeRangeSelect;
  final Function(TimeOfDay?, TimeOfDay?)? onTimeSelect;
  final Function(Uint8List?)? onImageSelect;

  const EventForm({
    super.key,
    this.eventEntry,
    this.onTitleChanged,
    this.onDescChanged,
    this.onTypeSelect,
    this.onAddressChanged,
    this.onDateTimeRangeSelect,
    this.onTimeSelect,
    this.onImageSelect,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late TextEditingController _eventTitleController;
  late TextEditingController _eventDescController;
  EventType? _eventType;
  late TextEditingController _eventAddressController;
  DateTimeRange? _eventDateRange;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
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
    _eventAddressController = TextEditingController(
      text: widget.eventEntry?.address ?? '',
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

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: kAppleGreen.withOpacity(0.3),
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
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kAvocado,
              secondary: kAppleGreen, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kAppleGreen, // Button text color
              ),
            ),
          ),
          child:
              child ??
              const SizedBox.shrink(), // Use child or fallback to an empty widget
        );
      },
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
      widget.onTimeSelect!(_startTime, _endTime);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kAvocado,
              secondary: kAppleGreen, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kAppleGreen, // Button text color
              ),
            ),
          ),
          child:
              child ??
              const SizedBox.shrink(), // Use child or fallback to an empty widget
        );
      },
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
      widget.onTimeSelect!(_startTime, _endTime);
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
        // Offset
        const SizedBox(height: 12),

        // Event Image Picker
        EventImagePicker(
          image: _pickedImage,
          onPickImage: _pickImage,
          onRemoveImage: () {
            setState(() {
              _pickedImage = null;
            });
            widget.onImageSelect!(_pickedImage);
          },
        ),

        // Offset
        const SizedBox(height: 12),

        // Form Title
        Center(child: Text("Event Details", style: kTitleMedium)),

        // Offset
        const SizedBox(height: 12),

        // Event Title Field
        TextField(
          controller: _eventTitleController,
          style: kPoppinsLabel,
          cursorColor: kForestGreenLight,
          // <-- Add this line
          decoration: _customFieldDecoration(label: "Event Title"),
          onChanged: (value) {
            widget.onTitleChanged!(_eventTitleController.text);
          },
        ),

        // Offset
        const SizedBox(height: 12),

        // Event Type Dropdown
        EventTypeDropdown(
          value: _eventType,
          onChanged: (val) {
            setState(() => _eventType = val);
            widget.onTypeSelect!(_eventType);
          },
          decoration: _customFieldDecoration(label: "Event Type"),
        ),

        // Offset
        const SizedBox(height: 12),

        // Event Title Field
        TextField(
          controller: _eventAddressController,
          style: kPoppinsLabel,
          cursorColor: kForestGreenLight,
          // <-- Add this line
          decoration: _customFieldDecoration(label: "Event Address"),
          onChanged: (value) {
            widget.onAddressChanged!(_eventAddressController.text);
          },
        ),

        // Offset
        const SizedBox(height: 12),

        // Date Picker
        EventDateRangePicker(
          dateRange: _eventDateRange,
          onDatePick: _selectDateRange,
          decoration: _customFieldDecoration(label: "Select date and time"),
        ),

        // Offset
        const SizedBox(height: 12),

        // Time Picker
        EventTimeRangePicker(
          startTime: _startTime,
          onStartSelect: () => _selectStartTime(context),
          endTime: _endTime,
          onEndSelect: () => _selectEndTime(context),
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
