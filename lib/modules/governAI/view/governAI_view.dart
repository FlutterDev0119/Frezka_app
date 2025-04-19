import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../controllers/governAI_controller.dart';

class GovernAIScreen extends StatelessWidget {
  final GovernAIController controller = Get.put(GovernAIController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarBackgroundColor: appBackGroundColor,
        appBarTitleText: "Govern AI",
        appBarTitleTextStyle: TextStyle(
          fontSize: 20,
          color: appWhiteColor,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.traceList;

          if (data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Example of data for different categories
          final List<LineChartBarData> lineBarsData = [
            LineChartBarData(
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index].totalCost ?? 0.0),
              ),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            ),
            LineChartBarData(
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index].totalCost ?? 0.0),
              ),
              isCurved: true,
              color: Colors.red,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.2)),
            ),
            LineChartBarData(
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index].totalCost ?? 0.0),
              ),
              isCurved: true,
              color: Colors.green,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.2)),
            ),
            LineChartBarData(
              spots: List.generate(
                data.length,
                    (index) => FlSpot(index.toDouble(), data[index].totalCost ?? 0.0),
              ),
              isCurved: true,
              color: Colors.purple,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.purple.withOpacity(0.2)),
            ),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Text(
                            data[index].executionTime.split(" ").last, // show time
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: lineBarsData, // Multiple lines for different categories
              ),
            ),
          );
        }));
  }
}
