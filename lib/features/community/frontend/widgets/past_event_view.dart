import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';

class PastEventView extends StatefulWidget {
  const PastEventView({super.key});

  @override
  State<PastEventView> createState() => _PastEventViewState();
}

class _PastEventViewState extends State<PastEventView> {
  final PostService _postService = PostService();

  List<Widget> _eventBuilder(List<EventModel> events) {
    List<Widget> eventCards = [];
    for (EventModel event in events) {
      final postCard = EventCard(event: event);
      eventCards.add(postCard);
    }
    return eventCards;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<EventModel>>(
          stream: _postService.getPastEventStream(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kAvocado));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Event data is not available.'));
            }

            final upcomingEvents = _eventBuilder(snapshot.data!);
            return SingleChildScrollView(
              child: Column(
                children: upcomingEvents,
              ),
            );
          }
      ),
    );
  }
}