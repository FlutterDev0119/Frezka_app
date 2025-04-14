import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../controllers/meta_phrase_pv_controller.dart';

//
// class MyAgentScreen extends StatelessWidget {
//   final MyAgentController controller = Get.put(MyAgentController());
//
//   MyAgentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       isLoading: controller.isLoading,
//       appBarBackgroundColor: AppColors.primary,
//       appBarTitleText: "My Agent",
//       appBarTitleTextStyle: TextStyle(
//         fontSize: 20,
//         color: AppColors.whiteColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Agent Name Input Field
//             TextField(
//               decoration: appInputDecoration(
//                 context: context,
//                 labelText: "Enter Agent Name",
//                 labelStyle: TextStyle(
//                   color: AppColors.textColor,
//                   fontSize: 16,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             10.height,
//
//             // Selected Items Container
//             Container(
//               padding: const EdgeInsets.all(12),
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: AppColors.cardColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Stack(
//                 children: [
//                   // Wrap for Selected Items
//                   Obx(
//                     () => SingleChildScrollView(
//                       child: Wrap(
//                         spacing: 8.0,
//                         runSpacing: 8.0,
//                         children: controller.selectedItems
//                             .map(
//                               (item) => Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.appBackground,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                       color: AppColors.primary, width: 1),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       item,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.textColor,
//                                       ),
//                                     ),
//                                     4.width,
//                                     GestureDetector(
//                                       onTap: () => controller.removeItem(item),
//                                       child: const Icon(Icons.close,
//                                           color: AppColors.redColor, size: 18),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   ),
//
//                   // Share Button (Positioned Bottom-Right)
//                   Obx(
//                     () => Positioned(
//                       bottom: 8,
//                       right: 8,
//                       child: GestureDetector(
//                         onTap: controller.selectedItems.isNotEmpty
//                             ? () {
//                                 print("Sharing: ${controller.selectedItems}");
//                               }
//                             : null,
//                         child: Image.asset(
//                           Assets.iconsSend,
//                           width: 25,
//                           height: 25,
//                           color: controller.selectedItems.isNotEmpty
//                               ? AppColors.textColor
//                               : AppColors.greyColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             20.height,
//
//             // Expansion Tiles
//             Expanded(
//               child: ListView(
//                 children: [
//                   DropdownTile(
//                     title: "Pre-Configured Test Data",
//                     items: controller.dropdownItems,
//                     controller: controller,
//                   ),
//                   DropdownTile(
//                     title: "Ready To Use Agents",
//                     items: controller.agentItems,
//                     controller: controller,
//                   ),
//                   DropdownTile(
//                     title: "Additional Test Data 1",
//                     items: controller.additionalDropdown1,
//                     controller: controller,
//                   ),
//                   DropdownTile(
//                     title: "Additional Test Data 2",
//                     items: controller.additionalDropdown2,
//                     controller: controller,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class MetaPhraseScreen extends StatelessWidget {
//   final MetaPhraseController controller = Get.put(MetaPhraseController());
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBarBackgroundColor: AppColors.primary,
//       appBarTitleText: "MetaPhrase Pv",
//       appBarTitleTextStyle: TextStyle(fontSize: 20, color: AppColors.whiteColor),
//       body: Obx(() {
//         return Column(
//           children: [
//             _buildFilters(controller),
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: controller.filteredList.length,
//                 itemBuilder: (_, index) {
//                   final item = controller.filteredList[index];
//                   return GestureDetector(
//                     onTap: () {},//=> Get.to(() => DetailScreen(file: item)),
//                     child: Card(
//                       margin: EdgeInsets.only(bottom: 12),
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(item.id, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                             SizedBox(height: 4),
//                             Text("Language: ${item.language}"),
//                             Text("Original: ${item.originalCount} | Translated: ${item.translatedCount}"),
//                             Text("Score: ${item.score}", style: TextStyle(color: Colors.grey[700])),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildFilters(MetaPhraseController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Expanded(
//             child: DropdownButton<String>(
//               isExpanded: true,
//               hint: Text("Filter by Language"),
//               value: controller.selectedLanguage.value,
//               onChanged: (value) => controller.filterByLanguage(value),
//               items: controller.languages.map((lang) {
//                 return DropdownMenuItem(value: lang, child: Text(lang));
//               }).toList(),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.sort_by_alpha),
//             tooltip: "Sort by Score",
//             onPressed: controller.sortByScore,
//           ),
//         ],
//       ),
//     );
//   }
// }

class MetaPhraseScreen extends StatelessWidget {
  final MetaPhraseController controller = Get.put(MetaPhraseController());

  Icon _sortIcon(SortColumn col, SortColumn currentCol, bool ascending) {
    if (col != currentCol) return Icon(Icons.unfold_more, size: 16);
    return ascending ? Icon(Icons.arrow_upward, size: 16) : Icon(Icons.arrow_downward, size: 16);
  }

  Widget _headerButton(String title, SortColumn column) {
    return Expanded(
      child: Obx(() {
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
              color: isSelected ? Colors.blue[50] : Colors.white,
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
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitleText: "MetaPhrase Pv",
      body: Obx(() {
        return Column(
          children: [
            // Table Header Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey[100],
              child: Row(
                children: [
                  _headerButton("Identifier", SortColumn.id),
                  _headerButton("Language", SortColumn.language),
                  _headerButton("Original", SortColumn.originalCount),
                  _headerButton("Translated", SortColumn.translatedCount),
                  _headerButton("Score", SortColumn.score),
                ],
              ),
            ),

            // List View
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredFiles.length,
                itemBuilder: (_, index) {
                  final item = controller.filteredFiles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(item.id, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Language: ${item.language}"),
                          Text("Original: ${item.originalCount} → Translated: ${item.translatedCount}"),
                        ],
                      ),
                      trailing: Text("Score\n${item.score}", textAlign: TextAlign.center),
                      onTap: () {},//   => Get.to(() => DetailScreen(file: item)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
