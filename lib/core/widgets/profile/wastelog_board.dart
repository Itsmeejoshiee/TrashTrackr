import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';
import 'package:trashtrackr/features/waste_stats/frontend/waste_stats_screen.dart';

class WastelogBoard extends StatefulWidget {
  const WastelogBoard({super.key});

  @override
  State<WastelogBoard> createState() => _WastelogBoardState();
}

class _WastelogBoardState extends State<WastelogBoard> {
  final UserService _userService = UserService();

  int recylable = 0;
  int biodegradable = 0;
  int nonbiodegradable = 0;

  Future<void> _initClassificationCount() async {
    final classifications = await _userService.countDisposalClassifications();
    setState(() {
      recylable = classifications!['Recyclable']!;
      biodegradable = classifications['Biodegradable']!;
      nonbiodegradable = classifications['Non-biodegradable']!;
    });
  }

  @override
  void initState() {
    super.initState();
    _initClassificationCount();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/recycling.png',
                  width: 20,
                  height: 20,
                ),
                Text(
                  '$recylable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recyclable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => WasteStatsScreen(updateView: false),
                        ),
                      ),
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/leaf_brown.png',
                  width: 18,
                  height: 18,
                ),
                Text(
                  '$biodegradable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Biodegradable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed:
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WasteStatsScreen(updateView: false),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 216,
            width: screenWidth * 0.25,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/trashcan.png',
                  width: 20,
                  height: 20,
                ),
                Text(
                  '$nonbiodegradable',
                  style: kPoppinsDisplaySmall.copyWith(
                    fontSize: 39.53,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Non-Biodegradable',
                  style: kBodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed:
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WasteStatsScreen(updateView: false),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
