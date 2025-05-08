import 'package:flutter/material.dart';

class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: Color(0xFFadadad)),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Date",
            style: TextStyle(color: Color(0xff898989)),
          ),
          
          SizedBox(width: 8),
          
          Image.asset("assets/images/icons/date_arrow.png", width: 15)
        ],
      ),
    );
  }
}
