import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'package:trashtrackr/features/feed/frontend/feed_results.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/filter_menu.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_card.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_carousel.dart';
import 'package:trashtrackr/features/home/frontend/widgets/section_label.dart';
import 'package:trashtrackr/core/models/event_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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

  String _selectedFilter = 'General Content';
  bool _isNewest = true;
  bool _showFilterMenu = false;

  void _toggleFilterMenu() {
    setState(() {
      _showFilterMenu = !_showFilterMenu;
    });
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
                    onFilterTap: _toggleFilterMenu,
                    onSubmit: (value) {
                      final keyword = value.trim();
                      if (keyword.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FeedResults(
                                  searchKeyword: keyword,
                                  initialFilter: _selectedFilter,
                                  isNewest: _isNewest,
                                ),
                          ),
                        );
                      }
                    },
                    onSearch: () {
                      final keyword = _searchController.text.trim();
                      if (keyword.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FeedResults(
                                  searchKeyword: keyword,
                                  initialFilter: _selectedFilter,
                                  isNewest: _isNewest,
                                ),
                          ),
                        );
                      }
                    },
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child:
                        _showFilterMenu
                            ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: FilterMenu(
                                onFilterChanged: (filter, isNewest) {
                                  setState(() {
                                    _selectedFilter = filter;
                                    _isNewest = isNewest;
                                  });
                                },
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: SectionLabel(label: 'Recycling Guide'),
            ),

            const SizedBox(height: 17),

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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                        },
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
