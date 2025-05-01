import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    SizedBox(height: 20),
                
                    Text(
                      'About TrashTrackr',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                
                    NeoBox(
                      child: Text(
                        "TrashTrackr is your smart, eco-companion, designed to make waste disposal easy, educational, and empowering. Whether you're snapping a photo to identify how to dispose of an item or tracking your personal environmental impact, TrashTrackr helps you reduce waste, build green habits, and join a movement that’s changing the world—one item at a time.\n\nWith intelligent waste classification, interactive challenges, and a supportive community, TrashTrackr turns everyday actions into real, trackable change for the planet.",
                        style: kBodySmall,
                      ),
                    ),
                
                    Container(
                      width: double.infinity,
                      height: 168,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        image: DecorationImage(
                          image: AssetImage('assets/images/about-photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                
                    // Offset
                    SizedBox(height: 40),
                
                    Text(
                      'Our Mission',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                
                    NeoBox(
                      child: Text(
                        "To simplify sustainable living and help everyone become more mindful of their daily waste through fun, tech-powered tools that educate, encourage, and inspire.",
                        style: kBodySmall,
                      ),
                    ),
                
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

class NeoBox extends StatelessWidget {
  const NeoBox({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(1.00, 1.00),
          colors: [Colors.white, const Color(0xFFF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Color(0xE5E0E0E0),
            blurRadius: 13,
            offset: Offset(5, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xE5FFFFFF),
            blurRadius: 10,
            offset: Offset(-5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(5, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33E0E0E0),
            blurRadius: 10,
            offset: Offset(-5, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
