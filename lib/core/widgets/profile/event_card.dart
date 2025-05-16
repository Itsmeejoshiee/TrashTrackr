import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/buttons/bookmark_button.dart';
import 'package:trashtrackr/core/widgets/buttons/comment_button.dart';
import 'package:trashtrackr/core/widgets/buttons/like_button.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';

import '../../../features/comment/frontend/comment_screen.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isLiked = false;
  bool _isCommented = false;
  bool _isBookmarked = false;

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

  String _formatDate(DateTimeRange dateRange) {
    final DateUtilsHelper _dateUtilsHelpers = DateUtilsHelper();

    final startDate = dateRange.start;
    final dayName = DateFormat('EEEE').format(startDate);
    final month = _dateUtilsHelpers.getMonthName(startDate.month);
    final day = startDate.day;
    final year = startDate.year;
    return '$dayName, $month $day, $year';
  }

  void _openCommentScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CommentScreen(
            postId: widget.event.id ?? '',
            isForEvent: false,
          ),
        );
      },
    );
  }

  Stream<int> _commentCountStream() {
    return FirebaseFirestore.instance
        .collectionGroup('comments')
        .where('postId', isEqualTo: widget.event.id)
        .where('isForEvent', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
  
  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(foregroundImage:
              (widget.event.profilePicture.isNotEmpty)
                  ? NetworkImage(widget.event.profilePicture)
                  : AssetImage('assets/images/placeholder_profile.jpg'),),
              SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  //User Name
                  Text(
                    widget.event.fullName,
                    style: kBodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //Date Posted
                  Text(
                    _formatTimestamp(widget.event.timestamp),
                    style: kPoppinsBodyMedium.copyWith(
                      fontSize: 9.95,
                      fontWeight: FontWeight.w500,
                      color: kGray.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
          SizedBox(height: 10),

          // Optional Image
          (widget.event.imageUrl.isNotEmpty)
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
                    image: NetworkImage(widget.event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : SizedBox(),

          Text(widget.event.title, style: kTitleLarge.copyWith(fontWeight: FontWeight.bold)),

          Text(
            '${_formatDate(widget.event.dateRange)}   •   ${widget.event.startTime.toString()} - ${widget.event.startTime.toString()}',
            style: kPoppinsBodySmall.copyWith(color: kGray.withOpacity(0.5)),
          ),

          Text(widget.event.address, style: kPoppinsBodyMedium.copyWith(color: kAvocado)),

          // Offset
          SizedBox(height: 10),

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

              StreamBuilder<int>(
                stream: _commentCountStream(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return CommentButton(
                    isActive: _isCommented,
                    label: count > 0 ? count.toString() : 'Comment ',
                    onPressed: () {
                      setState(() => _isCommented = !_isCommented);
                      _openCommentScreen(context);
                    },
                  );
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
