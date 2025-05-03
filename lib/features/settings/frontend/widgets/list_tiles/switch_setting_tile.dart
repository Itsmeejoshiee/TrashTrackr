import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class SwitchSettingTile extends StatelessWidget {
  const SwitchSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconData,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final IconData iconData;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Column(
        mainAxisAlignment: (subtitle != null) ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Icon(iconData, color: kAvocado),
        ],
      ),
      title: Text(title, style: kBodyLarge),
      subtitle: (subtitle != null) ? Text(
        subtitle!,
        style: kBodySmall.copyWith(fontStyle: FontStyle.italic),
      ) : null,
      activeTrackColor: kAvocado,
      inactiveTrackColor: kRed,
      inactiveThumbColor: kLightGray,
      trackOutlineColor: WidgetStatePropertyAll<Color>(
        kLightGray,
      ),
    );
  }
}