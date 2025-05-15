import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/emotion.dart';

class EmotionDropdown extends StatelessWidget {
  const EmotionDropdown({super.key, this.value, this.items, this.onChanged});

  final Emotion? value;
  final List<DropdownMenuItem<Emotion>>? items;
  final ValueChanged<Emotion?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Emotion>(
      value: value,
      hint: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose type', style: kSmallGreenBoldText),
          Icon(Icons.arrow_drop_down, color: kForestGreenLight, size: 18),
        ],
      ),
      icon: const SizedBox.shrink(),
      style: kSmallGreenBoldText,
      isDense: true,
      items: items,
      onChanged: onChanged,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
      ),
      dropdownColor: Colors.white,
    );
  }
}