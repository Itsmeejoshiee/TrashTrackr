import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/auth_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double leafWallWidth = screenWidth * 1.4;
    print(leafWallWidth);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
        
            // Leaf Wall Image
            Expanded(
              flex: 5,
              child: LeafWall(width: leafWallWidth),
            ),
        
            // Welcome Message & Auth Buttons
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      style: kDisplaySmall.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Welcome to TrashTrackr',
                      style: kTitleLarge.copyWith(color: Colors.white),
                    ),
        
                    // Dynamic Offset
                    const Expanded(child: SizedBox()),
        
                    AuthButton(title: 'Login', onPressed: () {}),
        
                    // Offset
                    const SizedBox(height: 10),
        
                    AuthButton(title: 'Sign up', onPressed: () {}),
        
                    // Dynamic Offset
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeafWall extends StatelessWidget {
  const LeafWall({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/leaf_wall.png',
              width: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // other widgets can go here, layered on top
      ],
    );
  }
}
