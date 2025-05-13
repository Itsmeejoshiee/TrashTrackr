import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'package:trashtrackr/features/home/frontend/widgets/section_label.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_card.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/recycling_guide_carousel.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();

  NavRoute _selectedRoute = NavRoute.feed;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  List<Widget> _postBuilder() {
    List<Widget> posts = [
      PostCard(
        profilePath: 'assets/images/placeholder_profile.jpg',
        username: 'Makyismynickname',
        timestamp: 'Today @ 10:42 am',
        desc:
            'Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time 😅\nToday’s highlight: discovering my shampoo bottle is recyclable. Score! ♻️🧴',
      ),
      PostCard(
        profilePath: 'assets/images/placeholder_profile.jpg',
        username: 'Makyismynickname',
        timestamp: 'Today @ 10:42 am',
        desc:
            'Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time 😅\nToday’s highlight: discovering my shampoo bottle is recyclable. Score! ♻️🧴',
        image: AssetImage('assets/images/intro/intro0.png'),
      ),
    ];
    return posts;
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

                  DashboardSearchBar(controller: _searchController),

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

                  ..._postBuilder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
