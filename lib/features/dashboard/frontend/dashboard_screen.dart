import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/disposal_location_button.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'widgets/badge_carousel.dart';
import 'widgets/dashboard_app_bar.dart';
import 'widgets/quick_action_panel.dart';
import 'widgets/section_label.dart';
import 'widgets/stat_board.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NavRoute _selectedRoute = NavRoute.badge;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  DashboardAppBar(username: 'User', onNotifs: () {}),

                  DashboardSearchBar(controller: TextEditingController()),

                  QuickActionPanel(
                    onWasteStats: () {},
                    onCommunity: () {},
                    onDisposalLoc: () {},
                    onGames: () {},
                    onLogDisposal: () {},
                    onScan: () {},
                  ),

                  SizedBox(height: 20),

                  // Tips n Tricks
                  Column(
                    children: [
                      // Tips n Tricks & Show more
                      SectionLabel(label: 'Tips n Tricks', onShowMore: () {}),

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
                      SectionLabel(label: 'Current Stats', onShowMore: () {}),
                      StatBoard(plasticDisposals: 62, streak: 22, badges: 56),
                    ],
                  ),

                  SizedBox(height: 20),

                  Column(
                    children: [
                      SectionLabel(label: 'Disposal Locations'),
                      DisposalLocationButton(onPressed: () {}),
                    ],
                  ),

                  SizedBox(height: 20),

                  SectionLabel(label: 'Earned Badges'),
                ],
              ),
            ),

            BadgeCarousel(badgeIdList: [5, 9, 10, 3, 1, 14, 11]),

            SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: MainNavigationBar(
        activeRoute: _selectedRoute,
        onSelect: _selectRoute,
      ),

      floatingActionButton: MultiActionFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
