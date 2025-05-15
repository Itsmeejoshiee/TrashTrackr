import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String?)? onChange;

  const PostInputField({
    required this.controller,
    required this.focusNode,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (_) {},
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 10,
        cursorColor: kForestGreenLight,
        style: kPostInputTextStyle,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: onChange,
      ),
    );
  }
}