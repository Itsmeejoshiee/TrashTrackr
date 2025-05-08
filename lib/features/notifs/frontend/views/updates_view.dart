import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class UpdatesView extends StatelessWidget {
  const UpdatesView({super.key, required this.context, required this.children,});

  final BuildContext context;
  final List<Widget> children;

  // TODO: Methods for organizing notif cards based on timestamp

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = (screenWidth / 3) + 60;
    final double bottomOffset = screenHeight / 8;

    if (children.isNotEmpty) {
      print('TRIGGERED');
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            spacing: 3,
            children: children,
          ),
        ),
      );
    } else {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/components/no_notifs.png', width: imageSize),
            Text(
              "You're all caught up!",
              style: kDisplaySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text('Nothing new right now.'),
            SizedBox(height: 15),
            Text(
              'Check back later for new challenges,\nbadges, and community updates. 🌱',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: bottomOffset),
          ],
        ),
      );
    }
  }
}