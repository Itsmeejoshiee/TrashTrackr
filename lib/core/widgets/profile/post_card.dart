import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/buttons/bookmark_button.dart';
import 'package:trashtrackr/core/widgets/buttons/comment_button.dart';
import 'package:trashtrackr/core/widgets/buttons/like_button.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';
import 'package:trashtrackr/features/comment/frontend/comment_screen.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _isCommented = false;
  bool _isBookmarked = false;

  Widget _buildEmotionLabel() {
    final emotionName = widget.post.emotion.name;
    return Row(
      spacing: 3,
      children: [
        Image.asset('assets/images/emotions/$emotionName.png', width: 24),
        Text(
          emotionName.capitalize(),
          style: kBodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateUtilsHelper _dateUtilsHelpers = DateUtilsHelper();
    DateTime dateTime = timestamp.toDate();

    // Format date
    String month = _dateUtilsHelpers.getMonthName(dateTime.month);
    int day = dateTime.day;
    int year = dateTime.year;
    String date = '$month $day, $year';

    // Format time
    int hour = dateTime.hour % 12;
    int minutes = dateTime.minute;
    String meridian = (dateTime.hour > 12) ? 'pm' : 'am';
    String time = '$hour:$minutes $meridian';

    return '$date @ $time';
  }

  // for comment bottom sheet
  void _openCommentScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CommentScreen(
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage:
                    (widget.post.profilePicture.isNotEmpty)
                        ? NetworkImage(widget.post.profilePicture)
                        : AssetImage('assets/images/placeholder_profile.jpg'),
              ),
              SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  //User Name
                  Text(
                    widget.post.fullName,
                    style: kBodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //Date Posted
                  Text(
                    _formatTimestamp(widget.post.timestamp),
                    style: kPoppinsBodyMedium.copyWith(
                      fontSize: 9.95,
                      fontWeight: FontWeight.w500,
                      color: kGray.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              Spacer(),
              _buildEmotionLabel(),
            ],
          ),
          SizedBox(height: 10),

          Text(
            widget.post.body,
            style: kPoppinsBodyMedium.copyWith(fontSize: 12),
          ),

          (widget.post.imageUrl.isNotEmpty)
              ? Container(
                width: double.infinity,
                height: 212,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.post.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : SizedBox(),

          // Offset
          SizedBox(height: 15),

          Row(
            children: [
              LikeButton(
                isActive: _isLiked,
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
              ),

              CommentButton(
                isActive: _isCommented,
                onPressed: () {
                  setState(() {
                    _isCommented = !_isCommented;
                    _openCommentScreen(context);
                  });
                },
              ),

              BookmarkButton(
                isActive: _isBookmarked,
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
