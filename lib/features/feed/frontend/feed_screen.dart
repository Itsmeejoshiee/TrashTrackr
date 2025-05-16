import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/emotion.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'package:trashtrackr/features/feed/frontend/feed_results.dart';
import 'package:trashtrackr/features/home/frontend/widgets/section_label.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_card.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_carousel.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
<<<<<<< Updated upstream
  String userSearch = '';
=======
  bool _isSearching = false;
>>>>>>> Stashed changes
  final TextEditingController _searchController = TextEditingController();
  final PostService _postService = PostService();

  List<Widget> _postBuilder(List<PostModel> posts) {
    List<Widget> postCards = [];
    for (PostModel post in posts) {
      final postCard = PostCard(post: post);
      postCards.add(postCard);
    }
    return postCards;
  }

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
    final double titleOffset = screenHeight / 20;
    final double imageSize = (screenWidth / 3) + 60;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: titleOffset),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/titles/ecofeed_title.png',
                    width: imageSize,
                  ),

                  DashboardSearchBar(
                    controller: _searchController,
                    onFilterTap: () {},
<<<<<<< Updated upstream
                    onChanged: (value) {
                      setState(() {
                        userSearch = value.trim();
                      });
                    },
                    onSearch: () {
                      if (userSearch.isNotEmpty) {
=======
                    onSubmit: (value) {
                      final keyword = value.trim();
                      if (keyword.isNotEmpty) {
                        setState(() => _isSearching = true);
>>>>>>> Stashed changes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
<<<<<<< Updated upstream
                                    FeedResults(searchKeyword: userSearch),
                          ),
                        );
                      }
                    },
                    onSubmit: (value) {
                      if (userSearch.isNotEmpty) {
=======
                                    FeedResults(searchKeyword: keyword),
                          ),
                        ).then((_) {
                          setState(() => _isSearching = false);
                        });
                      }
                    },
                    onSearch: () {
                      final keyword = _searchController.text.trim();
                      if (keyword.isNotEmpty) {
                        setState(() => _isSearching = true);
>>>>>>> Stashed changes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
<<<<<<< Updated upstream
                                    FeedResults(searchKeyword: userSearch),
                          ),
                        );
=======
                                    FeedResults(searchKeyword: keyword),
                          ),
                        ).then((_) {
                          setState(() => _isSearching = false);
                        });
>>>>>>> Stashed changes
                      }
                    },
                  ),

                  SectionLabel(label: 'Recycling Guide'),

                  SizedBox(height: 17),
                ],
              ),
            ),

            // Carousel
            RecyclingGuideCarousel(
              children: [
                RecyclingGuideCard(index: 1),
                RecyclingGuideCard(index: 2),
                RecyclingGuideCard(index: 3),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: 30),

                  Text(
                    "Check out what's new",
                    style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 13),

                  StreamBuilder<List<PostModel>>(
                    stream: _postService.getPostStream(),
                    builder: (context, snapshot) {
                      print('POST STREAM: ${snapshot.data}');

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: kAvocado),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text('Post data is not available.'),
                        );
                      }

                      final postCards = _postBuilder(snapshot.data!);
                      return StreamBuilder<List<EventModel>>(
                        stream: _postService.getEventStream(),
                        builder: (context, snapshot) {

                          print('EVENT STREAM: ${snapshot.data}');

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(color: kAvocado),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: Text('Event data is not available.'),
                            );
                          }

                          final eventCards = _eventBuilder(snapshot.data!);
                          final feed = [...postCards, ...eventCards];
                          feed.shuffle();
                          return Column(children: feed);
                        }
                      );
                    },
                  ),

                  // Offset
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
