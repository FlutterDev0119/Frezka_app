import 'package:apps/modules/meta_phrase_pv/model/transalted_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../controllers/meta_phrase_pv_controller.dart';

class MetaPhraseScreen extends StatelessWidget {
  final MetaPhraseController controller = Get.put(MetaPhraseController());

  Icon _sortIcon(SortColumn col, SortColumn currentCol, bool ascending) {
    if (col != currentCol) return Icon(Icons.unfold_more, size: 16);
    return ascending ? Icon(Icons.arrow_upward, size: 16) : Icon(Icons.arrow_downward, size: 16);
  }

  Widget _headerButton(String title, SortColumn column) {
    return Obx(() {
      final isSelected = controller.sortColumn.value == column;
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

  Widget _buildHeaderRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _headerButton("Identifier", SortColumn.id),
          _headerButton("Language", SortColumn.sourceLanguage),
          _headerButton("Original", SortColumn.originalCount),
          _headerButton("Translated", SortColumn.translatedCount),
          _headerButton("Score", SortColumn.score),
        ],
      ),
    );
  }

  @override
  // Widget build(BuildContext context) {
  //   return AppScaffold(
  //     appBarBackgroundColor: appBackGroundColor,
  //     appBarTitleText: "MetaPhrase Pv",
  //     appBarTitleTextStyle: TextStyle(
  //       fontSize: 20,
  //       color: appWhiteColor),
  //     body: Obx(() {
  //       return Container(
  //         color: appBackGroundColor,
  //         child: Column(
  //           children: [
  //             _buildHeaderRow(),
  //             // List View
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: controller.filteredFiles.length,
  //                 itemBuilder: (_, index) {
  //                   final item = controller.filteredFiles[index];
  //                     return GestureDetector(
  //                        onTap: () {
  //                          controller.selectedFile.value = item;
  //                          controller.fetchMetaDataById(item.id);
  //
  //                        },
  //                       child: Card(
  //                         color: appDashBoardCardColor,
  //                         margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //                         elevation: 2,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                         child: ListTile(
  //                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //                           title: Text(item.id, style: TextStyle(fontWeight: FontWeight.bold)),
  //                           subtitle: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text("Language: ${item.sourceLanguage}"),
  //                               Text("Original: ${item.originalCount} → Translated: ${item.translatedCount}"),
  //                             ],
  //                           ),
  //                           trailing: Text("Score\n${item.score}", textAlign: TextAlign.center),
  //                           onTap: () {}, //   => Get.to(() => DetailScreen(file: item)),
  //                         ),
  //                       ),
  //                     );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
  // }
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "MetaPhrase Pv",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: Obx(() {
        final selectedFile = controller.selectedFile.value;
        if (selectedFile != null) {
          // If a file is selected, show the selected card with its details
          return Container(
            color: appBackGroundColor,
            child: Column(
              children: [
                Card(
                  color: appDashBoardCardColor,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected File: ${selectedFile.id}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text("Language: ${selectedFile.sourceLanguage}"),
                        SizedBox(height: 5),
                        Text("Original Count: ${selectedFile.originalCount}"),
                        SizedBox(height: 5),
                        Text("Translated Count: ${selectedFile.translatedCount}"),
                        SizedBox(height: 10),
                        Text("Score: ${selectedFile.score}"),
                        SizedBox(height: 20),
                        // Show original text and translated text
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Original Text:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(selectedFile.toString()), // Display original text
                                SizedBox(height: 20),
                                Text(
                                  "Translated Text:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(selectedFile.sourceLanguage), // Display translated text
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // If no file is selected, show the list of files
          return Container(
            color: appBackGroundColor,
            child: Column(
              children: [
                _buildHeaderRow(),
                // List View
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.filteredFiles.length,
                    itemBuilder: (_, index) {
                      final item = controller.filteredFiles[index];

                      return GestureDetector(
                        onTap: () {
                          // controller.selectedFile.value = item;
                          controller.fetchMetaDataById(item.id);
                        },
                        child: Card(
                          color: appDashBoardCardColor,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            title: Text(item.id, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Language: ${item.sourceLanguage}"),
                                Text("Original: ${item.originalCount} → Translated: ${item.translatedCount}"),
                              ],
                            ),
                            trailing: Text("Score\n${item.score}", textAlign: TextAlign.center),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Obx(() {
                  // Check if selected file is not null
                  if (controller.selectedFile.value != null) {
                    final selectedItem = controller.selectedFile.value;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: appDashBoardCardColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            // Display details of the selected file
                            ListTile(
                              title: Text("Original File", style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(selectedItem!.originalFile),
                            ),
                            ListTile(
                              title: Text("Translated File", style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(selectedItem.translatedFile),
                            ),
                            // Display score and language information
                            ListTile(
                              title: Text("Source Language", style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(selectedItem.sourceLanguage),
                            ),
                            ListTile(
                              title: Text("Score", style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(selectedItem.score.toString()),
                            ),
                            // Show sentence score details (if available)
                            if (selectedItem.sentenceScore != null)
                              ...selectedItem.sentenceScore.map((sentenceScore) {
                                return ListTile(
                                  title: Text("Sentence: ${sentenceScore.sentence}"),
                                  subtitle: Text("Score: ${sentenceScore.score}"),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink(); // No file selected, so return empty widget
                  }
                }),

              ],
            ),
          );
        }
      }),
    );
  }

}
