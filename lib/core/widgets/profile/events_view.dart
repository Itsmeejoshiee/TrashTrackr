import 'package:flutter/material.dart';
import 'event_card.dart';

class CleanupView extends StatelessWidget {
  const CleanupView({
    super.key,
    required this.posts,
  });

  final List<EventCard> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts,
    );
  }
}