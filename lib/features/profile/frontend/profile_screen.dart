import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/profile/profile_header.dart';
import 'package:trashtrackr/core/widgets/profile/profile_switch_tile.dart';
import 'package:trashtrackr/core/widgets/profile/post_view.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/profile/cleanup_view.dart';
import 'package:trashtrackr/core/widgets/profile/cleanup_card.dart';
import 'package:trashtrackr/core/widgets/profile/streak_calendar.dart';
import 'package:trashtrackr/core/widgets/profile/badge_grid.dart';
import 'package:trashtrackr/core/widgets/profile/wastelog_board.dart';
import 'package:trashtrackr/features/settings/frontend/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NavRoute _selectedRoute = NavRoute.profile;
  ProfileSection _selectedSection = ProfileSection.posts;
  String? fullName;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  void _loadFullName() async {
    final name = await UserService().getFullName();
    setState(() {
      fullName = name;
    });
  }

  void initState() {
    super.initState();
    _loadFullName();
  }

  Widget _getSectionWidget() {
    switch (_selectedSection) {
      case ProfileSection.posts:
        return PostsView(
          posts: [
            PostCard(
              profilePath: 'assets/images/placeholder_profile.jpg',
              username: 'Ella Green',
              timestamp: 'Today @ 10:42 am',
              desc:
                  "Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time.",
            ),
            PostCard(
              profilePath: 'assets/images/placeholder_profile.jpg',
              username: 'Makyismynickname',
              timestamp: 'Today @ 10:42 am',
              desc:
                  "Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time 😅 \n\n Today’s highlight: discovering my shampoo bottle is recyclable. Score! ♻️🧴",
              image: AssetImage('assets/images/intro/intro0.png'),
            ),
          ],
        );
      case ProfileSection.wasteLog:
        return WastelogBoard(
          recylable: 32,
          biodegradable: 80,
          nonbiodegradable: 12,
        );
      case ProfileSection.cleanup:
        return CleanupView(
          posts: [
            CleanupCard(
              username: 'Makyismynickname',
              profilePath: 'assets/images/placeholder_profile.jpg',
              timestamp: 'Today @ 10:42 am',
              title: 'Eco Walk: Clean & Collect',
              scheduledDate: 'Saturday, May 4, 2025 UTC',
              scheduledTime: '9:00 AM - 12:00 PM',
              address: 'Central Riverside Park, EcoZone Area B',
            ),
            CleanupCard(
              username: 'Makyismynickname',
              profilePath: 'assets/images/placeholder_profile.jpg',
              timestamp: 'Today @ 10:42 am',
              image: AssetImage('assets/images/intro/intro0.png'),
              title: 'Eco Walk: Clean & Collect',
              scheduledDate: 'Saturday, May 4, 2025 UTC',
              scheduledTime: '9:00 AM - 12:00 PM',
              address: 'Central Riverside Park, EcoZone Area B',
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
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
                      username: fullName ?? '',
                      image: NetworkImage(
                        'https://s.yimg.com/ny/api/res/1.2/xezrRzHlbJxiqI0S_Z15UA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTQ3NQ--/https://media.zenfs.com/en/buzzfeed_articles_778/2fef0be25b6343c5dbf349561ab37a3c',
                      ),
                      followers: 353,
                      following: 257,
                    ),

                    SizedBox(height: 38),

                    // Eco Streak Section
                    Text(
                      'Eco Streak',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    StreakCalendar(),

                    SizedBox(height: 31),

                    // Badges
                    BadgeGrid(badgeIdList: [1, 2, 3, 4, 5, 6, 7, 8]),

                    SizedBox(height: 33),

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
                          _selectedSection = ProfileSection.cleanup;
                        });
                      },
                    ),

                    SizedBox(height: 18),

                    // View Body & Animated Switcher
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
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
  }
}
