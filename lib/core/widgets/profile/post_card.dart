import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
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

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  final AuthService _authService = AuthService();
  final PostService _postService = PostService();

  bool _isLiked = false;
  bool _isCommented = false;
  bool _isBookmarked = false;

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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.9,
          child: CommentScreen(
            postId: widget.post.id ?? '',
            isForEvent: false,
          ),
        );
      },
    );
  }

  Stream<int> _commentCountStream() {
    return FirebaseFirestore.instance
        .collectionGroup('comments')
        .where('postId', isEqualTo: widget.post.id)
        .where('isForEvent', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
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
              CircleAvatar(
                backgroundImage: (widget.post.profilePicture.isNotEmpty)
                    ? NetworkImage(widget.post.profilePicture)
                    : const AssetImage('assets/images/placeholder_profile.jpg')
                as ImageProvider,
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
              SizedBox(width: 10),
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

              // Like Button
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
                          if (isLiked) {
                            await _postService.unlikePost(widget.post.id!);
                          } else {
                            await _postService.likePost(widget.post.id!);
                          }
                        },
                      );
                    },
                  );
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

              // Bookmark Button
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
