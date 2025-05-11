import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../../meta_phrase_pv/controllers/meta_phrase_pv_controller.dart';
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
                          // getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          //   final label = categories[rodIndex];
                          //   return BarTooltipItem(
                          //     "$label: ${rod.toY.toInt()}",
                          //     const TextStyle(color: Colors.white),
                          //   );
                          // },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final label = categories[rodIndex];
                            final date = data[groupIndex].date; // Get the date for the tooltip
                            return BarTooltipItem(
                              "$label: ${rod.toY.toInt()} \nDate: $date", // Display both category and date
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),

                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions && response != null && response.spot != null) {
                            final groupIndex = response.spot!.touchedBarGroupIndex;
                            final rodIndex = response.spot!.touchedRodDataIndex;

                            final tappedCategory = categories[rodIndex];
                            final tappedValue = data[groupIndex].values[tappedCategory] ?? 0;
                            final tappedDate = data[groupIndex].date;
                            log('Tapped on: Category=$tappedCategory, Value=$tappedValue, Date=$tappedDate');
                            print(true); // 👈 This prints true on tap
                            controller.fetchTraces(tappedCategory,tappedDate);
                          }
                        },
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
  Widget _buildHeaderRow(BuildContext context) {
    return Column(
      children: [
        // Top Fixed Row (Upload + Checkboxes)
        // Scrollable Header Buttons Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _headerButton("Event ID", SortGovernColumn.id),
              _headerButton("Prompt", SortGovernColumn.name),
              _headerButton("Execution Time", SortGovernColumn.executionTime),
              _headerButton("Cost (\$)", SortGovernColumn.totalCost),
              _headerButton("Latency", SortGovernColumn.latency),
              _headerButton("Tokens", SortGovernColumn.tokens),
              _headerButton("User", SortGovernColumn.user),
              _headerButton("Remarks", SortGovernColumn.recommendedAction),
            ],
          ),
        ),
      ],
    );
  }
  Widget _headerButton(String title, SortGovernColumn column) {
    return Obx(() {
      final isSelected = controller.sortGovernColumn.value == column;
      final icon = isSelected ? (controller.isAscending.value ? Icons.arrow_upward : Icons.arrow_downward) : Icons.unfold_more;

      return InkWell(
        onTap: () => controller.toggleSort(column),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 120,
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? appDashBoardCardColor : appWhiteColor,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(width: 4),
              Icon(icon, size: 16),
            ],
          ),
        ),
      );
    });
  }
  Widget _buildFileList() {
    return ListView.builder(
      itemCount: controller.filteredFiles.length,
      itemBuilder: (_, index) {
        final item = controller.filteredFiles[index];
        return GestureDetector(
          onTap: () {
            // controller.fetchMetaDataById(item.id);
            // // Set the selected translation report and toggle visibility
            // selectedTranslationReport.value = item;
            // controller.isCardSelected.value = true;
            // setValue("setid", item.id.toString());
            // setValue("setfileName", item.fileName.toString());
            // setValue("setsourceLanguage", item.sourceLanguage.toString());
            // setValue("setscore", item.score.toString());
            // setValue("setoriginalCount", item.originalCount.toString());
            // setValue("settranslatedCount", item.translatedCount.toString());
          },
          child: Card(
            color: appDashBoardCardColor,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("executionTime: ${item.executionTime}"),
                  Text("totalCost: ${item.totalCost}"),
                  Text("latency: ${item.latency}"),
                ],
              ),
              trailing: Text("Score\n${item.recommendedAction}", textAlign: TextAlign.center),
            ),
          ),
        );
      },
    );
  }
}
