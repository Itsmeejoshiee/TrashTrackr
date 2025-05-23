import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.iconData = Icons.person,
    this.obscureText = false,
    this.margin,
    this.enabled,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData iconData;
  final bool obscureText;
  final EdgeInsets? margin;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? EdgeInsets.symmetric(vertical: 15),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, const Color(0xFFEAEAEA)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadows: [
          BoxShadow(
            color: Color(0xE5DDDDDD),
            blurRadius: 13,
            offset: Offset(5, 5),
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
      child: TextField(
        enabled: enabled,
        controller: controller,
        style: kTitleMedium.copyWith(
          color: kDarkTeal.withOpacity(0.4),
          fontWeight: FontWeight.bold,
        ),
        cursorColor: kDarkTeal.withOpacity(0.4),
        cursorHeight: 20,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            iconData,
            color: kDarkTeal.withOpacity(0.4),
            size: 23,
          ),
          contentPadding: EdgeInsets.only(top: 11),
          hintText: hintText,
          hintStyle: kTitleMedium.copyWith(
            color: kDarkTeal.withOpacity(0.2),
            fontWeight: FontWeight.bold,
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
