import 'dart:convert';
import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../../utils/shared_prefences.dart';
import '../model/reconAI_model.dart';

class ReconAIController extends BaseController {
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;
  RxList<File> targetImageFiles = <File>[].obs;
  RxList<File> metaImageFiles = <File>[].obs;
  RxList<String> targetFileNames = <String>[].obs;
  RxList<String> metaFileNames = <String>[].obs;
  var sourceDropdownValue = 'Upload File'.obs;
  var targetDropdownValue = 'Upload File'.obs;

  RxnString sourceCsv = RxnString();
  RxnString targetCsv = RxnString();
  RxnString metadataCsv = RxnString();

  // bool get isReadyToReconcile => sourceCsv.value != null && targetCsv.value != null && metadataCsv.value != null;
  var isReadyToReconcile = false.obs;

  void checkIfReady() {
    isReadyToReconcile.value =
        sourceCsv.value != null &&
            targetCsv.value != null &&
            metadataCsv.value != null;
  }
  final Map<File, String> fileContents = {};
  final Map<File, String> targetFileContents = {};
  final Map<File, String> metaDataFileContents = {};

  @override
  void onInit() {
    super.onInit();
  }

  // void onSourceSelected(File file) async {
  //   final fileName = file.path.split('/').last;
  //   final ext = fileName.split('.').last.toLowerCase();
  //
  //   String? content;
  //
  //   try {
  //     if (['txt', 'csv', 'json'].contains(ext)) {
  //       content = await file.readAsString();
  //     } else if (['xlsx', 'xls'].contains(ext)) {
  //       content = await decodeExcel(file);
  //     } else {
  //       toast('Unsupported file format');
  //       return;
  //     }
  //   } catch (e) {
  //     toast('Error decoding file: $e');
  //     return;
  //   }
  //
  //   // Ask user what kind of file it is
  //   Get.defaultDialog(
  //     title: 'Assign File',
  //     content: Column(
  //       children: [
  //         ElevatedButton(
  //           onPressed: () {
  //             sourceCsv?.value = content!;
  //             fileNames.add('Source: $fileName');
  //             imageFiles.add(file);
  //             Get.back();
  //           },
  //           child: Text('Set as Source'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             targetCsv?.value = content!;
  //             fileNames.add('Target: $fileName');
  //             imageFiles.add(file);
  //             Get.back();
  //           },
  //           child: Text('Set as Target'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             metadataCsv?.value = content!;
  //             fileNames.add('Metadata: $fileName');
  //             imageFiles.add(file);
  //             Get.back();
  //           },
  //           child: Text('Set as Metadata'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Future<String> decodeExcel(File file) async {
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    StringBuffer buffer = StringBuffer();

    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;
      for (var row in rows) {
        buffer.writeln(row.map((cell) => cell?.value.toString() ?? '').join(','));
      }
      break;
    }

    return buffer.toString();
  }

  void onSourceSelected(File file) async {
    final fileName = file.path.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();

    String? content;

    try {
      if (['txt', 'csv', 'json'].contains(ext)) {
        content = await file.readAsString();
      } else if (['xlsx', 'xls'].contains(ext)) {
        content = await decodeExcel(file);
      } else {
        toast('Unsupported file format: .$ext');
        return;
      }
    } catch (e) {
      toast('Error decoding file: $e');
      return;
    }

    if (fileNames.contains(fileName)) {
      toast("File '$fileName' already selected.");
      return;
    }

    final confirmed = await Get.bottomSheet<bool>(
      AppDialogueComponent(
        titleText: "Do you want to upload this attachment?",
        confirmText: "Upload",
        onConfirm: () {},
      ),
      isScrollControlled: true,
    );
    print("content-------------------$content");
    if (confirmed == true) {
      fileNames.clear();
      imageFiles.clear();
      fileContents.clear();
      sourceCsv.value = "";
      print('---------------------1-----------------------');
      imageFiles.add(file);
      fileNames.add(fileName);
      targetFileContents[file] = content;
      sourceCsv.value = content;
      checkIfReady();
    }
  }

  void onTargetSourceSelected(File file) async {
    final fileName = file.path.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();

    String? content;

    try {
      if (['txt', 'csv', 'json'].contains(ext)) {
        content = await file.readAsString();
      } else if (['xlsx', 'xls'].contains(ext)) {
        content = await decodeExcel(file);
      } else {
        toast('Unsupported file format: .$ext');
        return;
      }
    } catch (e) {
      toast('Error decoding file: $e');
      return;
    }

    if (targetFileNames.contains(fileName)) {
      toast("File '$fileName' already selected.");
      return;
    }

    final confirmed = await Get.bottomSheet<bool>(
      AppDialogueComponent(
        titleText: "Do you want to upload this attachment?",
        confirmText: "Upload",
        onConfirm: () {},
      ),
      isScrollControlled: true,
    );
    print("content-------------------$content");
    if (confirmed == true) {
      targetFileNames.clear();
      targetImageFiles.clear();
      targetFileContents.clear();
      targetCsv.value = "";
      print('---------------------1-----------------------');
      targetImageFiles.add(file);
      targetFileNames.add(fileName);
      targetFileContents[file] = content;
      targetCsv.value = content;
      checkIfReady();
    }
  }

  void onMetaSourceSelected(File file) async {
    final fileName = file.path.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();

    String? content;

    try {
      if (['txt', 'csv', 'json'].contains(ext)) {
        content = await file.readAsString();
      } else if (['xlsx', 'xls'].contains(ext)) {
        content = await decodeExcel(file);
      } else {
        toast('Unsupported file format: .$ext');
        return;
      }
    } catch (e) {
      toast('Error decoding file: $e');
      return;
    }

    if (metaFileNames.contains(fileName)) {
      toast("File '$fileName' already selected.");
      return;
    }

    final confirmed = await Get.bottomSheet<bool>(
      AppDialogueComponent(
        titleText: "Do you want to upload this attachment?",
        confirmText: "Upload",
        onConfirm: () {},
      ),
      isScrollControlled: true,
    );
    print("content-------------------$content");
    if (confirmed == true) {
      metaFileNames.clear();
      metaImageFiles.clear();
      metaDataFileContents.clear();
      metadataCsv.value = "";
      print('---------------------1-----------------------');
      metaImageFiles.add(file);
      metaFileNames.add(fileName);
      metaDataFileContents[file] = content;
      metadataCsv.value = content;
      checkIfReady();
    }
  }

  // void onTargetSourceSelected(dynamic imageSource) async {
  //   if (imageSource is File) {
  //     String fileName = imageSource.path
  //         .split('/')
  //         .last;
  //     bool isDuplicate = targetFileNames.contains(fileName);
  //
  //     if (isDuplicate) {
  //       toast("File already added");
  //       return;
  //     }
  //
  //     Get.bottomSheet(
  //       AppDialogueComponent(
  //         titleText: "Do you want to upload this attachment?",
  //         confirmText: "Upload",
  //         onConfirm: () {
  //           targetImageFiles.add(imageSource);
  //           targetFileNames.add(fileName);
  //         },
  //       ),
  //       isScrollControlled: true,
  //     );
  //   }
  // }

  // void onMetaSourceSelected(dynamic imageSource) async {
  //   if (imageSource is File) {
  //     String fileName = imageSource.path
  //         .split('/')
  //         .last;
  //     bool isDuplicate = metaFileNames.contains(fileName);
  //
  //     if (isDuplicate) {
  //       toast("File already added");
  //       return;
  //     }
  //
  //     Get.bottomSheet(
  //       AppDialogueComponent(
  //         titleText: "Do you want to upload this attachment?",
  //         confirmText: "Upload",
  //         onConfirm: () {
  //           metaImageFiles.add(imageSource);
  //           metaFileNames.add(fileName);
  //         },
  //       ),
  //       isScrollControlled: true,
  //     );
  //   }
  // }

