import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class AuthProviderButton extends StatelessWidget {
  const AuthProviderButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding,
  });

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 76,
        height: 76,
        padding: padding ?? EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Color(0xE5DDDDDD),
              blurRadius: 13,
              offset: Offset(5, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0xE5FFFFFF),
              blurRadius: 10,
              offset: Offset(5, -5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x33DDDDDD),
              blurRadius: 10,
              offset: Offset(5, -5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x33DDDDDD),
              blurRadius: 10,
              offset: Offset(-5, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}