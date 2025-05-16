import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({super.key, required this.controller, required this.onPressed});

  final TextEditingController controller;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // divider above comments
        Divider(color: Colors.black26, thickness: 0.5),

        // comment input field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [

              // comment textfield
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Reduce, reuse, and reply...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // post comment
              IconButton(
                icon:
                  Image.asset('assets/images/icons/comment_send.png',
                  width: 35,
                  height: 35,
                ),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
