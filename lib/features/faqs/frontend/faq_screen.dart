import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/list_tiles/faq_tile.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: kLightGray,
        ),
        Container(
          width: double.infinity,
          height: screenHeight / 6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.50),
              colors: [kAvocado.withOpacity(0.4), kAvocado.withOpacity(0.2), Colors.white.withOpacity(0), Colors.white],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
            title: Text(
              'Settings',
              style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'FAQ',
                    style: kDisplaySmall.copyWith(fontWeight: FontWeight.bold),
                  ),
              
                  // Offset
                  SizedBox(height: 14),
              
                  FaqTile(
                    title: 'What is TrashTrackr',
                    description:
                        'TrashTrackr is your smart, eco-friendly companion that helps you classify waste, build sustainable habits, and engage in a community that cares for the planet. Snap photos to sort your trash, take quizzes, track your eco-streaks, and join clean-up events—all in one app!',
                  ),
              
                  FaqTile(
                    title: 'How does the waste classification work?',
                    description:
                    'TrashTrackr is your smart, eco-friendly companion that helps you classify waste, build sustainable habits, and engage in a community that cares for the planet. Snap photos to sort your trash, take quizzes, track your eco-streaks, and join clean-up events—all in one app!',
                  ),
              
                  FaqTile(
                    title: 'What are badges, and how do I earn them?',
                    description:
                    'TrashTrackr is your smart, eco-friendly companion that helps you classify waste, build sustainable habits, and engage in a community that cares for the planet. Snap photos to sort your trash, take quizzes, track your eco-streaks, and join clean-up events—all in one app!',
                  ),
              
                  FaqTile(
                    title: 'How do I find nearby disposal or recycling centers?',
                    description:
                    'TrashTrackr is your smart, eco-friendly companion that helps you classify waste, build sustainable habits, and engage in a community that cares for the planet. Snap photos to sort your trash, take quizzes, track your eco-streaks, and join clean-up events—all in one app!',
                  ),
              
                  FaqTile(
                    title: 'Is my data private?',
                    description:
                    'TrashTrackr is your smart, eco-friendly companion that helps you classify waste, build sustainable habits, and engage in a community that cares for the planet. Snap photos to sort your trash, take quizzes, track your eco-streaks, and join clean-up events—all in one app!',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
