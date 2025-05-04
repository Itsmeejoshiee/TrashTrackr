import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/eco_badge.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'widgets/badge_box.dart';

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  NavRoute _selectedRoute = NavRoute.badge;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double badgeTitleOffset = screenHeight / ((screenHeight < 800) ? 40 : 20);
    final double imageSize = (screenWidth / 2.5) + 60;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: badgeTitleOffset),
          Image.asset(
            'assets/images/badges/badges_title.png',
            width: imageSize,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  BadgeBox(badge: EcoBadge.greenStreaker),
                  BadgeBox(badge: EcoBadge.ecoChampion),
                  BadgeBox(badge: EcoBadge.greenStreaker),
                  BadgeBox(badge: EcoBadge.dailyDiligent),
                  BadgeBox(badge: EcoBadge.weekendWarrior),
                  BadgeBox(badge: EcoBadge.scannerRookie),
                  BadgeBox(badge: EcoBadge.sortingExpert),
                  BadgeBox(badge: EcoBadge.plasticBuster),
                  BadgeBox(badge: EcoBadge.barcodeSleuth),
                  BadgeBox(badge: EcoBadge.zeroWasteHero),
                  BadgeBox(badge: EcoBadge.ecoInfluencer),
                  BadgeBox(badge: EcoBadge.cleanupCaptain),
                  BadgeBox(badge: EcoBadge.trashTrackrOg),
                  BadgeBox(badge: EcoBadge.quizMaster),
                ],
              ),
            ),
          ),
        ],
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
