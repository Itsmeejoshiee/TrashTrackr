import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData, color: kAvocado),
      title: Text(title, style: kBodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: kAvocado,
      ),
    );
  }
}