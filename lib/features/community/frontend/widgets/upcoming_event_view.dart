import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/models/event_model.dart';

class UpcomingEventView extends StatefulWidget {
  const UpcomingEventView({super.key});

  @override
  State<UpcomingEventView> createState() => _UpcomingEventViewState();
}

class _UpcomingEventViewState extends State<UpcomingEventView> {
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = (screenWidth / 3) + 60;
    final double bottomOffset = screenHeight / 8;
    return Expanded(
      child: StreamBuilder<List<EventModel>>(
        stream: _postService.getUpcomingEventStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: kAvocado));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Event data is not available.'));
          }

          final upcomingEvents = _eventBuilder(snapshot.data!);

          if (upcomingEvents.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/components/no_feeds.png',
                  width: imageSize,
                ),
                Text(
                  "No events yet!",
                  style: kDisplaySmall.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  'There aren’t any clean-ups right now.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Be the first to start something great\nfor the planet! 🌍✨',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: bottomOffset),
              ],
            );
          }

          return SingleChildScrollView(child: Column(children: upcomingEvents));
        },
      ),
    );
  }
}
