import 'package:apps/utils/library.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../controllers/translation_memory_controller.dart';
import '../model/translation_model.dart';
import '../model/transalted_model.dart';

class TranslationMemoryView extends StatelessWidget {
  final TranslationMemoryController TranslationController =
      Get.put(TranslationMemoryController());

  // Store the selected file locally
  // var selectedTranslationReport = Rx<TranslationWork?>(null)

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        // isLoading: controller.isLoading,
        appBarBackgroundColor: appBackGroundColor,
        appBarTitleText: "Translation Memory",
        appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
        body: Container(
          color: appBackGroundColor,
          child: Column(
            children: [
              Obx(() {
                if (TranslationController.filteredFiles.isEmpty) {
                  return Text("No items available");
                }
                final item = TranslationController.filteredFiles.first;
                return Card(
                  color: appDashBoardCardColor,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text('1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.en.toString()),
                        Text(item.name.toString()),
                      ],
                    ),
                    trailing:
                        Text("Score\nbcbjsbc", textAlign: TextAlign.center),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
