import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.name,
    required this.timestamp,
    required this.comment,
    required this.profilePicture
  });

  final String name;
  final String profilePicture;
  final DateTime timestamp;
  final String comment;

  /// Formats the timestamp into a "time ago" string.
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
      margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: kAvocado.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture
          CircleAvatar(
            backgroundImage: profilePicture.isNotEmpty
                ? NetworkImage(profilePicture)
                : AssetImage('assets/images/placeholder_profile.jpg') as ImageProvider,
            radius: 20,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name and timestamp
                Row(
                  children: [
                    Text(
                      name,
                      style: kTitleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _formatTimestamp(timestamp),
                      style: kPoppinsLabel.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
