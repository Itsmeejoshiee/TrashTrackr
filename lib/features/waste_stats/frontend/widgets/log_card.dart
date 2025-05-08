import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/constants.dart';

class LogCard extends StatelessWidget {
  const LogCard({
    super.key,
    required this.itemImage,
    required this.name,
    required this.dateTime,
    required this.type
  });

  final Image itemImage;
  final String name;
  final DateTime dateTime;
  final String type;



  @override
  Widget build(BuildContext context) {
    final Map<String, String> typeIconMap = {
      'Recycle': 'assets/images/icons/recycling.png',
      'Biodegradable': 'assets/images/icons/leaf_brown.png',
      'Non-Biodegradable': 'assets/images/icons/trashcan.png',
    };

    final String? iconPath = typeIconMap[type];
    final Widget icon = iconPath != null
        ? Image.asset(iconPath, width: 16, height: 16)
        : const SizedBox.shrink();

    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      width: screenWidth,
      height: 75,

      child: Row(
        children: [
          itemImage,
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: kTitleSmall.copyWith(color: kAvocado, fontWeight: FontWeight.w700),
              ),

              Text(
                DateFormat.yMMMd().add_jm().format(dateTime),
                style: kLabelMedium.copyWith(color: kGray.withOpacity(0.3), fontWeight: FontWeight.w800),
              ),

              Row(
                children: [
                  icon,
                  const SizedBox(width: 6),
                  Text(
                    type,
                    style: kLabelMedium.copyWith(color: kGray.withOpacity(0.3), fontWeight: FontWeight.w800),
                  ),
                ],
              ),

              Text(
                "Scanned",
                style: kBodySmall.copyWith(fontWeight: FontWeight.w800),
              )
            ],
          )
        ],
      ),
    );
  }
}
