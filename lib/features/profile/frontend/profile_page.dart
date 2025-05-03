import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/profile/cleanup_widget.dart';
import 'package:trashtrackr/core/widgets/profile/post_widget.dart';
import 'package:trashtrackr/core/widgets/profile/streak_calendar.dart';
import 'package:trashtrackr/core/widgets/list_tiles/faq_tile.dart';
import 'package:trashtrackr/core/widgets/profile/user_badges_widget.dart';
import 'package:trashtrackr/core/widgets/profile/wastelog_widget.dart';

enum ProfileSection { posts, wasteLog, cleanup }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileSection _selectedSection = ProfileSection.posts;

  Widget getSectionWidget() {
    switch (_selectedSection) {
      case ProfileSection.posts:
        return PostWidget(key: ValueKey('posts'));
      case ProfileSection.wasteLog:
        return WastelogWidget(key: ValueKey('wastelog'));
      case ProfileSection.cleanup:
        return CleanupWidget(key: ValueKey('cleanup'));
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(
              'Settings',
              style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              SizedBox(width: 10),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Ella Green',
                        style: kHeadlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(
                              '352',
                              style: kTitleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Followers',
                              style: kLabelLarge.copyWith(
                                color: kAvocado.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          foregroundImage: NetworkImage(
                            'https://s.yimg.com/ny/api/res/1.2/xezrRzHlbJxiqI0S_Z15UA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTQ3NQ--/https://media.zenfs.com/en/buzzfeed_articles_778/2fef0be25b6343c5dbf349561ab37a3c',
                          ),
                          radius: 46,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(
                              '257',
                              style: kTitleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Following',
                              style: kLabelLarge.copyWith(
                                color: kAvocado.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 38),
                    Text(
                      'Eco Streak',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    StreakCalendar(),
                    SizedBox(height: 31),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Badges',
                          style: kTitleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Show more',
                            style: kPoppinsBodyMedium.copyWith(color: kAvocado),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 13),
                    UserBadgesWidget(),
                    SizedBox(height: 33),

                    /// SECTION SWITCH BUTTONS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedSection = ProfileSection.posts;
                              });
                            },
                            child: Text(
                              'Posts',
                              style: kTitleSmall.copyWith(
                                color:
                                    _selectedSection == ProfileSection.posts
                                        ? kAvocado
                                        : kGray.withOpacity(0.3),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedSection = ProfileSection.wasteLog;
                              });
                            },
                            child: Text(
                              'Waste Log',
                              style: kTitleSmall.copyWith(
                                color:
                                    _selectedSection == ProfileSection.wasteLog
                                        ? kAvocado
                                        : kGray.withOpacity(0.3),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedSection = ProfileSection.cleanup;
                              });
                            },
                            child: Text(
                              'Clean-up',

                              style: kTitleSmall.copyWith(
                                color:
                                    _selectedSection == ProfileSection.cleanup
                                        ? kAvocado
                                        : kGray.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: getSectionWidget(),
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