//   Future<void> reconReconciliation(
//       {required String useName, required String sourceCSV,required String targetCSV,required String metadataCSV}) async {
//     try {
//       isLoading.value = true;
//       String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);
//       String Fullname = '';
//       if (userJson.isNotEmpty) {
//         var userMap = jsonDecode(userJson);
//         var userModel = UserModel.fromJson(userMap);
//         Fullname = "${userModel.firstName} ${userModel.lastName}";
//       }
//       final request = {
//         "user_name": Fullname,
//         "source_csv": sourceCsv.value.toString(),
//         "target_csv": targetCsv.value.toString(),
//         "metadata_csv": metadataCsv.value.toString(),
//       };
// print("Request-------------------------------$request");
//       final response = await ReconServiceApi.reconReconciliation(request: request);
//       final reconData = ReconRes.fromJson(response);
//
//       // Show bottom sheet popup with response messages
//       Get.bottomSheet(
//         ReconciliationPopup(messages: reconData.response),
//         isScrollControlled: true,
//       );
//     } catch (e) {
//       print('Error fetching Additional Narrative: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

  Future<void> reconReconciliation({
    required String sourceCSV,
    required String targetCSV,
    required String metadataCSV,
  }) async {
    try {
      isLoading.value = true;

      // Fetch user data
      String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);
      String fullName = '';
      if (userJson.isNotEmpty) {
        var userMap = jsonDecode(userJson);
        var userModel = UserModel.fromJson(userMap);
        fullName = "${userModel.firstName} ${userModel.lastName}";
      }

      final request = {
        "user_name": fullName,
        "source_csv": sourceCSV,
        "target_csv": targetCSV,
        "metadata_csv": metadataCSV,
      };

      print("Request-------------------------------$request");

      // Assuming this returns a ReconRes object already
      final ReconRes reconData = await ReconServiceApi.reconReconciliation(request: request);

      // Show bottom sheet
      Future.delayed(Duration.zero, () {
        Get.bottomSheet(
          ReconciliationPopup(messages: reconData.response),
          isScrollControlled: true,
        );
      });
    } catch (e, stackTrace) {
      print('Error in reconciliation: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }
}

class ReconciliationPopup extends StatelessWidget {
  final List<Message> messages;

  ReconciliationPopup({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appWhiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reconciliation Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close))
              ],
            ),
            SizedBox(height: 16),
            ...messages.map((message) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(margin: EdgeInsets.all(2),color: appDashBoardCardColor, child: Text(message.message).paddingAll(8)),
                )),
          ],
        ),
      ),
    );
  }
}
