import 'package:apps/utils/library.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../controllers/translation_memory_controller.dart';
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
      body: Container(
        color: AppColors.appBackground,
        child: Column(
          children: [
            _buildHeaderRow(context),
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
            Expanded(
              child: Obx(() {
                return ListView.builder(
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
                    return _buildListItem(item, index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Header Row
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

  // Single Header Button
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
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showSearchIcon) ...[
              const SizedBox(width: 4),
              const Icon(Icons.search, size: 18),
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
  Widget _buildListItem(TranslationMemory item, int index) {
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
              color: appDashBoardCardColor,
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _editItem(item, index);
                } else if (value == 'remove') {
                  controller.deleteTranslation(item.id).then(
                    (value) async {
                      await controller.fetchData();
                    },
                  );
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
                  await controller.fetchData();
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
}
