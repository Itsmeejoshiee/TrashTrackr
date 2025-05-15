import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/core/utils/event_type.dart';

class EventTypeDropdown extends StatelessWidget {
  const EventTypeDropdown({
    super.key,
    this.value,
    this.onChanged,
    this.decoration,
  });

  final EventType? value;
  final Function(EventType?)? onChanged;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EventType>(
      value: value,
      items:
      EventType.values
          .map(
            (event) => DropdownMenuItem(
          value: event,
          child: Text(event.name.capitalize(), style: kPoppinsLabel),
        ),
      )
          .toList(),
      onChanged: onChanged,
      decoration: decoration,
    );
  }
}