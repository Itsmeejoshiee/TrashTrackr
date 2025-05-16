import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({
    super.key,
    required this.username,
    required this.profilePicture,
    required this.timestamp,
    required this.notifType,
  });

  final String username;
  final profilePicture;
  final DateTime timestamp;
  final String notifType;

  // Formats the timestamp into a "time ago" string.
  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy • h:mm a').format(time);
    }
  }

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
            backgroundImage: profilePicture.isNotEmpty
                ? NetworkImage(profilePicture)
                : AssetImage('assets/images/placeholder_profile.jpg') as ImageProvider,
            radius: 28,
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
                      TextSpan(
                        text: notifType == 'like'
                            ? ' reacted to your post.'
                            : notifType == 'comment'
                            ? ' commented on your post.'
                            : ' interacted with your post.',
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(fontSize: 10, color: Colors.black38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
