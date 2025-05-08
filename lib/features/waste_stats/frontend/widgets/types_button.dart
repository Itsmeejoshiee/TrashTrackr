import 'package:flutter/material.dart';

class TypesButton extends StatelessWidget {
  const TypesButton({super.key, required this.onPressed,});

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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Type",
            style: TextStyle(color: Color(0xff898989)),
          ),

          SizedBox(width: 8),

          Icon(
            Icons.keyboard_arrow_down_sharp, // You can change this to any other icon
            color: Color(0xff898989),
            size: 20, // Icon size
          ),
        ],
      ),
    );
  }
}
