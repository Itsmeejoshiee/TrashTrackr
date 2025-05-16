import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/profile/profile_header.dart';
import 'package:trashtrackr/core/widgets/profile/profile_switch_tile.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/widgets/profile/streak_calendar.dart';
import 'package:trashtrackr/core/widgets/profile/badge_grid.dart';
import 'package:trashtrackr/core/widgets/profile/wastelog_board.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/features/settings/frontend/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  ProfileSection _selectedSection = ProfileSection.posts;

  @override
  void initState() {
    super.initState();
  }

  Widget _getSectionWidget() {
    switch (_selectedSection) {
      case ProfileSection.posts:
        return StreamBuilder(
          stream: _postService.getUserPostStream(),
          builder: (context, snapshot) {
            print('POST STREAM: ${snapshot.data}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kAvocado));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Post data is not available.'));
            }

            if (snapshot.data!.isEmpty) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Image.asset(
                        'assets/images/components/no_feeds.png',
                        width: 150,
                      ),
                      Text(
                        "Nothing here yet!",
                        style: kHeadlineMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'You haven’t shared or interacted with\nany EcoFeeds yet.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Join the conversation—post, comment,\nor cheer others on! 🌱💬',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(children: _postBuilder(snapshot.data!));
          },
        );
      case ProfileSection.wasteLog:
        return WastelogBoard();
      case ProfileSection.events:
        return StreamBuilder(
          stream: _postService.getUserEventStream(),
          builder: (context, snapshot) {
            print('POST STREAM: ${snapshot.data}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kAvocado));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Post data is not available.'));
            }

            if (snapshot.data!.isEmpty) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Image.asset(
                        'assets/images/components/no_feeds.png',
                        width: 150,
                      ),
                      Text(
                        "No events yet!",
                        style: kHeadlineMedium.copyWith(fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              );
            }

            return Column(children: _eventBuilder(snapshot.data!));
          },
        );
    }
  }

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
    final double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: _userService.getUserStream(),
      builder: (context, snapshot) {
        print('SNAPSHOT DATA');
        print(snapshot.data);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('User data is not available.'));
        }

        final user = snapshot.data;
        return Stack(
          children: [
            Container(color: kLightGray),
            Container(
              width: double.infinity,
              height: screenHeight / 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, 0.00),
                  end: Alignment(0.50, 1.50),
                  colors: [
                    kAvocado.withOpacity(0.4),
                    kAvocado.withOpacity(0.2),
                    Colors.white.withOpacity(0),
                    Colors.white,
                  ],
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(),
                                  ),
                                ),
                            icon: Icon(Icons.settings),
                          ),
                        ),

                        // Profile Header
                        ProfileHeader(
                          username: '${user!.firstName} ${user.lastName}',
                          image:
                              (user.profilePicture.isNotEmpty)
                                  ? NetworkImage(user.profilePicture)
                                  : AssetImage(
                                    'assets/images/placeholder_profile.jpg',
                                  ),
                          followers: user.followerCount,
                          following: user.followingCount,
                        ),

                        SizedBox(height: 38),

                        // Eco Streak Section
                        StreakCalendar(),

                        // Badges
                        BadgeGrid(),

                        SizedBox(height: 30),

                        ProfileSwitchTile(
                          selected: _selectedSection,
                          onPosts: () {
                            setState(() {
                              _selectedSection = ProfileSection.posts;
                            });
                          },
                          onWasteLog: () {
                            setState(() {
                              _selectedSection = ProfileSection.wasteLog;
                            });
                          },
                          onCleanup: () {
                            setState(() {
                              _selectedSection = ProfileSection.events;
                            });
                          },
                        ),

                        SizedBox(height: 18),

                        // View Body & Animated Switcher
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (child, animation) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                          child: _getSectionWidget(),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
