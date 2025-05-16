import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';

class CommentAppbar extends StatelessWidget {
  const CommentAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),

        // Black line at the top, centered
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: 150,
            height: 4,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Top bar with title and close icon
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: kAppleGreen,
                  size: 35,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Comments',
                    style: kPoppinsBodyLarge.copyWith(fontWeight: FontWeight.w700, color: kAvocado),
                  ),
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
        ),


        // Divider below the comments
        Divider(
          color: Colors.black12,
          thickness: 0.5,
        ),


      ],
    );
  }
}
