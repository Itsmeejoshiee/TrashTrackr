import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/date_utils.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'package:trashtrackr/features/log_disposal/screens/log_disposal_screen.dart';
import 'package:trashtrackr/features/maps/frontend/map_screen.dart';
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
  bool _statsLoading = true;
  int? _currentStreak;
  int? _activityCount;
  int? _badgesCount;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentStats();
  }

  Future<void> _loadCurrentStats() async {
    final activities = await _activityService.getAllActivities(false);
    final activityCount = await _activityService.getAllActivities(true);
    final streak = _dateUtilsHelper.getCurrentStreakFromActivities(activities);
    final badges = await _activityService.getEarnedBadges();
    if (mounted) {
      setState(() {
        _currentStreak = streak;
        _activityCount = activityCount;
        _badgesCount = badges;
        _statsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            _statsLoading) {
          return Center(child: CircularProgressIndicator(color: kAvocado));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('User data is not available.'));
        }
        final user = snapshot.data;
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
                      SizedBox(height: 50),

                      // Dashboard App Bar
                      DashboardAppBar(
                        username: '${user?.firstName}',
                        onNotifs: () {},
                      ),

                      DashboardSearchBar(controller: TextEditingController()),

                      QuickActionPanel(
                        onWasteStats: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WasteStatsScreen(),
                            ),
                          );
                        },
                        onCommunity: () {
                          //TODO: Implement community action
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
                          //TODO: Implement games action
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
                          SectionLabel(
                            label: 'Tips n Tricks',
                            onShowMore: () {},
                          ),

                          Container(
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
                        ],
                      ),

                      SizedBox(height: 20),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SectionLabel(
                            label: 'Current Stats',
                            onShowMore: () {},
                          ),
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
                          DisposalLocationButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      SectionLabel(label: 'Earned Badges'),
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
