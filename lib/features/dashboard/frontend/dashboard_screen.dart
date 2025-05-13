import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/bars/main_navigation_bar.dart';
import 'package:trashtrackr/core/widgets/buttons/multi_action_fab.dart';
import 'package:trashtrackr/features/badges/frontend/badge_screen.dart';
import 'package:trashtrackr/features/feed/frontend/feed_screen.dart';
import 'package:trashtrackr/features/home/frontend/home_screen.dart';
import 'package:trashtrackr/features/profile/frontend/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NavRoute _selectedRoute = NavRoute.home;

  void _selectRoute(NavRoute route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  Widget _routeBuilder(NavRoute route) {
    switch (route) {
      case NavRoute.home:
        return HomeScreen();
      case NavRoute.feed:
        return FeedScreen();
      case NavRoute.badge:
        return BadgeScreen();
      case NavRoute.profile:
        return ProfileScreen();
      default:
        return Center(child: Text('Unknown route'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routeBuilder(_selectedRoute),

      bottomNavigationBar: MainNavigationBar(
        activeRoute: _selectedRoute,
        onSelect: _selectRoute,
      ),

      floatingActionButton: MultiActionFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
