import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../controllers/meta_phrase_pv_controller.dart';
import '../model/open_worklist_model.dart';
import '../model/transalted_model.dart';

class MetaPhraseScreen extends StatelessWidget {
  final MetaPhraseController controller = Get.put(MetaPhraseController());

  // Store the selected file locally
  var selectedTranslationReport = Rx<TranslationWork?>(null);

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

  Widget _buildSelectedCard(BuildContext context, TranslationReport? selectedTranslationReport) {
    String id = getStringAsync("setid");
    String fileName = getStringAsync("setfileName");
    String sourceLanguage = getStringAsync("setsourceLanguage");
    String score = getStringAsync("setscore");
    String originalCount = getStringAsync("setoriginalCount");
    String translatedCount = getStringAsync("settranslatedCount");
    log("id------------------------------$id");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Selected card is displayed
            Card(
              color: appDashBoardCardColor,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(fileName, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Language: $sourceLanguage"),
                    Text("Original: $originalCount → Translated: $translatedCount"),
                  ],
                ),
                trailing: Text("Score\n$score", textAlign: TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () async {
                controller.isCardSelected.value = false;
                controller.selectedTranslationReport.value = null;
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_circle_up_rounded),
              ),
            ),
            Card(
              color: appDashBoardCardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  /// Button Row with icons & dynamic colors
                  Obx(() {
                    String mode = controller.selectedMode.value;

                    Color getColor(String label) {
                      int currentIndex = controller.modes.indexOf(mode);
                      int labelIndex = controller.modes.indexOf(label);

                      if (label == mode) return Colors.blue;
                      if (labelIndex < currentIndex) return Colors.green;

                      return Colors.grey.shade300;
                    }

                    IconData getIcon(String label) {
                      switch (label) {
                        case 'Review':
                          return Icons.rate_review;
                        case 'Edit':
                          return Icons.edit_note;
                        case 'Peer Review':
                          return Icons.people_outline;
                        case 'Certify':
                          return Icons.verified_user;
                        default:
                          return Icons.help_outline;
                      }
                    }

                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.modes.map((label) {
                          return Expanded(
                            child: Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                color: getColor(label),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(getIcon(label), color: Colors.white),
                                      const SizedBox(height: 4),
                                      Marquee(
                                        child: Text(
                                          maxLines: 1,
                                          label,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList());
                  }).paddingOnly(top: 5, bottom: 10),

                  Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Original File
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("Original File", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ),

                            // Scrollable content for Original File
                            Container(
                              height: 150,
                              padding: const EdgeInsets.all(16),
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: controller.translatedScrollController,
                                child: SingleChildScrollView(
                                  controller: controller.translatedScrollController,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedTranslationReport!.originalFile,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),

                      // Translated File Card with Scrollable content
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Row with Fullscreen Icon
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "Translated File",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.fullscreen),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.white,
                                          child: Scaffold(
                                            appBar: AppBar(
                                              title: Text("Translation Details"),
                                              actions: [
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                )
                                              ],
                                            ),
                                            body: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // Original File
                                                      Text(
                                                        "Original File",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.grey.shade300),
                                                        ),
                                                        child: Text(
                                                          selectedTranslationReport.originalFile,
                                                          style: TextStyle(fontSize: 16),
                                                        ),
                                                      ),

                                                      const SizedBox(height: 24),

                                                      // Translated File
                                                      Text(
                                                        "Translated File",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Container(
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: Colors.grey.shade300),
                                                        ),
                                                        child: Text(
                                                          selectedTranslationReport.translatedFile,
                                                          style: TextStyle(fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),

                            // Scrollable Content (non-fullscreen view)
                            Container(
                              height: 150,
                              padding: const EdgeInsets.all(16),
                              child: Scrollbar(
                                controller: controller.translatedScrollController1,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: controller.translatedScrollController1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedTranslationReport.translatedFile,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  /// Dropdown styled like a button
                  Obx(() {
                    final selected = controller.selectedMode.value;
                    final certifyOptions = ['Finalize', 'Return', 'Reject'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: appBackGroundColor,
                                    border: Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: appBackGroundColor,
                                      value: selected,
                                      icon: const Icon(Icons.arrow_drop_down, color: appWhiteColor),
                                      style: const TextStyle(fontSize: 16, color: appWhiteColor),
                                      isExpanded: true,
                                      items: controller.modes.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          controller.updateSelectedMode(newValue);
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                // Only show this if 'Certify' is selected
                                if (selected == 'Certify') const SizedBox(height: 8),

                                if (selected == 'Certify')
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: certifyOptions.map((option) {
                                        return InkWell(
                                          onTap: () {
                                            print("Selected: $option");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle_outline, color: Colors.blue),
                                                const SizedBox(width: 10),
                                                Text(
                                                  option,
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      itemCount: controller.filteredFiles.length,
      itemBuilder: (_, index) {
        final item = controller.filteredFiles[index];
        return GestureDetector(
          onTap: () {
            controller.fetchMetaDataById(item.id);
            // Set the selected translation report and toggle visibility
            selectedTranslationReport.value = item;
            controller.isCardSelected.value = true;
            setValue("setid", item.id.toString());
            setValue("setfileName", item.fileName.toString());
            setValue("setsourceLanguage", item.sourceLanguage.toString());
            setValue("setscore", item.score.toString());
            setValue("setoriginalCount", item.originalCount.toString());
            setValue("settranslatedCount", item.translatedCount.toString());
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "MetaPhrase Pv",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: Obx(() {
        return Container(
          color: appBackGroundColor,
          child: Column(
            children: [
              if (!controller.isCardSelected.value && controller.selectedTranslationReport.value == null) ...[
                _buildHeaderRow(),
                Expanded(child: _buildFileList()),
              ],
              if (controller.isCardSelected.value && controller.selectedTranslationReport.value != null) ...[
                Expanded(child: _buildSelectedCard(context, controller.selectedTranslationReport.value)),
              ],
            ],
          ),
        );
      }),
    );
  }
}
