import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pc;
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/box/neo_box.dart';
import '../widgets/graph_card.dart';
import '../widgets/graph_switch_tile.dart';

class SummaryViewContent extends StatelessWidget {
  final int wasteCount;
  final bool updateView;
  final VoidCallback onFirstView;
  final VoidCallback onSecondView;
  final String firstViewTitle;
  final String secondViewTitle;
  final Map<String, int> classificationCounts;
  final List<FlSpot> spots;

  const SummaryViewContent({
    super.key,
    required this.wasteCount,
    required this.updateView,
    required this.onFirstView,
    required this.onSecondView,
    required this.firstViewTitle,
    required this.secondViewTitle,
    required this.classificationCounts,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = (screenWidth / 9);

    List<Color> colorList = [
      kAppleGreen,
      const Color(0xffB7D36F),
      const Color(0xffDBE7BD),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
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
                      Image.asset("assets/images/icons/waste_stats_icon.png", width: imageSize),
                      const SizedBox(height: 15),
                      Text(
                        "$wasteCount",
                        style: kDisplayLarge.copyWith(fontSize: screenWidth / 10, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "times",
                        style: kTitleMedium.copyWith(fontSize: screenWidth / 30),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: pc.PieChart(
                  dataMap: {
                    "Recyclable": classificationCounts['Recyclable']?.toDouble() ?? 0,
                    "Biodegradable": classificationCounts['Biodegradable']?.toDouble() ?? 0,
                    "Non-biodegradable": classificationCounts['Non-biodegradable']?.toDouble() ?? 0,
                  },
                  colorList: colorList,
                  chartLegendSpacing: 12,
                  chartRadius: screenWidth / 3,
                  chartValuesOptions: const pc.ChartValuesOptions(showChartValues: false),
                  legendOptions: const pc.LegendOptions(
                    legendPosition: pc.LegendPosition.bottom,
                    legendShape: BoxShape.rectangle,
                    legendTextStyle: TextStyle(fontSize: 12),
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 20),
          GraphSwitchTile(
            value: updateView,
            firstViewTitle: firstViewTitle,
            secondViewTitle: secondViewTitle,
            onFirstView: onFirstView,
            onSecondView: onSecondView,
          ),
          const SizedBox(height: 5),
          GraphCard(isWeeklyView: updateView, spots: spots),

          SizedBox(height: 50),
        ],
      ),
    );
  }
}


