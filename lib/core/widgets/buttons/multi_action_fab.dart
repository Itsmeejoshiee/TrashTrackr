import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'dart:math' as math;

import '../../../features/post/frontend/post_screen.dart';

class MultiActionFab extends StatefulWidget {
  const MultiActionFab({super.key});

  @override
  State<MultiActionFab> createState() => _MultiActionFabState();
}

class _MultiActionFabState extends State<MultiActionFab>
    with SingleTickerProviderStateMixin {

  // for Create Post bottom sheet
  void _openPostScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: PostScreen(),
        );
      },
    );
  }

  bool _isDialOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDial() {
    setState(() {
      _isDialOpen = !_isDialOpen;
      if (_isDialOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  List<Widget> _buildSpeedDialItems() {
    final List<SpeedDialItemData> items = [
      SpeedDialItemData(
        icon: Icons.edit_note_outlined,
        color: Colors.green,
        onTap: () {print('Create post button pressed'); _openPostScreen(context);},
        position: 0,
      ),

      SpeedDialItemData(
        icon: Icons.crop_free,
        color: Colors.green,
        onTap: () => print('Scan button pressed'),
        position: 1,
      ),
      SpeedDialItemData(
        icon: Icons.dashboard_customize,
        color: Colors.green,
        onTap: () => print('Dashboard button pressed'),
        position: 2,
      ),
    ];

    return items.map((item) {
      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
        ),
      );

      // Calculate position based on angle
      const double distance = 100.0;
      final double angle = (math.pi / 4) + (item.position * (math.pi / 4));
      final double x = distance * math.cos(angle);
      final double y = -distance * math.sin(angle);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Positioned(
            bottom: 48 - y * animation.value, // Position relative to bottom nav bar
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(x * animation.value, 0),
                child: Opacity(
                  opacity: _controller.value,
                  child: Transform.scale(
                    scale: animation.value,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: FloatingActionButton(
                        elevation: 4,
                        backgroundColor: kAppleGreen,
                        shape: const CircleBorder(),
                        heroTag: 'speedDial_${item.position}',
                        onPressed: () {
                          print('MULTI FAB CLICKED ${item.position}');
                          item.onTap();
                          _toggleDial();
                        },
                        child: Icon(item.icon, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 25, // Position relative to bottom of screen
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              elevation: 6,
              backgroundColor: kAvocado,
              shape: const CircleBorder(),
              onPressed: _toggleDial,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * math.pi * (3 / 4),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ..._buildSpeedDialItems(),
      ],
    );
  }
}

class SpeedDialItemData {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int position;

  SpeedDialItemData({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.position,
  });
}