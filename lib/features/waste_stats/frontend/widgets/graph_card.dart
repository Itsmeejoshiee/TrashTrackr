import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';


// FIXME: The Line Graph is only a placeholder

class GraphCard extends StatelessWidget {
  const GraphCard({
    super.key,
    required this.value

  });

  final bool value;

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Weekly Graph
    if (value) {
      return NeoBox(
        height: screenHeight/3,
        padding: EdgeInsets.fromLTRB(5,30,30,10),
        child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchSpot) => Color(0xffDBE7BD)
                )
              ),
              minX: 0,
              minY: 0,
              maxY: 50,
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  color: Color(0xff819D39),
                  spots: const [
                    FlSpot(1, 5),
                    FlSpot(2, 8),
                    FlSpot(3, 15),
                    FlSpot(4, 10),
                    FlSpot(5, 20),
                    FlSpot(6, 5),
                    FlSpot(7, 25),
                  ],
                  preventCurveOverShooting: true
                )
              ],
              titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)
                  ),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)
                  ),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return Text('Mon');
                            case 2:
                              return Text('Tue');
                            case 3:
                              return Text('Wed');
                            case 4:
                              return Text('Thu');
                            case 5:
                              return Text('Fri');
                            case 6:
                              return Text('Sat');
                            case 7:
                              return Text('Sun');
                            default:
                              return const SizedBox();
                          }
                        },
                      )
                  )
                )
            )
        ),
      );

    // Monthly Graph
    } else {
      print("this is monthly");
      return NeoBox(
        height: screenHeight/3,
        padding: EdgeInsets.fromLTRB(5,30,30,10),
        child: LineChart(
            LineChartData(
                lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchSpot) => Color(0xffDBE7BD)
                    )
                ),
                minX: 0,
                minY: 0,
                maxY: 100,
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: Color(0xff819D39),
                    spots: const [
                      FlSpot(1, 60),
                      FlSpot(2, 80),
                      FlSpot(3, 40),
                      FlSpot(4, 30),
                      FlSpot(5, 70),
                    ],
                    preventCurveOverShooting: true
                  )
                ],
                titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)
                    ),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 1:
                                return Text('Jan');
                              case 2:
                                return Text('Feb');
                              case 3:
                                return Text('Mar');
                              case 4:
                                return Text('Apr');
                              case 5:
                                return Text('May');
                              default:
                                return const SizedBox();
                            }
                          },
                        )
                    )
                )
            )
        ),
      );
    }


  }
}
