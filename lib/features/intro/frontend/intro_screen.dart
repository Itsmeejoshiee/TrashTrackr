import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/buttons/intro_button.dart';
import 'badge_intro_page.dart';
import 'challenges_intro_page.dart';
import 'package:card_swiper/card_swiper.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  // Card Swiper Controller
  final SwiperController _swiperController = SwiperController();

  // Card Content
  final List<Map<String, dynamic>> cardContent = [
    {
      'cardColor': kDarkTeal,
      'textColor': kLightGreen,
      'lightColor': kLightGreen,
      'darkColor': kAvocado,
      'title': 'What is\nTrashTrackr?',
      'body':
          "TrashTrackr is more than just an AI-powered waste classifier—it's your all-in-one mobile assistant for responsible living.",
    },
    {
      'cardColor': kLightGreen,
      'textColor': kDarkTeal,
      'lightColor': kAvocado,
      'darkColor': kDarkTeal,
      'title': 'Smart\nClassification?',
      'body':
          "Snap a photo and let TrashTrackr tell you where it belongs—biodegradable, non-biodegradable, or recyclable.",
    },
    {
      'cardColor': kTeal,
      'textColor': kDarkTeal,
      'lightColor': kLightGreen,
      'darkColor': kDarkTeal,
      'title': 'Track Progress\n& Earn Badges',
      'body': "Build eco-habits with daily tasks and unlock badges as you go!",
    },
    {
      'cardColor': kAvocado,
      'textColor': kLightGreen,
      'lightColor': kLightGreen,
      'darkColor': kDarkTeal,
      'title': 'Join Eco\nChallenges!',
      'body':
          "Learn on the go with quick challenges and bite-sized environmental facts.",
    },
  ];
  int cardIndex = 0;

  void _next() {
    if (cardIndex < 3) {
      _swiperController.next();
    } else {
      // TODO: Handle "Get Started"
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: cardContent[cardIndex]['cardColor'],
      body: Stack(
        children: [
          Column(
            children: [

              // Card Image
              Expanded(
                flex: 4,
                child:
                    (cardIndex < 2)
                        ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              scale: 1.2,
                              image: AssetImage(
                                'assets/images/intro/intro$cardIndex.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        )
                        : (cardIndex == 2)
                        ? BadgeIntroPage(context: context)
                        : ChallengesIntroPage(context: context),
              ),

              // Card Swiper
              Expanded(
                flex: 3,
                child: Swiper(
                  loop: false,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _swiperController,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(left: 30, bottom: 60),
                    builder: DotSwiperPaginationBuilder(
                      color: cardContent[cardIndex]['lightColor'],
                      activeColor: cardContent[cardIndex]['darkColor'],
                      space: 5,
                    ),
                  ),
                  itemCount: cardContent.length,
                  onIndexChanged: (index) {
                    // Update card index
                    setState(() {
                      cardIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {

                    // Current Card Content
                    final currentCard = cardContent[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Intro Title Text
                          Text(
                            currentCard['title'],
                            style: kDisplaySmall.copyWith(
                              color: currentCard['textColor'],
                            ),
                          ),

                          // Intro Body Text
                          Text(
                            currentCard['body'],
                            style: kTitleLarge.copyWith(
                              color: currentCard['textColor'],
                            ),
                          ),

                          // Offset
                          SizedBox(height: 15),

                          // Offset
                          SizedBox(height: 15),

                          // Offset
                          SizedBox(height: 15),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Next Card Button
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: Offset(-30, -55),
              child: IntroButton(
                title: (cardIndex == 3) ? 'Get Started' :  'Next ➜',
                color: (cardIndex == 1) ? kLightGreen : null,
                backgroundColor: (cardIndex == 1) ? kAvocado : null,
                onPressed: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
