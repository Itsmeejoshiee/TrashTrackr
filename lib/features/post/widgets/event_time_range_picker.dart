import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class EventTimeRangePicker extends StatelessWidget {
  const EventTimeRangePicker({
    super.key,
    this.startTime,
    this.onStartSelect,
    this.endTime,
    this.onEndSelect,
  });

  final TimeOfDay? startTime;
  final VoidCallback? onStartSelect;
  final TimeOfDay? endTime;
  final VoidCallback? onEndSelect;

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
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onStartSelect,
            child: AbsorbPointer(
              child: TextFormField(
                decoration: _customFieldDecoration(
                  label:
                      (startTime != null)
                          ? startTime!.format(context)
                          : 'Select start time',
                ).copyWith(
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: kForestGreenLight,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: onEndSelect,
            child: AbsorbPointer(
              child: TextFormField(
                decoration: _customFieldDecoration(
                  label:
                      endTime != null
                          ? endTime!.format(context)
                          : 'Select End Time',
                ).copyWith(
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: kForestGreenLight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
