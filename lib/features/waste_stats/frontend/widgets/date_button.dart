import 'package:flutter/material.dart';

// TODO: Check the date logic next day
class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    required this.onPressed,
    required this.isActive,
    required this.isAscending,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final bool isAscending;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Color(0xff558B2F) : Color(0xff898989);
    final borderColor = isActive ? Color(0xff558B2F) : Color(0xFFadadad);
    final arrowIcon = isAscending ? Icons.arrow_upward : Icons.arrow_downward;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: borderColor),
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Date",
            style: TextStyle(color: color),
          ),
          if (isActive) ...[
            SizedBox(width: 8),
            Icon(arrowIcon, size: 15, color: color),
          ],
        ],
      ),
    );
  }
}
