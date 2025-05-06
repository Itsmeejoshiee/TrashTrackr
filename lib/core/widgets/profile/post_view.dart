import 'package:flutter/material.dart';
import 'post_card.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key, required this.posts});

  final List<PostCard> posts;

  @override
  Widget build(BuildContext context) {
    return Column(children: posts);
  }
}