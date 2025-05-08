import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/date_button.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/log_card.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/types_button.dart';

class LogHistoryView extends StatelessWidget {
  const LogHistoryView({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // FIXME: Buttons are not yet functional
          // Filter Buttons
          Row(
            children: [
              DateButton(
                onPressed: () {},
              ),

              SizedBox(width: 8),

              TypesButton(
                  onPressed: () {}
              )
            ],
          ),

          // Today Section
          Row(
            children: [
              Text(
                "Today",
                style: kTitleMedium.copyWith(color: kAvocado, fontWeight: FontWeight.w700),
              ),
              
              Flexible(
                child: Divider(
                  indent: 20,
                  thickness: 2,
                  color: Color(0xff868686),
                )
              )

            ],
          ),

          // Today Log Cards
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 6, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Non-Biodegradable",
          ),
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 6, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Recycle",
          ),
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 6, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Biodegradable",
          ),

          // Yesterday Section
          Row(
            children: [
              Text(
                "Yesterday",
                style: kTitleMedium.copyWith(color: kAvocado, fontWeight: FontWeight.w700),
              ),

              Flexible(
                  child: Divider(
                    indent: 20,
                    thickness: 2,
                    color: Color(0xff868686),
                  )
              )

            ],
          ),

          // Yesterday Log Cards
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 5, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Recycle",
          ),
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 5, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Biodegradable",
          ),

          // Earlier Section
          Row(
            children: [
              Text(
                "Earlier",
                style: kTitleMedium.copyWith(color: kAvocado, fontWeight: FontWeight.w700),
              ),

              Flexible(
                  child: Divider(
                    indent: 20,
                    thickness: 2,
                    color: Color(0xff868686),
                  )
              )

            ],
          ),

          // Earlier Log Cards
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 2, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Recycle",
          ),
          LogCard(
            itemImage: Image.asset("assets/images/covers/log_image.png"),
            name: "Coca-cola Glass 100 ml",
            dateTime: DateTime(2025, 5, 1, 0, 01), // Format => Year, Month, Day, Hour (24-hour), minutes
            type: "Biodegradable",
          ),

        ],
      )
    );
  }
}
