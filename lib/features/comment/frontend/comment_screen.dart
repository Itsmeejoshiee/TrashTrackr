import 'package:flutter/material.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_appbar.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_input.dart';
import 'package:trashtrackr/features/comment/frontend/widgets/comment_tile.dart';
import '../../../core/utils/constants.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

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
          CommentAppbar(),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CommentTile(
                  name: "Bree Pitt",
                  timestamp: DateTime(2025, 5, 16),
                  comment: "Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time 😅",
                )
              ),
            )
          ),

          CommentInput(
            controller: _commentController,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

