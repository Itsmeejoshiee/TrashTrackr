import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/notif_service.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/widgets/buttons/bookmark_button.dart';
import 'package:trashtrackr/core/widgets/buttons/comment_button.dart';
import 'package:trashtrackr/core/widgets/buttons/like_button.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/features/comment/frontend/comment_screen.dart';
import 'package:trashtrackr/features/profile/frontend/public_profile_screen.dart';

import '../../services/comment_service.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final CommentService _commentService = CommentService();
  final PostService _postService = PostService();
  final ActivityService _activityService = ActivityService();
  final BadgeService _badgeService = BadgeService();

  Widget _buildEmotionLabel() {
    final emotionName = widget.post.emotion.name;
    return Row(
      children: [
        Image.asset('assets/images/emotions/$emotionName.png', width: 24),
        const SizedBox(width: 3),
        Text(
          emotionName.capitalize(),
          style: kBodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateUtils = DateUtilsHelper();
    final dateTime = timestamp.toDate();

    final month = dateUtils.getMonthName(dateTime.month);
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final meridian = dateTime.hour >= 12 ? 'pm' : 'am';

    return '$month $day, $year @ $hour:$minutes $meridian';
  }

  void _openCommentScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CommentScreen(postId: widget.post.id ?? '', isForEvent: false),
        );
      },
    );
  }


  Stream<int> _commentCountStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.id)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }


  Stream<bool> _hasCurrentUserCommented() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(false);

    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.id)
        .collection('comments')
        .where('uid', isEqualTo: user.uid)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PublicProfileScreen(uid: widget.post.uid),
                      ),
                    ),
                child: CircleAvatar(
                  backgroundImage:
                      (widget.post.profilePicture.isNotEmpty)
                          ? NetworkImage(widget.post.profilePicture)
                          : const AssetImage(
                                'assets/images/placeholder_profile.jpg',
                              )
                              as ImageProvider,
                ),
              ),
              const SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    widget.post.fullName,
                    style: kBodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              const Spacer(),
              _buildEmotionLabel(),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.post.body,
            style: kPoppinsBodyMedium.copyWith(fontSize: 12),
          ),
          if (widget.post.imageUrl.isNotEmpty)
            Container(
              width: double.infinity,
              height: 212,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.post.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 15),
          Row(
            children: [
              // Like Button with notification
              StreamBuilder<bool>(
                stream: _postService.postLikedByCurrentUserStream(
                  widget.post.id!,
                ),
                builder: (context, snapshot) {
                  final isLiked = snapshot.data ?? false;
                  return StreamBuilder<int>(
                    stream: _postService.getPostLikeCount(widget.post.id!),
                    builder: (context, snapshot) {
                      return LikeButton(
                        isActive: isLiked,
                        count: snapshot.data ?? 0,
                        onPressed: () async {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) return;

                          if (isLiked) {
                            await _postService.unlikePost(widget.post.id!);
                            // Optionally, you can add code to remove like notification if needed
                          } else {
                            await _postService.likePost(widget.post.id!);
                            await _activityService.logActivity('like');
                            _badgeService.checkTrashTrackrOg();
                            _badgeService.checkGreenStreaker();
                            _badgeService.checkDailyDiligent();
                            _badgeService.checkWeekendWarrior();
                          }
                        },
                      );
                    },
                  );
                },
              ),

              // Comment Button with notification handled inside _openCommentScreen
              StreamBuilder<int>(
                stream: _commentService.getCommentCount(
                  widget.post.id!,
                  isForEvent: false,
                ),
                builder: (context, countSnapshot) {
                  final count = countSnapshot.data ?? 0;
                  return StreamBuilder<bool>(
                    stream: _hasCurrentUserCommented(),
                    builder: (context, userCommentSnapshot) {
                      final hasCommented = userCommentSnapshot.data ?? false;
                      return CommentButton(
                        isActive: hasCommented,
                        count: count,
                        onPressed: () {
                          _openCommentScreen(context);
                        },
                      );
                    },
                  );
                },
              ),

              // Bookmark Button unchanged
              StreamBuilder<bool>(
                stream: _postService.postBookmarkedStream(widget.post.id!),
                builder: (context, snapshot) {
                  final isBookmarked = snapshot.data ?? false;
                  return BookmarkButton(
                    isActive: isBookmarked,
                    onPressed: () async {
                      if (isBookmarked) {
                        await _postService.unbookmarkPost(widget.post.id!);
                      } else {
                        await _postService.bookmarkPost(widget.post.id!);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
