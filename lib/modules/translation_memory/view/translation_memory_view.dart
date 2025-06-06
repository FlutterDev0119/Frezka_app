import 'package:apps/modules/translation_memory/model/ai_translation_memory_model.dart';
import 'package:apps/utils/library.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/constants.dart';
import '../../../utils/shared_prefences.dart';
import '../controllers/translation_memory_controller.dart';
import '../model/staging_translation_memory.dart';
import '../model/translation_model.dart';

// View
class TranslationMemoryScreen extends StatelessWidget {
  final TranslationMemoryController controller = Get.put(TranslationMemoryController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      automaticallyImplyLeading: true,
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Translation Memory",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.appBackground,
          child: Obx(() {
            return Column(
              children: [
                Center(
                  child: Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: appDashBoardCardColor,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(8),
                            value: controller.selectedOption.value,
                            dropdownColor: appDashBoardCardColor,
                            items: controller.options.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: boldTextStyle(color: appBackGroundColor),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) controller.setSelected(value);
                            },
                          ),
                        ),
                      )),
                ),

                ///-----------------------------------------------------------------------------
                /// Staging data
                ///-----------------------------------------------------------------------------
                if (controller.selectedOption.value.toString() == "Pending Approval") _buildStagingHeaderRow(context),
                if (controller.selectedOption.value.toString() == "Pending Approval")
                  Obx(() {
                    return controller.showStagingSearchField.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: TextField(
                              controller: controller.searchStagingController,
                              onChanged: (value) => controller.searchStagingQuery.value = value,
                              style: TextStyle(color: appBackGroundColor),
                              decoration: InputDecoration(
                                hintText: controller.selectedStagingSearchField.isEmpty
                                    ? 'Search...'
                                    : 'Search by ${controller.selectedStagingSearchField.value}',
                                hintStyle: TextStyle(color: appBackGroundColor),
                                filled: true,
                                fillColor: appWhiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.search, color: appBackGroundColor),
                              ),
                            ),
                          )
                        : SizedBox();
                  }),
                if (controller.selectedOption.value.toString() == "Pending Approval")
                  Container(
                    height: 300,
                    child: Obx(() {
                      return controller.allStagingFiles.isEmpty ? Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: appBackGroundColor),
                        ),
                      ) : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: controller.filteredStagingFiles.length,
                        itemBuilder: (context, index) {

                          final item = controller.filteredStagingFiles[index];
                          return _buildStagingListItem(context, item, index);
                        },
                      );
                    }),
                  ),

                ///-----------------------------------------------------------------------------
                /// AI data
                ///-----------------------------------------------------------------------------
                if (controller.selectedOption.value.toString() == "AI Suggestions") _buildAIHeaderRow(context),
                if (controller.selectedOption.value.toString() == "AI Suggestions")
                  Obx(() {
                    return controller.showAISearchField.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: TextField(
                              controller: controller.searchAIController,
                              onChanged: (value) => controller.searchAIQuery.value = value,
                              style: TextStyle(color: appBackGroundColor),
                              decoration: InputDecoration(
                                hintText:
                                    controller.selectedAISearchField.isEmpty ? 'Search...' : 'Search by ${controller.selectedSearchField.value}',
                                hintStyle: TextStyle(color: appBackGroundColor),
                                filled: true,
                                fillColor: appWhiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(Icons.search, color: appBackGroundColor),
                              ),
                            ),
                          )
                        : SizedBox();
                  }),
                if (controller.selectedOption.value.toString() == "AI Suggestions")
                  Obx(() {
                    return Container(
                      height: 300,
                      child: controller.filteredAIFiles.isEmpty ? Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: appBackGroundColor),
                        ),
                      ) : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: controller.filteredAIFiles.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredAIFiles[index];
                          return _buildAIListItem(context, item, index);
                        },
                      ),
                    );
                  }),

                ///-----------------------------------------------------------------------------
                /// Fetch data
                ///-----------------------------------------------------------------------------

                // if (controller.selectedOption.value.toString() == "Pending Approval")
                Text(
                  "Approved Translations",
                  style: boldTextStyle(color: appBackGroundColor, size: 18),
                ).paddingOnly(top: 20),
                // if (controller.selectedOption.value.toString() == "Pending Approval")
                _buildHeaderRow(context),
                // if (controller.selectedOption.value.toString() == "Pending Approval")
                Obx(() {
                  return controller.showSearchField.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (value) => controller.searchQuery.value = value,
                            style: TextStyle(color: appBackGroundColor),
                            decoration: InputDecoration(
                              hintText: controller.selectedSearchField.isEmpty ? 'Search...' : 'Search by ${controller.selectedSearchField.value}',
                              hintStyle: TextStyle(color: appBackGroundColor),
                              filled: true,
                              fillColor: appWhiteColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.search, color: appBackGroundColor),
                            ),
                          ),
                        )
                      : SizedBox();
                }),
                // if (controller.selectedOption.value.toString() == "Pending Approval")
                Container(
                  height: 300,
                  child: Obx(() {
                    return controller.filteredFiles.isEmpty ? Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: appBackGroundColor),
                      ),
                    ) : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: controller.filteredFiles.length,
                      itemBuilder: (context, index) {
                        if (controller.allFiles.isEmpty) {
                          return Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(color: appWhiteColor),
                            ),
                          );
                        }
                        final item = controller.filteredFiles[index];
                        return _buildListItem(context,item, index);
                      },
                    );
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// Header Row
  Widget _buildHeaderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _headerButton("Language", SortColumn.language),
            _headerButton("Source Phrase", SortColumn.sourcePhrase),
            // _headerButton("Translation Edits", SortColumn.translationEdits),
            _headerButton("Approver", SortColumn.approver),
            // _headerButton("Actions", SortColumn.actions),
          ],
        ),
      ),
    );
  }

  ///Staging Header Row
  Widget _buildStagingHeaderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _headerStagingButton("Language", SortColumn.language),
            _headerStagingButton("Source Phrase", SortColumn.sourcePhrase),
            // _headerButton("Translation Edits", SortColumn.translationEdits),
            _headerStagingButton("Approver", SortColumn.approver),
            // _headerButton("Actions", SortColumn.actions),
          ],
        ),
      ),
    );
  }

  /// AI Row
  Widget _buildAIHeaderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _headerAIButton("Language", SortColumn.language),
            _headerAIButton("Source Phrase", SortColumn.sourcePhrase),
            // _headerButton("Translation Edits", SortColumn.translationEdits),
            _headerAIButton("Approver", SortColumn.approver),
            // _headerButton("Actions", SortColumn.actions),
          ],
        ),
      ),
    );
  }

  /// Single Header Button
  Widget _headerButton(String title, SortColumn column) {
    bool showSearchIcon = column == SortColumn.language || column == SortColumn.sourcePhrase || column == SortColumn.approver;

    bool noAction = column == SortColumn.translationEdits || column == SortColumn.actions;

    return InkWell(
      onTap: () {
        controller.searchController.clear();
        controller.searchQuery.value = '';

        if (noAction) {
          controller.showSearchField.value = false;
          controller.selectedSearchField.value = '';
          // controller.fetchData();
        } else {
          controller.showSearchField.value = true;
          controller.selectedSearchField.value = title;
          // controller.fetchData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: appBackGroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: appWhiteColor),
            ),
            if (showSearchIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.search, color: appWhiteColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  /// Staging Single Header Button
  Widget _headerStagingButton(String title, SortColumn column) {
    bool showSearchIcon = column == SortColumn.language || column == SortColumn.sourcePhrase || column == SortColumn.approver;

    bool noAction = column == SortColumn.translationEdits || column == SortColumn.actions;

    return InkWell(
      onTap: () {
        controller.searchStagingController.clear();
        controller.searchStagingQuery.value = '';

        if (noAction) {
          controller.showStagingSearchField.value = false;
          controller.selectedStagingSearchField.value = '';
          // controller.fetchData();
        } else {
          controller.showStagingSearchField.value = true;
          controller.selectedStagingSearchField.value = title;
          // controller.fetchData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: appBackGroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: appWhiteColor),
            ),
            if (showSearchIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.search, color: appWhiteColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  /// AI Single Header Button
  Widget _headerAIButton(String title, SortColumn column) {
    bool showSearchIcon = column == SortColumn.language || column == SortColumn.sourcePhrase || column == SortColumn.approver;

    bool noAction = column == SortColumn.translationEdits || column == SortColumn.actions;

    return InkWell(
      onTap: () {
        controller.searchAIController.clear();
        controller.searchAIQuery.value = '';

        if (noAction) {
          controller.showAISearchField.value = false;
          controller.selectedAISearchField.value = '';
          // controller.fetchData();
        } else {
          controller.showAISearchField.value = true;
          controller.selectedAISearchField.value = title;
          // controller.fetchData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: appBackGroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: appWhiteColor),
            ),
            if (showSearchIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.search, size: 18, color: appWhiteColor),
            ],
          ],
        ),
      ),
    );
  }

  // Widget _buildListItem(TranslationMemory item, int index) {
  //   return Card(
  //     color: appDashBoardCardColor,
  //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Stack(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Source: ${item.en}",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 "Language: ${item.lang.toUpperCase()}",
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 "Translation: ${item.es}",
  //                 style: const TextStyle(fontSize: 13, color: Colors.grey),
  //               ),
  //               const SizedBox(height: 2),
  //               Text(
  //                 "Name: ${item.name}",
  //                 style: const TextStyle(fontSize: 10, color: Colors.grey),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 4,
  //           right: 4,
  //           child: PopupMenuButton<String>(
  //             color: appDashBoardCardColor,
  //             icon: Container(margin: EdgeInsets.all(5),child: const Icon(Icons.more_vert)),
  //             onSelected: (value) {
  //               if (value == 'edit') {
  //                 _editItem(item, index);
  //               } else if (value == 'remove') {
  //                 controller.deleteTranslation(item.id);
  //               }
  //             },
  //             itemBuilder: (BuildContext context) => [
  //               const PopupMenuItem<String>(
  //                 value: 'edit',
  //                 child: Text(
  //                   'Edit',
  //                   style: TextStyle(
  //                       color: Colors.green,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12),
  //                 ),
  //               ),
  //               const PopupMenuItem<String>(
  //                 value: 'remove',
  //                 child: Text(
  //                   'Remove',
  //                   style: TextStyle(
  //                       color: Colors.red,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildListItem(BuildContext context,TranslationMemory item, int index) {
    return Card(
      color: appDashBoardCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 40, 12), // add right space for icon
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Source: ${item.en}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item.lang.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Language: ${item.lang.toUpperCase()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (item.es.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Translation: ${item.es}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
                if (item.name.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    "Name: ${item.name}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: appDashBoardCardColor,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _editItem(item, index);
                } else if (value == 'remove') {

                  showCredentialsTranslationDeleteDialog(context, item.id);

                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStagingListItem(BuildContext context, StagingTranslationRes item, int index) {
    return Card(
      color: appDashBoardCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 40, 12), // add right space for icon
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Source: ${item.en}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item.lang.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Language: ${item.lang.toUpperCase()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (item.es.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Translation: ${item.es}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
                if (item.name.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    "Name: ${item.name}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: appDashBoardCardColor,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'approve') {
                  showCredentialsStagingDialog(context, item.id, item.en, item.es);
                } else if (value == 'annotation') {
                  showDialog(
                    context: Get.context!,
                    builder: (_) => AlertDialog(
                      title: Text("Add Your Annotation here"),
                      content: TextField(
                        controller: controller.stagingCommentController,
                        decoration: InputDecoration(
                          hintText: "Enter annotation...",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      actions: [
                        AppButton(
                          textStyle: TextStyle(color: appBackGroundColor),
                          onTap: () => Get.back(),
                          child: Text("Close"),
                        ),
                        5.width,
                        AppButton(
                          color: appBackGroundColor,
                          onTap: () {
                            controller.saveAnnotation(controller.stagingCommentController.text,item.id);
                          },
                          child: Text(
                            "save",
                            style: TextStyle(color: white),
                          ),
                        ),
                      ],
                    ),
                  );
                  // controller.saveAnnotation(item.id);
                  //   .then(
                  // (value) async {
                  //   await controller.fetchStagingTranslationMemoryList();
                  // },
                  // );
                } else if (value == 'view annotation') {
                  controller.getAnnotation(item.id);
                } else if (value == 'reject') {

                  showCredentialsStagingDialogDeleteDialog(context, item.id);

                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'approve',
                  child: Text(
                    'Approve',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'annotation',
                  child: Text(
                    'Annotation',
                    style: TextStyle(color: appColorPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'view annotation',
                  child: Text(
                    'View Annotation',
                    style: TextStyle(color: appButtonColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'reject',
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIListItem(BuildContext context, AiTranslationMemoryRes item, int index) {
    return Card(
      color: appDashBoardCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 40, 12), // add right space for icon
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Source: ${item.en}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item.lang.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Language: ${item.lang.toUpperCase()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (item.es.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Translation: ${item.es}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
                if (item.name.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    "Name: ${item.name}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: appDashBoardCardColor,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'approve') {
                  showCredentialsAIDialog(context, item.en, item.es,item.id);
                } else if (value == 'annotation') {
                  showDialog(
                    context: Get.context!,
                    builder: (_) => AlertDialog(
                      title: Text("Add Your Annotation here"),
                      content: TextField(
                        controller: controller.aiCommentController,
                        decoration: InputDecoration(
                          hintText: "Enter annotation...",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      actions: [
                        AppButton(
                          textStyle: TextStyle(color: appBackGroundColor),
                          onTap: () {Get.back();controller.aiCommentController.clear();},
                          child: Text("Close"),
                        ),
                        5.width,
                        AppButton(
                          color: appBackGroundColor,
                          onTap: () async{
                            controller.saveAnnotation(controller.aiCommentController.text,item.id).then((value) async{
                              await controller.fetchAITranslationMemoryList();
                              Get.back();
                              controller.aiCommentController.clear();
                            },);
                          },
                          child: Text(
                            "save",
                            style: TextStyle(color: white),
                          ),
                        ),
                      ],
                    ),
                  );
                  // toast("approv");
                  // controller.deleteTranslation(item.id).then(
                  //   (value) async {
                  //     await controller.fetchStagingTranslationMemoryList();
                  //   },
                  // );
                } else if (value == 'view annotation') {
                  controller.getAnnotation(item.id);
                } else if (value == 'reject') {
                  showCredentialsAIDeleteDialog(context, item.id);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'approve',
                  child: Text(
                    'Approve',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'annotation',
                  child: Text(
                    'Annotation',
                    style: TextStyle(color: appColorPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'view annotation',
                  child: Text(
                    'View Annotation',
                    style: TextStyle(color: appButtonColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const PopupMenuDivider(
                  height: 0,
                ),
                const PopupMenuItem<String>(
                  value: 'reject',
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 4,
          //   right: 4,
          //   child: PopupMenuButton<String>(
          //     color: appDashBoardCardColor,
          //     icon: const Icon(Icons.more_vert),
          //     onSelected: (value) {
          //       if (value == 'edit') {
          //         // _editItem(item, index);
          //       } else if (value == 'remove') {
          //         // controller.deleteTranslation(item.id).then(
          //         //       (value) async {
          //         //     await controller.fetchData();
          //         //   },
          //         // );
          //       }
          //     },
          //     itemBuilder: (BuildContext context) => [
          //       const PopupMenuItem<String>(
          //         value: 'edit',
          //         child: Text(
          //           'Edit',
          //           style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
          //         ),
          //       ),
          //       const PopupMenuDivider(
          //         height: 0,
          //       ),
          //       const PopupMenuItem<String>(
          //         value: 'remove',
          //         child: Text(
          //           'Remove',
          //           style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void _editItem(TranslationMemory item, int index) {
    final sourceController = TextEditingController(text: item.en);
    final translationController = TextEditingController(text: item.es);

    Get.dialog(
      AlertDialog(
        backgroundColor: appDashBoardCardColor,
        title: Text(
          'Edit Translation',
          style: TextStyle(color: appBackGroundColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sourceController,
              decoration: InputDecoration(labelText: 'Source Phrase', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            TextField(
              controller: translationController,
              decoration: InputDecoration(labelText: 'Translation Edits', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close popup
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: appGreyColor.withOpacity(0.2)),
            child: Text(
              'Cancel',
              style: TextStyle(color: blackColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller
                  .updateTranslation(
                id: item.id ?? 0,
                en: sourceController.text,
                es: translationController.text,
              )
                  .then(
                (value) async {
                  await controller.fetchStagingTranslationMemoryList();
                },
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: appBackGroundColor),
            child: Text(
              'Save',
              style: TextStyle(color: appWhiteColor),
            ),
          ),
        ],
      ),
    );
  }
  void showCredentialsStagingDialogDeleteDialog(BuildContext context, int id) {
    final TranslationMemoryController controller = Get.put(TranslationMemoryController());
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
                  readOnly: true,
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
                        final loginPassword = getStringAsync(AppSharedPreferenceKeys.userPassword);
                        log(loginPassword);
                        if (email.isEmpty || password.isEmpty) {
                          errorMessage.value = "Please enter both email and password.";
                        } else if (password != loginPassword) {
                          errorMessage.value = "Incorrect password.";
                        } else {
                          errorMessage.value = null;
                          controller.deleteStagingTranslationMemory(id).then(
                                (value) async {
                              await controller.fetchStagingTranslationMemoryList();
                              Get.back();
                            },
                          );
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
  void showCredentialsTranslationDeleteDialog(BuildContext context, int id) {
    final TranslationMemoryController controller = Get.put(TranslationMemoryController());
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
                  readOnly: true,
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
                        final loginPassword = getStringAsync(AppSharedPreferenceKeys.userPassword);
                        log(loginPassword);
                        if (email.isEmpty || password.isEmpty) {
                          errorMessage.value = "Please enter both email and password.";
                        } else if (password != loginPassword) {
                          errorMessage.value = "Incorrect password.";
                        } else {
                          errorMessage.value = null;
                          controller.deleteTranslation(id).then(
                                (value) async {
                              await controller.fetchStagingTranslationMemoryList();
                              Get.back();
                            },
                          );
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
  void showCredentialsAIDeleteDialog(BuildContext context, int id) {
    final TranslationMemoryController controller = Get.put(TranslationMemoryController());
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
                  readOnly: true,
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
                        final loginPassword = getStringAsync(AppSharedPreferenceKeys.userPassword);
                        log(loginPassword);
                        if (email.isEmpty || password.isEmpty) {
                          errorMessage.value = "Please enter both email and password.";
                        } else if (password != loginPassword) {
                          errorMessage.value = "Incorrect password.";
                        } else {
                          errorMessage.value = null;
                          controller.deleteStagingTranslationMemory(id).then(
                                (value) async {
                              await controller.fetchStagingTranslationMemoryList();
                              Get.back();
                            },
                          );
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

  void showCredentialsStagingDialog(BuildContext context, int id, String es, String en) {
    final TranslationMemoryController controller = Get.put(TranslationMemoryController());
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
                  readOnly: true,
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
                        final loginPassword = getStringAsync(AppSharedPreferenceKeys.userPassword);
                        log(loginPassword);
                        if (email.isEmpty || password.isEmpty) {
                          errorMessage.value = "Please enter both email and password.";
                        } else if (password != loginPassword) {
                          errorMessage.value = "Incorrect password.";
                        } else {
                          errorMessage.value = null;
                          controller.updateStaging(id: id, en: es, es: en).then(
                            (value) async {
                              await controller.fetchStagingTranslationMemoryList();
                            },
                          );
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

  void showCredentialsAIDialog(BuildContext context, String es, String en,int id) {
    final TranslationMemoryController controller = Get.put(TranslationMemoryController());
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
                  readOnly: true,
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
                          controller.updateStaging(en: es, es: en,id:id).then(
                            (value) async {
                              await controller.fetchData();
                            },
                          );
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
}
