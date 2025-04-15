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
            color: isSelected ? appDashBoardCardColor : Colors.white,
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
          _headerButton("Language", SortColumn.language),
          _headerButton("Original", SortColumn.originalCount),
          _headerButton("Translated", SortColumn.translatedCount),
          _headerButton("Score", SortColumn.score),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "MetaPhrase Pv",
      body: Obx(() {
        return Column(
          children: [
            _buildHeaderRow(),
            // List View
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredFiles.length,
                itemBuilder: (_, index) {
                  final item = controller.filteredFiles[index];
                  return Card(
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
                          Text("Language: ${item.language}"),
                          Text("Original: ${item.originalCount} → Translated: ${item.translatedCount}"),
                        ],
                      ),
                      trailing: Text("Score\n${item.score}", textAlign: TextAlign.center),
                      onTap: () {}, //   => Get.to(() => DetailScreen(file: item)),
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
