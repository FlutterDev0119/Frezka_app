import 'dart:convert';

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
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
    String userJson = getStringAsync(AppSharedPreferenceKeys.userModel);

// Decode and convert to UserModel
    UserModel user = UserModel.fromJson(jsonDecode(userJson));

// Access the fields
    String? firstName = user.firstName;
    String? lastName = user.lastName;
    String? email = user.email;
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
                child: Icon(Icons.arrow_circle_up_rounded, color: appBackGroundColor),
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

                      if (label == mode) return appBackGroundColor;
                      if (labelIndex < currentIndex) return appGreenColor;

                      return appMetaButtonColor;
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
                                      Icon(getIcon(label),
                                          color: controller.modes.indexOf(label) == controller.modes.indexOf(mode) ? appWhiteColor : appTextColor),
                                      const SizedBox(height: 4),
                                      Marquee(
                                        child: Text(
                                          maxLines: 1,
                                          label,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: controller.modes.indexOf(label) == controller.modes.indexOf(mode) ? appWhiteColor : appTextColor,
                                              fontWeight: FontWeight.bold),
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

                  controller.isCredentialsConfirm.value == false
                      ? Column(
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
                                                    controller.isScoreHighlightMode.value = !controller.isScoreHighlightMode.value;
                                                    controller.selectedTranslationReport.value = controller.selectedTranslationReport.value;
                                                  },
                                                )
                                              : SizedBox(),
                                          controller.selectedMode.value == "Edit" && controller.isReverse.value == false
                                              ? IconButton(
                                                  iconSize: 20,
                                                  visualDensity: VisualDensity.compact,
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(Icons.screenshot_monitor_sharp),
                                                  onPressed: () {},
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
                                            Obx(() {
                                              final isScoreHighlight = controller.isScoreHighlightMode.value;

                                              // Check if we need to show the scored sentences
                                              if (isScoreHighlight) {
                                                final scoredTexts = controller.selectedTranslationReport.value?.sentenceScore ?? [];

                                                if (scoredTexts.isEmpty) {
                                                  return Center(child: Text("No sentences available"));
                                                }

                                                return Wrap(
                                                  spacing: 4,
                                                  runSpacing: 4,
                                                  alignment: WrapAlignment.start,
                                                  children: scoredTexts.map<Widget>((sentenceScore) {
                                                    final sentence = sentenceScore.sentence;
                                                    final score = sentenceScore.score;

                                                    // Color color = score <= 50 ? Colors.yellow : Colors.green;
                                                    Color color;

                                                    if (score >= 0 && score <= 39) {
                                                      color = appScore0To39Color;
                                                    } else if (score >= 40 && score <= 64) {
                                                      color = appScore40To64Color;
                                                    } else if (score >= 65 && score <= 100) {
                                                      color = appScore65To100Color;
                                                    } else {
                                                      color = appGreyColor;
                                                    }

                                                    return Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                      color: color,
                                                      child: Text(
                                                        sentence,
                                                        style: TextStyle(fontSize: 16, color: appTextColor),
                                                      ),
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
                        )
                      : Center(
                          child: Container(
                            width: 600,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Certificate of Translation',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: appBackGroundColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black, // Or your theme color
                                      ),
                                      children: [
                                        const TextSpan(text: 'I, '),
                                        TextSpan(text: firstName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const TextSpan(text: ', certify that I am competent to translate between English and '),
                                        const TextSpan(text: 'Japanese (ja)', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const TextSpan(text: '. I further certify that I translated the document titled '),
                                         TextSpan(text: '"$fileName"', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const TextSpan(text: ', and the translation is true and accurate to the best of my abilities.'),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                                const Divider(thickness: 1),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text('Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text('Phone Number:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Marquee(child: Text(firstName.toString())),
                                          SizedBox(height: 8),
                                          Marquee(child: Text(email.toString())),
                                          SizedBox(height: 8),
                                          Text('123456789'),
                                          SizedBox(height: 8),
                                          Text('India'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      log("--------------");
                                      await generateAndDownloadCertificate(firstName!,email!,fileName);
                                    },
                                    icon: const Icon(Icons.download,color: appWhiteColor,),
                                    label: const Text('Download'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:appBackGroundColor,
                                      foregroundColor: appWhiteColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  /// Dropdown styled like a button
                  Obx(() {
                    final selected = controller.selectedMode.value;
                    final certifyOptions = ['Finalize', 'Return', 'Reject'];
                    if (selected == 'Peer Review' && controller.isEditing.value == true && controller.hasShownPeerReviewDialog.isFalse) {
                      Future.delayed(Duration.zero, () {
                        showPeerReviewDialog(context);
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
                             controller.isCredentialsConfirm.value ? 
                             Container(
                    width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: appBackGroundColor,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () async {
                                final RenderBox button = context.findRenderObject() as RenderBox;
                                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                final RelativeRect position = RelativeRect.fromRect(
                                  Rect.fromPoints(
                                    button.localToGlobal(Offset.zero, ancestor: overlay),
                                    button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                  ),
                                  Offset.zero & overlay.size,
                                );

                                final List<PopupMenuEntry<String>> items = [];
                                for (int i = 0; i < controller.modes.length; i++) {
                                  final value = controller.modes[i];
                                  final isPeerReview = value == 'Peer Review';
                                  final isDisabled =
                                  ((controller.selected.value == 'Review' || controller.selected.value == 'Edit') && isPeerReview && !controller.isEditing.value);

                                  items.add(
                                    PopupMenuItem<String>(
                                      enabled: !isDisabled,
                                      value: value,
                                      height: 40,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: isDisabled ? appWhiteColor.withOpacity(0.5) : appWhiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );

                                  if (i != controller.modes.length - 1) {
                                    items.add(const PopupMenuDivider(height: 1));
                                  }
                                }
                                final isCertify = controller.selected.value == 'Certify';

                                final selected = await showMenu<String>(
                                  context: context,
                                  position: position,
                                  color: appBackGroundColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  items: isCertify
                                      ? certifyOptions.map((option) {
                                    return PopupMenuItem<String>(
                                      value: option,
                                      child: InkWell(
                                          onTap: () {
                                            if (option == "Finalize") {
                                              Get.back();
                                              showCredentialsDialog(context, controller);
                                              controller.isReturnSelected.value = false;
                                              controller.isRejectSelected.value = false;
                                            } else if (option == "Return") {
                                              Get.back();
                                              log("-----------------Return------------------");
                                              controller.isReturnSelected.value = true;
                                              controller.isRejectSelected.value = false;
                                            } else if (option == "Reject") {
                                              Get.back();
                                              log("-----------------Reject------------------");
                                              controller.isRejectSelected.value = true;
                                              controller.isReturnSelected.value = false;
                                            }
                                            controller.updateSelectedMode("Certify");
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0), // Equal space above and below
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Icon(
                                                            option == "Return"
                                                                ? Icons.keyboard_return
                                                                : option == "Reject"
                                                                ? Icons.close
                                                                : Icons.check_circle_outline,
                                                            color: appWhiteColor,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Text(
                                                            option,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: appWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (option != "Reject")
                                                      const Padding(
                                                        padding: EdgeInsets.only(top: 2.0),
                                                        child: Divider(
                                                          color: Colors.white54,
                                                          thickness: 1,
                                                          height: 1,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }).toList()
                                      : _buildModeOptionsWithDividers(controller),
                                );

                                if (selected != null) {
                                  controller.updateSelectedMode(selected);
                                  if (selected == 'Edit') controller.isReverse.value = false;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: appWhiteColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => Text(
                                      controller.selected.value,
                                      style: const TextStyle(color: appWhiteColor, fontSize: 16),
                                    )),
                                    const Icon(Icons.arrow_drop_down, color: appWhiteColor),
                                  ],
                                ),
                              ),
                            );
                          },
                        )): Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: appBackGroundColor,
                                      border: Border.all(color: Colors.grey.shade400),
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final RenderBox button = context.findRenderObject() as RenderBox;
                                            final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                            final RelativeRect position = RelativeRect.fromRect(
                                              Rect.fromPoints(
                                                button.localToGlobal(Offset.zero, ancestor: overlay),
                                                button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                              ),
                                              Offset.zero & overlay.size,
                                            );

                                            final List<PopupMenuEntry<String>> items = [];
                                            for (int i = 0; i < controller.modes.length; i++) {
                                              final value = controller.modes[i];
                                              final isPeerReview = value == 'Peer Review';
                                              final isDisabled =
                                                  ((controller.selected.value == 'Review' || controller.selected.value == 'Edit') && isPeerReview && !controller.isEditing.value);

                                              items.add(
                                                PopupMenuItem<String>(
                                                  enabled: !isDisabled,
                                                  value: value,
                                                  height: 40,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      color: isDisabled ? appWhiteColor.withOpacity(0.5) : appWhiteColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              );

                                              if (i != controller.modes.length - 1) {
                                                items.add(const PopupMenuDivider(height: 1));
                                              }
                                            }

                                            // final selected = await showMenu<String>(
                                            //   context: context,
                                            //   position: position,
                                            //   color: appBackGroundColor,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.circular(12),
                                            //   ),
                                            //   items: items,
                                            // );
                                            final isCertify = controller.selected.value == 'Certify';

                                            final selected = await showMenu<String>(
                                              context: context,
                                              position: position,
                                              color: appBackGroundColor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              items: isCertify
                                                  ? certifyOptions.map((option) {
                                                      return PopupMenuItem<String>(
                                                        value: option,
                                                        child: InkWell(
                                                            onTap: () {
                                                              if (option == "Finalize") {
                                                                Get.back();
                                                                showCredentialsDialog(context, controller);
                                                                controller.isReturnSelected.value = false;
                                                                controller.isRejectSelected.value = false;
                                                              } else if (option == "Return") {
                                                                Get.back();
                                                                log("-----------------Return------------------");
                                                                controller.isReturnSelected.value = true;
                                                                controller.isRejectSelected.value = false;
                                                              } else if (option == "Reject") {
                                                                Get.back();
                                                                log("-----------------Reject------------------");
                                                                controller.isRejectSelected.value = true;
                                                                controller.isReturnSelected.value = false;
                                                              }
                                                              controller.updateSelectedMode("Certify");
                                                            },
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Equal space above and below
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(bottom: 10),
                                                                            child: Icon(
                                                                              option == "Return"
                                                                                  ? Icons.keyboard_return
                                                                                  : option == "Reject"
                                                                                      ? Icons.close
                                                                                      : Icons.check_circle_outline,
                                                                              color: appWhiteColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(bottom: 10),
                                                                            child: Text(
                                                                              option,
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: appWhiteColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if (option != "Reject")
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(top: 2.0),
                                                                          child: Divider(
                                                                            color: Colors.white54,
                                                                            thickness: 1,
                                                                            height: 1,
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    }).toList()
                                                  : _buildModeOptionsWithDividers(controller),
                                              // : controller.modes.map((value) {
                                              //     final isPeerReview = value == 'Peer Review';
                                              //     final isDisabled =
                                              //         (controller.selected.value == 'Review' && isPeerReview && !controller.isEditing.value);
                                              //     for (int i = 0; i < controller.modes.length; i++) {
                                              //       final value = controller.modes[i];
                                              //       items.add(
                                              //         PopupMenuItem<String>(
                                              //           enabled: !isDisabled,
                                              //           value: value,
                                              //           child: Text(
                                              //             value,
                                              //             style: TextStyle(
                                              //               color: isDisabled ? appWhiteColor.withOpacity(0.5) : appWhiteColor,
                                              //               fontSize: 14,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       );
                                              //
                                              //       // Add divider after each item except the last one
                                              //       if (i < controller.modes.length - 1) {
                                              //         items.add(
                                              //           const PopupMenuDivider(
                                              //             height: 1,
                                              //           ),
                                              //         );
                                              //       }
                                              //     }
                                              //     return PopupMenuItem<String>(
                                              //       enabled: !isDisabled,
                                              //       value: value,
                                              //       child: Text(
                                              //         value,
                                              //         style: TextStyle(
                                              //           color: isDisabled ? appWhiteColor.withOpacity(0.5) : appWhiteColor,
                                              //           fontSize: 14,
                                              //         ),
                                              //       ),
                                              //     );
                                              //   }).toList(),
                                            );

                                                if (selected != null) {
                                                  controller.updateSelectedMode(selected);
                                                  if (selected == 'Edit') {
                                                    controller.selected.value = 'Edit';
                                                    controller.isReverse.value = false;
                                                    controller.isEditing.value = false;
                                                  }
                                                  if (selected == 'Review') {
                                                    controller.selected.value = 'Review';
                                                    controller.isReverse.value = false;
                                                    controller.isEditing.value = false;

                                                  }
                                                }
                                              },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                              // border: Border.all(color: appWhiteColor),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Obx(() => Text(
                                                      controller.selected.value,
                                                      style: const TextStyle(color: appWhiteColor, fontSize: 16),
                                                    )),
                                                const Icon(Icons.arrow_drop_down, color: appWhiteColor),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
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
                                    // child: Column(
                                    //   children: certifyOptions.map((option) {
                                    //     return InkWell(
                                    //       onTap: () {
                                    //         if (option == "Finalize") {
                                    //           showCredentialsDialog(
                                    //             context,
                                    //             () {
                                    //               Get.back();
                                    //             },
                                    //             () {
                                    //               Get.back();
                                    //             },
                                    //           );
                                    //           controller.isReturnSelected.value = false;
                                    //           controller.isRejectSelected.value = false;
                                    //         } else if (option == "Return") {
                                    //           controller.isReturnSelected.value = true;
                                    //           controller.isRejectSelected.value = false;
                                    //         } else if (option == "Reject") {
                                    //           controller.isRejectSelected.value = true;
                                    //           controller.isReturnSelected.value = false;
                                    //         }else{
                                    //           controller.updateSelectedMode("Certify");
                                    //         }
                                    //
                                    //         print("Selected: $option");
                                    //       },
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(
                                    //                 option == "Return"
                                    //                     ? Icons.keyboard_return
                                    //                     : option == "Reject"
                                    //                         ? Icons.close
                                    //                         : Icons.check_circle_outline,
                                    //                 color: Colors.blue),
                                    //             const SizedBox(width: 10),
                                    //             Text(
                                    //               option,
                                    //               style: const TextStyle(fontWeight: FontWeight.bold),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     );
                                    //   }).toList(),
                                    // ),
                                  ),
                                if (controller.isReturnSelected.value)
                                  Obx(() {
                                    if (controller.isReturnSelected.value) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 8, top: 5),
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
                                              child: const Text(
                                                'Submit',
                                                style: TextStyle(color: appWhiteColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                                if (controller.isRejectSelected.value)
                                  Obx(() {
                                    return Container(
                                      margin: EdgeInsets.only(right: 8, top: 5),
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
                                            child: const Text(
                                              'Submit',
                                              style: TextStyle(color: appWhiteColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
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

List<PopupMenuEntry<String>> _buildModeOptionsWithDividers(dynamic controller) {
  final List<PopupMenuEntry<String>> items = [];

  for (int i = 0; i < controller.modes.length; i++) {
    final value = controller.modes[i];
    final isPeerReview = value == 'Peer Review';
    final isDisabled = ((controller.selected.value == 'Review' || controller.selected.value == 'Edit') && isPeerReview && !controller.isEditing.value);

    items.add(
      PopupMenuItem<String>(
        enabled: !isDisabled,
        value: value,
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              color: isDisabled ? appWhiteColor.withOpacity(0.5) : appWhiteColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );

    if (i < controller.modes.length - 1) {
      items.add(const PopupMenuDivider(height: 1));
    }
  }

  return items;
}

void showPeerReviewDialog(BuildContext context) {
  final MetaPhraseController controller = Get.put(MetaPhraseController());
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                    textStyle: TextStyle(color: appBackGroundColor),
                    onTap: () {
                      Get.back();
                      log('-----------------cancel------------------');
                      controller.isEditing.value = false;
                      // controller.hasShownPeerReviewDialog.value = false;
                    },
                    child: Text('Cancel'),
                  ),
                  AppButton(
                    color: appBackGroundColor,
                    onTap: () {
                      // Confirm action
                      Get.back();
                      log('-----------------confirm------------------');
                      controller.selected.value = "Certify";
                      controller.hasShownPeerReviewDialog.value = true;
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
void showCredentialsDialog(BuildContext context, controller) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

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
              const Text(
                "Credentials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field with visibility toggle
              ValueListenableBuilder<bool>(
                valueListenable: obscurePassword,
                builder: (context, isObscure, child) {
                  return TextField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      border: const OutlineInputBorder(),
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
              const SizedBox(height: 8),

              // Error message display
              ValueListenableBuilder<String?>(
                valueListenable: errorMessage,
                builder: (context, message, child) {
                  if (message == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    textStyle: const TextStyle(color: Colors.white),
                    onTap: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    color: appBackGroundColor,
                    onTap: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        errorMessage.value = "Please enter both email and password.";
                      } else {
                        errorMessage.value = null;
                        controller.isCredentialsConfirm.value = true;
                        Get.back();
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
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

// void showCredentialsDialog(BuildContext context, controller) {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
//   String storedEmail = getStringAsync(AppSharedPreferenceKeys.userEmail);
//   String storedPass = getStringAsync(ConstantKeys.passwordKey);
//   emailController.text = storedEmail.toString();
//   passwordController.text = storedPass.toString();
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Credentials",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Email Field
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   hintText: "Enter your email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Password Field with visibility toggle
//               ValueListenableBuilder<bool>(
//                 valueListenable: obscurePassword,
//                 builder: (context, isObscure, child) {
//                   return TextField(
//                     controller: passwordController,
//                     obscureText: isObscure,
//                     decoration: InputDecoration(
//                       hintText: "Enter your password",
//                       border: OutlineInputBorder(),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           isObscure ? Icons.visibility_off : Icons.visibility,
//                         ),
//                         onPressed: () {
//                           obscurePassword.value = !obscurePassword.value;
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 24),
//
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   AppButton(
//                     textStyle: TextStyle(color: appBackGroundColor),
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Text('Cancel'),
//                   ),
//                   5.width,
//                   AppButton(
//                     color: appBackGroundColor,
//                     onTap: () {
//                       if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
//                         controller.isCredentialsConfirm.value = true;
//                       }else{
//                         toast("fill");
//                       }
//                     }, //onConfirm,
//                     child: Text(
//                       'Confirm',
//                       style: TextStyle(color: white),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }


Future<void> generateAndDownloadCertificate(String firstName,String email,String fileName) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Certificate of Translation',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'I, $firstName, certify that I am competent to translate between English and Japanese (ja). '
                    'I further certify that I translated the document titled "$fileName", and the translation is true '
                    'and accurate to the best of my abilities.',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text('Signature:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text('Phone Number:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text('Address:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(firstName.toString()),
                      pw.SizedBox(height: 8),
                      pw.Text(email.toString()),
                      pw.SizedBox(height: 8),
                      pw.Text('123456789'),
                      pw.SizedBox(height: 8),
                      pw.Text('India'),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  // Permissions (Only needed for Android)
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission denied');
      return;
    }
  }

  final outputDir = await getApplicationDocumentsDirectory();
  final filePath = "${outputDir.path}/certificate.pdf";
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  OpenFile.open(filePath); // Optional: open after save
}
