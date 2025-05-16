import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/auth_service.dart';
import 'package:trashtrackr/core/services/badge_service.dart';
import 'package:trashtrackr/core/services/public_user_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/rounded_rectangle_button.dart';
import 'package:trashtrackr/core/widgets/profile/profile_header.dart';
import 'package:trashtrackr/core/widgets/profile/profile_switch_tile.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/widgets/profile/public_badge_grid.dart';
import 'package:trashtrackr/core/widgets/profile/public_streak_calendar.dart';
import 'package:trashtrackr/core/widgets/profile/public_wastelog_board.dart';

class PublicProfileScreen extends StatefulWidget {
  final String uid;

  const PublicProfileScreen({super.key, required this.uid});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final ActivityService _activityService = ActivityService();
  final BadgeService _badgeService = BadgeService();
  final PublicUserService _publicUserService = PublicUserService();
  ProfileSection _selectedSection = ProfileSection.posts;

  Widget _getSectionWidget(UserModel user) {
    switch (_selectedSection) {
      case ProfileSection.posts:
        return StreamBuilder<List<PostModel>>(
          stream: _publicUserService.getUserPostStream(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kAvocado));
            }
            if (!snapshot.hasData) {
              return Center(child: Text('No posts yet.'));
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
                        style: kHeadlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),

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
            return Column(
              children:
                  snapshot.data!.map((post) => PostCard(post: post)).toList(),
            );
          },
        );
      case ProfileSection.wasteLog:
        // You may want to implement a public version of WastelogBoard if needed
        return PublicWastelogBoard(uid: widget.uid);
      case ProfileSection.events:
        return StreamBuilder<List<EventModel>>(
          stream: _publicUserService.getUserEventStream(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: kAvocado));
            }

            if (!snapshot.hasData) {
              return Center(child: Text('No events yet.'));
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
                        style: kHeadlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),

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

            return Column(
              children:
                  snapshot.data!
                      .map((event) => EventCard(event: event))
                      .toList(),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _publicUserService.getUserStream(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: kLightGray,
            body: Center(child: CircularProgressIndicator(color: kAvocado)),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return Scaffold(
            backgroundColor: kLightGray,
            body: Center(child: Text('User not found.')),
          );
        }
        return Scaffold(
          backgroundColor: kLightGray,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    ProfileHeader(
                      username: '${user.firstName} ${user.lastName}',
                      image:
                          (user.profilePicture.isNotEmpty)
                              ? NetworkImage(user.profilePicture)
                              : AssetImage(
                                'assets/images/placeholder_profile.jpg',
                              ),
                      followers: user.followerCount,
                      following: user.followingCount,
                    ),

                    SizedBox(height: 18),

                    // (_authService.currentUser!.uid != widget.uid)
                    //     ? RoundedRectangleButton(
                    //   title: 'Follow',
                    //   height: 40,
                    //   onPressed: () {
                    //     _userService.incrementFollowingCount();
                    //     _publicUserService.incrementFollowerCount(
                    //       widget.uid,
                    //     );
                    //   },
                    // )
                    //     : SizedBox(),

                    (_authService.currentUser!.uid != widget.uid)
                        ? StreamBuilder<bool>(
                      stream: _publicUserService.isFollowing(user.uid),
                      builder: (context, snapshot) {
                        final isFollowing = snapshot.data ?? false;
                        print('IS FOLLOWING: $isFollowing');
                        if (isFollowing) {
                          return AnimatedOpacity(
                            opacity: 0.6,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                'Following',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return RoundedRectangleButton(
                            title: 'Follow',
                            onPressed: () async {
                              await _userService.incrementFollowingCount();
                              await _publicUserService.incrementFollowerCount(
                                widget.uid,
                              );
                              await _activityService.logActivity('follow');
                              _badgeService.checkTrashTrackrOg();
                              _badgeService.checkScannerRookie();
                              _badgeService.checkGreenStreaker();
                              _badgeService.checkDailyDiligent();
                              _badgeService.checkWeekendWarrior();
                            },
                          );
                        }
                      },
                    )
                        : SizedBox(),

                    SizedBox(height: 18),

                    // Eco Streak Section
                    PublicStreakCalendar(uid: widget.uid),

                    // Badges
                    PublicBadgeGrid(uid: widget.uid),

                    // Offset
                    SizedBox(height: 30),

                    // Switch tile
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

                    // Offset
                    SizedBox(height: 18),

                    // Section content
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: _getSectionWidget(user),
                    ),

                    // Offset
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
