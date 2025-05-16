// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'package:trashtrackr/features/community/frontend/community_screen.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_disposal_screen.dart';
import 'package:trashtrackr/features/maps/frontend/map_screen.dart';
import 'package:trashtrackr/features/notifs/frontend/notif_screen.dart';
import 'package:trashtrackr/features/placeholder/placeholder_screen.dart';
import 'package:trashtrackr/features/placeholder/widgets/placeholder_alert.dart';
import 'package:trashtrackr/features/waste_scanner/frontend/waste_scanner_screen.dart';
import 'package:trashtrackr/features/waste_stats/frontend/waste_stats_screen.dart';
import 'widgets/badge_carousel.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/quick_action_panel.dart';
import 'widgets/section_label.dart';
import 'widgets/stat_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavRoute _selectedRoute = NavRoute.badge;
  final UserService _userService = UserService();
  final ActivityService _activityService = ActivityService();
  final DateUtilsHelper _dateUtilsHelper = DateUtilsHelper();
  bool _dataLoading = true;
  int? _currentStreak;
  int? _activityCount;
  int? _badgesCount;
  String? _greetingMessage;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final activities = await _activityService.getAllActivities(false);
    final activityCount = await _activityService.getScanCount();
    final streak = _dateUtilsHelper.getCurrentStreakFromActivities(activities);
    final badges = await _activityService.getEarnedBadges();
    final greetingMessage = await _dateUtilsHelper.getGreetingMessage();
    if (mounted) {
      setState(() {
        _currentStreak = streak;
        _activityCount = activityCount;
        _badgesCount = badges;
        _greetingMessage = greetingMessage;
        _dataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.getUserStream(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isUserDataReady = snapshot.hasData && user != null;
        if (!isUserDataReady || _dataLoading) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      // Offset
                      SizedBox(height: 60),

                      // Dashboard App Bar
                      DashboardAppBar(
                        greetingMessage: _greetingMessage,
                        username: user.firstName,
                        onNotifs:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotifScreen(),
                              ),
                            ),
                      ),
                      SizedBox(height: 20),
                      QuickActionPanel(
                        onWasteStats: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      WasteStatsScreen(updateView: true),
                            ),
                          );
                        },
                        onCommunity: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityScreen(),
                            ),
                          );
                        },
                        onDisposalLoc: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                        },
                        onGames: () {
                          //TODO: Implement Games
                          PlaceholderAlert().showPlaceholderConstructionAlert(
                            context,
                          );
                        },
                        onLogDisposal: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogDisposalScreen(),
                            ),
                          );
                        },
                        onScan: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WasteScannerScreen(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // Tips n Tricks
                      Column(
                        children: [
                          // Tips n Tricks & Show more
                          SectionLabel(label: 'Tips & Tricks'),

                          GestureDetector(
                            onTap: () {
                              PlaceholderAlert()
                                  .showPlaceholderConstructionAlert(context);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/covers/tips_n_tricks.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SectionLabel(label: 'Current Stats'),
                          StatBoard(
                            wasteDisposals: _activityCount ?? 0,
                            streak: _currentStreak ?? 0,
                            badges: _badgesCount ?? 0,
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Column(
                        children: [
                          SectionLabel(label: 'Disposal Locations'),
                          DisposalLocationButton(),
                        ],
                      ),
                    ],
                  ),
                ),

                BadgeCarousel(),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
