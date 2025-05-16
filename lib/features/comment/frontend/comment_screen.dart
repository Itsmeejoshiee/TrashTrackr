import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_appbar.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_input.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_tile.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/comment_service.dart';
import '../../comment/model/comment_model.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final bool isForEvent;

  const CommentScreen({
    super.key,
    required this.postId,
    required this.isForEvent,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();

  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      setState(() {
        final displayName = firebaseUser.displayName ?? 'Anonymous User';
        final names = displayName.split(' ');
        final firstName = names.isNotEmpty ? names.first : 'Anonymous';
        final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

        _currentUser = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          firstName: firstName,
          lastName: lastName,
          profilePicture: firebaseUser.photoURL ?? '',
          followerCount: 0,
          followingCount: 0,
        );
      });
    }
  }

  Future<void> _handleAddComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _currentUser == null) return;

    try {
      final newComment = CommentModel(
        id: '',
        postId: widget.postId,
        uid: _currentUser!.uid,
        fullName: '$_currentUser!.firstName $_currentUser.lastName',
        profilePicture: _currentUser!.profilePicture,
        content: text,
        timestamp: Timestamp.now(),
        isForEvent: widget.isForEvent,
      );

      await _commentService.addComment(newComment);
      _commentController.clear();
    } catch (e) {
      print('Error adding comment: $e');

    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommentAppbar(),

          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: _commentService.fetchCommentsForPost(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments.'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No comments yet."));
                }

                final comments = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentTile(
                      name: comment.fullName,
                      timestamp: comment.timestamp.toDate(),
                      comment: comment.content,
                      profilePicture: comment.profilePicture,
                      // optionally pass profilePicture, comment.id for extra UI
                    );
                  },
                );
              },
            ),
          ),

          CommentInput(
            controller: _commentController,
            onPressed: _handleAddComment,
          ),
        ],
      ),
    );
  }
}
