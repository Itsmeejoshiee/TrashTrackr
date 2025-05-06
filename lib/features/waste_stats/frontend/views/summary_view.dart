import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/graph_card.dart';
import 'package:trashtrackr/features/waste_stats/frontend/widgets/graph_switch_tile.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/box/neo_box.dart';

class SummaryView extends StatelessWidget {
  final int wasteCount;
  final bool updateView;
  final VoidCallback onFirstView;
  final VoidCallback onSecondView;
  final String firstViewTitle;
  final String secondViewTitle;

  const SummaryView({
    super.key,
    this.wasteCount = 98,
    required this.updateView,
    required this.onFirstView,
    required this.onSecondView,
    required this.firstViewTitle,
    required this.secondViewTitle
  });

  // Pie Chart Placeholder Values
  static const dataMap = <String, double>{
    "Recycle": 5,
    "Biodegradable": 3,
    "Non-Biodegradable": 2,
  };

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = (screenWidth / 9);

    List<Color> colorList = [
      kAppleGreen,
      Color(0xffB7D36F),
      Color(0xffDBE7BD),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Total Waste Diverted",
            style: kTitleMedium.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          Row(
            children: [
              Flexible(
                child: NeoBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/waste_stats_icon.png", width: imageSize),
                      SizedBox(height: 15),
                      Text(
                        "$wasteCount",
                        style: kDisplayLarge.copyWith(fontSize: screenWidth / 10, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "times",
                        style: kTitleMedium.copyWith(fontSize: screenWidth / 30),
                      ),
                    ],
                  ),
                ),
              ),

              Flexible(
                child: PieChart(
                  dataMap: dataMap,
                  colorList: colorList,
                  chartLegendSpacing: 12,
                  chartRadius: screenWidth / 3,
                  chartValuesOptions: ChartValuesOptions(
                    showChartValues: false,
                  ),
                  legendOptions: LegendOptions(
                    legendPosition: LegendPosition.bottom,
                    legendShape: BoxShape.rectangle,
                    legendTextStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          GraphSwitchTile(
            value: updateView,
            firstViewTitle: firstViewTitle,
            secondViewTitle: secondViewTitle,
            onFirstView: onFirstView,
            onSecondView: onSecondView,
          ),

          SizedBox(height: 5),

          (updateView)
              ? GraphCard(value: updateView)
              : GraphCard(value: updateView)
        ],
      ),
    );
  }
}
