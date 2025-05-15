import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class EventDateRangePicker extends StatelessWidget {
  const EventDateRangePicker({super.key, this.dateRange, this.onDatePick, this.decoration});

  final DateTimeRange? dateRange;
  final VoidCallback? onDatePick;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDatePick,
      child: AbsorbPointer(
        child: TextField(
          style: kPoppinsLabel,
          cursorColor: kForestGreenLight,
          // <-- Add this line
          readOnly: true,
          decoration: decoration!.copyWith(
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: kForestGreenLight,
            ),
            hintText:
            dateRange == null
                ? "Pick a date range"
                : "${dateRange!.start.month}/${dateRange!.start.day}/${dateRange!.start.year} - "
                "${dateRange!.end.month}/${dateRange!.end.day}/${dateRange!.end.year}",
            hintStyle: kPoppinsLabel,
          ),
          controller: TextEditingController(
            text:
            dateRange == null
                ? ""
                : "${dateRange!.start.month}/${dateRange!.start.day}/${dateRange!.start.year} - "
                "${dateRange!.end.month}/${dateRange!.end.day}/${dateRange!.end.year}",
          ),
        ),
      ),
    );
  }
}