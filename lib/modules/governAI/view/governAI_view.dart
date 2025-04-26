import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../controllers/governAI_controller.dart';

class GovernAIScreen extends StatefulWidget {
  @override
  State<GovernAIScreen> createState() => _GovernAIScreenState();
}

class _GovernAIScreenState extends State<GovernAIScreen> {
  final GovernAIController controller = Get.put(GovernAIController());

  final List<String> categories = ["GenAI PV", "ReconAI", "MetaPhrase PV", "GenAI Clinical", "Engage AI"];

  final List<Color> categoryColors = [
    Colors.blue,
    Colors.grey,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  // Toggle visibility for each category
  late List<bool> categoryVisibility;

  @override
  void initState() {
    super.initState();
    categoryVisibility = List.generate(categories.length, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Govern AI",
      appBarTitleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      body: Obx(() {
        final data = controller.countTracesList;
        if (data.isEmpty && controller.isLoading.value == false) {
          return const Center(child: Text("No data available"));
        }
        if (data.isNotEmpty) {
          return Column(
            children: [
              Container(
                height: screenHeight.size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BarChart(
                    BarChartData(
                      barGroups: List.generate(data.length, (groupIndex) {
                        final item = data[groupIndex];
                        return BarChartGroupData(
                          x: groupIndex,
                          barRods: List.generate(categories.length, (catIndex) {
                            final value = item.values[categories[catIndex]] ?? 0;
                            final show = categoryVisibility[catIndex] && value != 0;
                            return BarChartRodData(
                              toY: show ? value.toDouble() : 0,
                              color: show ? categoryColors[catIndex] : Colors.transparent,
                              width: show ? 8 : 0,
                              borderRadius: BorderRadius.circular(0),
                            );
                          }),
                          barsSpace: 2,
                        );
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index >= 0 && index < data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4), //,left: 20,right: 50),
                                  child: Text(
                                    data[index].date,
                                    style: const TextStyle(fontSize: 8),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25, // Increased to avoid overlap
                            getTitlesWidget: (value, _) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 0, left: 0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      groupsSpace: 40,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final label = categories[rodIndex];
                            return BarTooltipItem(
                              "$label: ${rod.toY.toInt()}",
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              5.height,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: -4,
                  alignment: WrapAlignment.start,
                  children: List.generate(categories.length, (index) {
                    return FilterChip(
                      showCheckmark: false,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            categoryVisibility[index] ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 18,
                            color: categoryVisibility[index] ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            categories[index],
                            style: TextStyle(
                              color: categoryVisibility[index] ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: categoryColors[index].withOpacity(0.3),
                      selectedColor: categoryColors[index],
                      selected: categoryVisibility[index],
                      padding: EdgeInsets.all(0),
                      checkmarkColor: categoryColors[index],
                      onSelected: (val) {
                        setState(() {
                          categoryVisibility[index] = val;
                        });
                      },
                    );
                  }),
                ),
              ),
            ],
          );
        }
        return SizedBox();
      }),
    );
  }
}
