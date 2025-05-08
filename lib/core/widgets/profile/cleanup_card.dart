import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class CleanupCard extends StatelessWidget {
  const CleanupCard({
    super.key,
    required this.profilePath,
    required this.username,
    required this.timestamp,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.title,
    required this.address,
    this.image,
  });

  final String profilePath;
  final ImageProvider? image;
  final String username;
  final String timestamp;
  final String scheduledDate;
  final String scheduledTime;
  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(foregroundImage: AssetImage(profilePath)),
              SizedBox(width: 10),
              Wrap(
                direction: Axis.vertical,
                children: [
                  //User Name
                  Text(
                    username,
                    style: kBodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //Date Posted
                  Text(
                    timestamp,
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

          // Optional Image
          (image != null)
              ? Container(
                width: double.infinity,
                height: 212,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  image: DecorationImage(image: image!, fit: BoxFit.cover),
                ),
              )
              : SizedBox(),

          Text(title, style: kTitleLarge.copyWith(fontWeight: FontWeight.bold)),

          Text(
            '$scheduledDate • $scheduledTime',
            style: kPoppinsBodySmall.copyWith(color: kGray.withOpacity(0.5)),
          ),

          Text(address, style: kPoppinsBodyMedium.copyWith(color: kAvocado)),

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
