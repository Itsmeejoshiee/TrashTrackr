import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class NeoBox extends StatelessWidget {
  const NeoBox({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, const Color(0xFFF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Color(0xE5E0E0E0),
            blurRadius: 13,
            offset: Offset(5, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(-5, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class NeoBoxSmall extends StatelessWidget {
  const NeoBoxSmall({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 109,
      height: 199,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, const Color(0xFFF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Color(0xE5E0E0E0),
            blurRadius: 13,
            offset: Offset(5, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(-5, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
