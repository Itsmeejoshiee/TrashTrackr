import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class GraphCard extends StatelessWidget {
  final bool isWeeklyView;
  final List<FlSpot> spots;

  const GraphCard({
    super.key,
    required this.isWeeklyView,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return NeoBox(
      height: screenHeight / 3,
      padding: const EdgeInsets.fromLTRB(5, 30, 30, 10),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchSpot) => const Color(0xffDBE7BD),
            ),
          ),
          minX: 0,
          minY: 0,
          maxY: 100,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              color: const Color(0xff819D39),
              spots: spots,
              preventCurveOverShooting: true,
            )
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (isWeeklyView) {
                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    if (value >= 1 && value <= 7) {
                      return Text(days[value.toInt() - 1]);
                    }
                  } else {
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                    if (value >= 1 && value <= 5) {
                      return Text(months[value.toInt() - 1]);
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
