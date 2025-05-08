import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'cleanup_card.dart';

class CleanupView extends StatelessWidget {
  const CleanupView({
    super.key,
    required this.posts,
  });

  final List<CleanupCard> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts,
    );
  }
}