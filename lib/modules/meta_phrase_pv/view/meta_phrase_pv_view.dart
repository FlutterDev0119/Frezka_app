import 'package:apps/utils/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../../../utils/constants.dart';
import '../../../utils/shared_prefences.dart';
import '../controllers/meta_phrase_pv_controller.dart';
import '../model/open_worklist_model.dart';
import '../model/transalted_model.dart';

class MetaPhraseScreen extends StatelessWidget {
  final MetaPhraseController controller = Get.put(MetaPhraseController());

  // Store the selected file locally
  var selectedTranslationReport = Rx<TranslationWork?>(null);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomPadding: true,
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "MetaPhrase Pv",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: Obx(() {
        return Container(
          color: AppColors.appBackground,
          child: Column(
            children: [
              if (!controller.isCardSelected.value && controller.selectedTranslationReport.value == null) ...[
                if (controller.filteredFiles.isNotEmpty) _buildHeaderRow(context),
                Expanded(child: _buildFileList()),
              ],
              if (controller.isCardSelected.value && controller.selectedTranslationReport.value != null) ...[
                Expanded(child: _buildSelectedCard(context, controller.selectedTranslationReport.value))
              ],
            ],
          ),
        );
      }),
    );
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

  Widget _buildHeaderRow(BuildContext context) {
    return Column(
      children: [
        // Top Fixed Row (Upload + Checkboxes)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Get.bottomSheet(
                  enableDrag: true,
                  isScrollControlled: true,
                  ImageSourceSelectionComponent(
                    onSourceSelected: (imageSource) {
                      hideKeyboard(context);
                      controller.onSourceSelected(imageSource);
                    },
                  ),
                );
              },
              child: Icon(
                Icons.cloud_upload,
                size: 24,
                color: appBackGroundColor,
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.all(appBackGroundColor),
                      value: controller.isPersonalSelected.value,
                      onChanged: controller.togglePersonal,
                    ),
                    const Text('Personal'),
                  ],
                )),
            const SizedBox(width: 10),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      fillColor: MaterialStateProperty.all(appBackGroundColor),
                      value: controller.isWorkGroupSelected.value,
                      onChanged: controller.toggleWorkGroup,
                    ),
                    const Text('Work Group'),
                    5.width,
                  ],
                )),
          ],
        ),
        2.width,

        // Scrollable Header Buttons Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _headerButton("Identifier", SortColumn.id),
              _headerButton("Language", SortColumn.sourceLanguage),
              _headerButton("Original", SortColumn.originalCount),
              _headerButton("Translated", SortColumn.translatedCount),
              _headerButton("Score", SortColumn.score),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCard(BuildContext context, TranslationReport? selectedTranslationReport) {
    String id = getStringAsync("setid");
    String fileName = getStringAsync("setfileName");
    String sourceLanguage = getStringAsync("setsourceLanguage");
    String score = getStringAsync("setscore");
    String originalCount = getStringAsync("setoriginalCount");
    String translatedCount = getStringAsync("settranslatedCount");
    // controller.setText(selectedTranslationReport!.translatedFile);
    // log("----------set text-----------------${controller.translatedText.value}");
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
                child: Icon(Icons.arrow_circle_up_rounded, color: appWhiteColor),
              ).paddingOnly(right: 10, top: 5, bottom: 5),
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

                    List<String> displayModes = mode == 'Review' ? ['Review'] : controller.modes;
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: displayModes.map((label) {
                          return Expanded(
                            child: Container(
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Text(
                                      controller.isReverse.value == false ? "Translated File" : "Reverse translate",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    controller.selectedMode.value == "Edit" && controller.isReverse.value == false
                                        ? IconButton(
                                            iconSize: 20,
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.document_scanner),
                                            onPressed: () {
                                              controller.isScoreHighlightMode.value = false;
                                            },
                                          )
                                        : SizedBox(),
                                    controller.selectedMode.value == "Edit" && controller.isReverse.value == false
                                        ? IconButton(
                                            iconSize: 20,
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.score_outlined),
                                            onPressed: () {
                                              controller.isScoreHighlightMode.value = true;

                                              controller.selectedTranslationReport.value = controller.selectedTranslationReport.value;
                                              // selectedTranslationReport.sentenceScore
                                            },
                                          )
                                        : SizedBox(),
                                    controller.selectedMode.value == "Edit" && controller.isReverse.value == false
                                        ? IconButton(
                                            iconSize: 20,
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.screenshot_monitor_sharp),
                                            onPressed: () {
                                              controller.isScoreHighlightMode.value = false;
                                            },
                                          )
                                        : SizedBox(),
                                    (controller.selectedMode.value == "Review" || controller.selectedMode.value == "Edit")
                                        ? IconButton(
                                            iconSize: 20,
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.compare_arrows),
                                            onPressed: () async {
                                              final text = controller.selectedTranslationReport.value?.translatedFile ?? '';
                                              await controller.fetchReverseTranslation(text);
                                              controller.isScoreHighlightMode.value = false;
                                              // _buildSelectedCard(context, controller.selectedTranslationReport.value,true);
                                            },
                                          )
                                        : SizedBox(),
                                    (controller.selectedMode.value == "Review" || controller.selectedMode.value == "Edit")
                                        ? IconButton(
                                            iconSize: 20,
                                            visualDensity: VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.fullscreen),
                                            onPressed: () {
                                              controller.isScoreHighlightMode.value = false;
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    insetPadding: EdgeInsets.zero,
                                                    backgroundColor: Colors.white,
                                                    child: AppScaffold(
                                                      automaticallyImplyLeading: false,
                                                      appBarBackgroundColor: appBackGroundColor,
                                                      appBarTitleText: "Translation Details",
                                                      appBarTitleTextStyle: TextStyle(
                                                        fontSize: 20,
                                                        color: appWhiteColor,
                                                      ),
                                                      actions: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: appWhiteColor,
                                                          ),
                                                          onPressed: () => Navigator.of(context).pop(),
                                                        )
                                                      ],
                                                      body: Padding(
                                                        padding: const EdgeInsets.all(16),
                                                        child: Scrollbar(
                                                          thumbVisibility: true,
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Original File",
                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Container(
                                                                  padding: const EdgeInsets.all(12),
                                                                  decoration: BoxDecoration(
                                                                    color: appDashBoardCardColor,
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    border: Border.all(color: Colors.grey.shade300),
                                                                  ),
                                                                  child: Text(
                                                                    selectedTranslationReport.originalFile,
                                                                    style: TextStyle(fontSize: 16),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 24),
                                                                Text(
                                                                  "Translated File",
                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Container(
                                                                  padding: const EdgeInsets.all(12),
                                                                  decoration: BoxDecoration(
                                                                    color: appDashBoardCardColor,
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
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ],
                            ),

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
                                      // Obx(() {
                                      //   final isEditingTranslatedFile =
                                      //       controller.selectedMode.value == "Edit" && controller.isReverse.value == false;
                                      //
                                      //   if (isEditingTranslatedFile && controller.isEditing.value) {
                                      //     return TextField(
                                      //       controller: controller.translatedTextController,
                                      //       autofocus: true,
                                      //       maxLines: null,
                                      //       style: const TextStyle(fontSize: 16),
                                      //       decoration: const InputDecoration.collapsed(hintText: ''),
                                      //       onEditingComplete: () {
                                      //         controller.exitEditMode();
                                      //         FocusScope.of(Get.context!).unfocus();
                                      //       },
                                      //       onSubmitted: (_) {
                                      //         controller.exitEditMode();
                                      //         FocusScope.of(Get.context!).unfocus();
                                      //       },
                                      //     );
                                      //   }
                                      //
                                      //   final displayText = controller.isReverse.value
                                      //       ? controller.reverseTranslatedText.value
                                      //       : controller.selectedTranslationReport.value?.translatedFile ?? '';
                                      //
                                      //   return GestureDetector(
                                      //     onTap: () {
                                      //       if (controller.selectedMode.value == "Edit" && !controller.isReverse.value) {
                                      //         controller.enterEditMode();
                                      //       }
                                      //     },
                                      //     child: Text(
                                      //       displayText,
                                      //       style: const TextStyle(fontSize: 16),
                                      //     ),
                                      //   );
                                      // })
                                      // Obx(() {
                                      //   final isScoreHighlight = controller.isScoreHighlightMode.value;
                                      //   log("------------------isScoreHighlight $isScoreHighlight");
                                      //
                                      //   if (isScoreHighlight) {
                                      //     final scoredTexts = controller.selectedTranslationReport.value?.sentenceScore ?? [];
                                      //     log("------------------scoredTexts1 $scoredTexts");
                                      //
                                      //     if (scoredTexts.isEmpty) {
                                      //       return Center(child: Text("No sentences available"));
                                      //     }
                                      //
                                      //     return Wrap(
                                      //       alignment: WrapAlignment.start,
                                      //       children: scoredTexts.map<Widget>((sentenceScore) {
                                      //         final sentence = sentenceScore.sentence;
                                      //         final score = sentenceScore.score;
                                      //
                                      //         Color color = score <= 50 ? Colors.yellow : Colors.green;
                                      //
                                      //         return Text(
                                      //           sentence,
                                      //           style: TextStyle(fontSize: 16, color: color),
                                      //         );
                                      //       }).toList(),
                                      //     );
                                      //   }
                                      //   // Default behavior if isScoreHighlight is false
                                      //   final displayText = controller.isReverse.value
                                      //       ? controller.reverseTranslatedText.value
                                      //       : controller.selectedTranslationReport.value?.translatedFile ?? '';
                                      //   log("------------------displaytext $displayText");
                                      //
                                      //   return GestureDetector(
                                      //     onTap: () {
                                      //       if (controller.selectedMode.value == "Edit" && !controller.isReverse.value) {
                                      //         controller.enterEditMode();
                                      //       }
                                      //     },
                                      //     child: Text(
                                      //       displayText,
                                      //       style: const TextStyle(fontSize: 16),
                                      //     ),
                                      //   );
                                      // })
                                      Obx(() {
                                        final isScoreHighlight = controller.isScoreHighlightMode.value;

                                        // Check if we need to show the scored sentences
                                        if (isScoreHighlight) {
                                          final scoredTexts = controller.selectedTranslationReport.value?.sentenceScore ?? [];

                                          if (scoredTexts.isEmpty) {
                                            return Center(child: Text("No sentences available"));
                                          }

                                          return Wrap(
                                            alignment: WrapAlignment.start,
                                            children: scoredTexts.map<Widget>((sentenceScore) {
                                              final sentence = sentenceScore.sentence;
                                              final score = sentenceScore.score;

                                              Color color = score <= 50 ? Colors.yellow : Colors.green;

                                              return Text(
                                                sentence,
                                                style: TextStyle(fontSize: 16, color: color),
                                              );
                                            }).toList(),
                                          );
                                        }

                                        // Default behavior if isScoreHighlight is false
                                        final displayText = controller.isReverse.value
                                            ? controller.reverseTranslatedText.value
                                            : controller.selectedTranslationReport.value?.translatedFile ?? '';

                                        // Check if we are in "Edit" mode
                                        final isEditingTranslatedFile =
                                            controller.selectedMode.value == "Edit" && controller.isReverse.value == false;
                                        if (isEditingTranslatedFile && controller.isEditing.value) {
                                          return TextField(
                                            controller: controller.translatedTextController,
                                            autofocus: true,
                                            maxLines: null,
                                            style: const TextStyle(fontSize: 16),
                                            decoration: const InputDecoration.collapsed(hintText: ''),
                                            onEditingComplete: () {
                                              controller.exitEditMode();
                                              FocusScope.of(Get.context!).unfocus();
                                            },
                                            onSubmitted: (_) {
                                              controller.exitEditMode();
                                              FocusScope.of(Get.context!).unfocus();
                                            },
                                          );
                                        }

                                        // Display text as normal if not in edit mode
                                        return GestureDetector(
                                          onTap: () {
                                            if (controller.selectedMode.value == "Edit" && !controller.isReverse.value) {
                                              controller.enterEditMode();
                                            }
                                          },
                                          child: Text(
                                            displayText,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  /// Dropdown styled like a button
                  Obx(() {
                    final selected = controller.selectedMode.value;
                    final certifyOptions = ['Finalize', 'Return', 'Reject'];
                    if (selected == 'Peer Review' && controller.isEditing.value==true) {
                      Future.delayed(Duration.zero, () {
                        showPeerReviewDialog(
                          context,
                          () {
                            // Confirm action
                            Get.back();
                          },
                          () {
                            // Cancel action
                            Get.back();
                          },
                        );
                      });
                    }
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
                                    child:
                                    Obx(
                                      () {
                                        return DropdownButton<String>(
                                          dropdownColor: appBackGroundColor,
                                          value: controller.selected.value,
                                          icon: const Icon(Icons.arrow_drop_down, color: appWhiteColor),
                                          style: const TextStyle(fontSize: 16, color: appWhiteColor),
                                          isExpanded: true,
                                          items: controller.modes.map((String value) {
                                            // final isDisabled = selected == 'Review' && value == 'Peer Review';
                                            // // final isDisabled = selected == 'Review' && value == 'Peer Review' && controller.isEditing.value == true;
                                            // // final isPeerReview = value == 'Peer Review' && value == "Edit";
                                            // // final isDisabled = selected == 'Review'  && isPeerReview && !controller.isEditing.value;
                                            //
                                            // return DropdownMenuItem<String>(
                                            //   value: isDisabled ? null : value,
                                            //   enabled: !isDisabled,
                                            //   child: Text(
                                            //     value,
                                            //     style: TextStyle(
                                            //       color: isDisabled ? Colors.grey : appWhiteColor,
                                            //     ),
                                            //   ),
                                            // );
                                            final isPeerReview = value == 'Peer Review';
                                            final isDisabled = (controller.selected == 'Review' && isPeerReview && !controller.isEditing.value);

                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: IgnorePointer(
                                                ignoring: isDisabled,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: isDisabled ? Colors.grey : appWhiteColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue == 'Peer Review' && selected == 'Review' && !controller.isEditing.value) {
                                              // Don't allow selection if not editable
                                              return;
                                            }
                                            // Prevent null (disabled item) from being selected
                                            if (newValue != null) {
                                              controller.updateSelectedMode(newValue);
                                              if (newValue == 'Edit') {
                                                // controller.startEditing();
                                                controller.isReverse.value = false;
                                              }
                                            }
                                          },
                                        );
                                      }
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
                                            if (option == "Finalize") {
                                              showCredentialsDialog(
                                                context,
                                                () {
                                                  Get.back();
                                                },
                                                () {
                                                  Get.back();
                                                },
                                              );
                                              controller.isReturnSelected.value = false;
                                              controller.isRejectSelected.value = false;
                                            } else if (option == "Return") {
                                              controller.isReturnSelected.value = true;
                                              controller.isRejectSelected.value = false;
                                            } else if (option == "Reject") {
                                              controller.isRejectSelected.value = true;
                                              controller.isReturnSelected.value = false;
                                            }

                                            print("Selected: $option");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                            child: Row(
                                              children: [
                                                Icon(
                                                    option == "Return"
                                                        ? Icons.keyboard_return
                                                        : option == "Reject"
                                                            ? Icons.close
                                                            : Icons.check_circle_outline,
                                                    color: Colors.blue),
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
                                if (selected == 'Certify' && controller.isReturnSelected.value)
                                  Obx(() {
                                    if (controller.isReturnSelected.value) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 8,top: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: appWhiteColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            5.height,
                                            Text(
                                              "Return",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              value: controller.selectedReturnReason.value.isEmpty ? null : controller.selectedReturnReason.value,
                                              decoration: const InputDecoration(
                                                hintText: "select a justification/ reasoan for returning",
                                                // labelText: 'Select a reason',
                                                border: OutlineInputBorder(),
                                              ),
                                              items: controller.filteredReturnReasons.map((reason) {
                                                return DropdownMenuItem<String>(
                                                  value: reason,
                                                  child: Marquee(child: Text(reason)),
                                                );
                                              }).toList(),
                                              onChanged: controller.onReturnReasonSelected,
                                            ),
                                            6.height,
                                            TextField(
                                              controller: controller.returnTextController,
                                              maxLines: 4,
                                              decoration: InputDecoration(
                                                hintText: 'Provide your justification for Sentence Structure needs improvement',
                                                border: OutlineInputBorder(),
                                                contentPadding: const EdgeInsets.all(12.0),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle submit action
                                                print('Submitted: ${controller.rejectTextController.text}');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appBackGroundColor,
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                elevation: 3,
                                              ),
                                              child: const Text('Submit',style: TextStyle(color: appWhiteColor),),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                                if (selected == 'Certify' && controller.isRejectSelected.value)
                                  // Obx(() => Column(
                                  //   children: [
                                  //     DropdownButtonFormField<String>(
                                  //       decoration: const InputDecoration(
                                  //         labelText: 'Select a reason',
                                  //         border: OutlineInputBorder(),
                                  //       ),
                                  //       value: controller.selectedReason.value.isEmpty
                                  //           ? null
                                  //           : controller.selectedReason.value,
                                  //       items: controller.reasons.map((reason) {
                                  //         return DropdownMenuItem(
                                  //           value: reason,
                                  //           child: Text(reason),
                                  //         );
                                  //       }).toList(),
                                  //       onChanged: (value) {
                                  //         controller.updateSelectedReason(value);
                                  //       },
                                  //     ),
                                  //     const SizedBox(height: 20),
                                  //     TextField(
                                  //       controller: controller.textRejectController,
                                  //       decoration: const InputDecoration(
                                  //         labelText: 'Or type your reason',
                                  //         border: OutlineInputBorder(),
                                  //       ),
                                  //       onChanged: (text) {
                                  //         controller.clearSelectedIfTyped(text);
                                  //       },
                                  //     ),
                                  //   ],
                                  // )),
                                  Obx(() {
                                    if (controller.isRejectSelected.value) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 8,top: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: appWhiteColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            5.height,
                                            Text(
                                              "Reject",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              value: controller.selectedReason.value.isEmpty ? null : controller.selectedReason.value,
                                              decoration: const InputDecoration(
                                                hintText: "select a justification/ reasoan for rejecting",
                                                // labelText: 'Select a reason',
                                                border: OutlineInputBorder(),
                                              ),
                                              items: controller.filteredReasons.map((reason) {
                                                return DropdownMenuItem<String>(
                                                  value: reason,
                                                  child: Marquee(child: Text(reason)),
                                                );
                                              }).toList(),
                                              onChanged: controller.onReasonSelected,
                                            ),
                                            6.height,
                                            TextField(
                                              controller: controller.rejectTextController,
                                              maxLines: 4,
                                              decoration: InputDecoration(
                                                hintText: 'Provide your justification for Sentence Structure needs improvement',
                                                border: OutlineInputBorder(),
                                                contentPadding: const EdgeInsets.all(12.0),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle submit action
                                                print('Submitted: ${controller.rejectTextController.text}');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appBackGroundColor,
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                elevation: 3,
                                              ),
                                              child: const Text('Submit',style: TextStyle(color: appWhiteColor),),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  })
                              ],
                            ),
                          ],
                        ),
                      ],
                    ).paddingAll(10);
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
              title: Text(item.fileName, style: TextStyle(fontWeight: FontWeight.bold)),
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
}

void showPeerReviewDialog(BuildContext context, VoidCallback onConfirm, VoidCallback onCancel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Color(0xFFF4F0FA), // Light purple background
        child: Container(
          width: 406, // as per your image resolution
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
              SizedBox(height: 16),
              Text(
                "Warning",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "You haven't updated the\ntranslation memory yet.\n\nAre you sure you want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    textStyle: TextStyle(color: appBackGroundColor),
                    onTap: () {
                      Get.back();
                    },
                    child: Text('Cancel'),
                  ),
                  AppButton(
                    color: appBackGroundColor,
                    onTap: ()  {
                      Get.back();
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: white),
                    ),
                  )
                  // TextButton(
                  //   onPressed: onCancel,
                  //   child: Text(
                  //     "Cancel",
                  //     style: TextStyle(color: Colors.blueGrey),
                  //   ),
                  // ),
                  // SizedBox(width: 16),
                  // ElevatedButton(
                  //   onPressed: onConfirm,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     elevation: 0,
                  //   ),
                  //   child: Text(
                  //     "Confirm",
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showCredentialsDialog(BuildContext context, VoidCallback onConfirm, VoidCallback onCancel) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  String storedEmail = getStringAsync(AppSharedPreferenceKeys.userEmail);
  String storedPass = getStringAsync(ConstantKeys.passwordKey);
  emailController.text = storedEmail.toString();
  passwordController.text = storedPass.toString();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Credentials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Password Field with visibility toggle
              ValueListenableBuilder<bool>(
                valueListenable: obscurePassword,
                builder: (context, isObscure, child) {
                  return TextField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButton(
                  //   onPressed: onCancel,
                  //   child: Text("Cancel"),
                  // ),
                  // SizedBox(width: 12),
                  // ElevatedButton(
                  //   onPressed: onConfirm,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //   ),
                  //   child: Text("Confirm"),
                  // ),
                  AppButton(
                    textStyle: TextStyle(color: appBackGroundColor),
                    onTap:onCancel,
                    child: Text('Cancel'),
                  ),
                  5.width,
                  AppButton(
                    color: appBackGroundColor,
                    onTap: onConfirm,
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
