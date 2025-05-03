import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: AssetImage(
                  'assets/images/placeholder_profile.jpg',
                ),
              ),
              SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  //User Name
                  Text(
                    'Elle Green',
                    style: kBodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //Date Posted
                  Text(
                    'Today @ 10:42 am',
                    style: kPoppinsBodyMedium.copyWith(
                      fontSize: 9.95,
                      fontWeight: FontWeight.w500,
                      color: kGray.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Logged 5 disposals today! Finally getting the hang of sorting my waste without checking the label every time.",
            style: kPoppinsBodyMedium.copyWith(fontSize: 12),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark)),
            ],
          ),
        ],
      ),
    );
  }
}
