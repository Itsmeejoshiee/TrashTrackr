import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({super.key, this.username = 'Ella Green'});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: kLightKiwi,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/placeholder_profile.jpg',
            ),
            radius: 28,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                ),
              ),
            ),
          ),
          // Offset
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: Colors.black),
                    children: [
                      TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and 5 others reacted to your post.'),
                    ],
                  ),
                ),
                Text(
                  '3 hours ago',
                  style: TextStyle(fontSize: 8, color: Colors.black38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
