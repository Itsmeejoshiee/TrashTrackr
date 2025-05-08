import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class ScanResultField extends StatelessWidget {
  const ScanResultField({
    super.key,
    required this.controller,
    this.width,
  });

  final TextEditingController controller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: kPoppinsBodyMedium,
        cursorColor: Colors.grey.shade700,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 2,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}