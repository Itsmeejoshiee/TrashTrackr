import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.profilePath,
    required this.username,
    required this.timestamp,
    required this.desc,
    this.image,
  });

  final String profilePath;
  final ImageProvider? image;
  final String username;
  final String timestamp;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: AssetImage(
                  profilePath,
                ),
              ),
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

          Text(
            desc,
            style: kPoppinsBodyMedium.copyWith(fontSize: 12),
          ),

          (image != null) ? Container(
            width: double.infinity,
            height: 212,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              image: DecorationImage(image: image!, fit: BoxFit.cover)
            ),
          ) : SizedBox(),

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
