import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/public_user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class PublicWastelogBoard extends StatefulWidget {
  const PublicWastelogBoard({super.key, required this.uid});

  final String uid;

  @override
  State<PublicWastelogBoard> createState() => _PublicWastelogBoardState();
}

class _PublicWastelogBoardState extends State<PublicWastelogBoard> {
  final PublicUserService _publicUserService = PublicUserService();

  int recylable = 0;
  int biodegradable = 0;
  int nonbiodegradable = 0;

  Future<void> _initClassificationCount() async {
    final classifications = await _publicUserService
        .countDisposalClassifications(widget.uid);
    setState(() {
      recylable = classifications['Recyclable']!;
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
            height: 160,
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
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 160,
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
              ],
            ),
          ),
          SizedBox(width: 10),
          NeoBox(
            height: 160,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
