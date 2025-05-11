import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/component/app_dialogue_component.dart';
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

  // RxString selectedFileName = ''.obs;
  // RxString selectedTargetFileName = ''.obs;
  // Handle source selection for image upload
  // void onSourceSelected(dynamic  imageSource) async {
  //   final pickedFile = await pickFilesFromDevice(allowMultipleFiles: true);
  //   log("pickedFile-----------------$pickedFile");
  //   if (pickedFile.isNotEmpty) {
  //     Get.bottomSheet(
  //       AppDialogueComponent(
  //         titleText: "Do you want to upload this attachment?",
  //         confirmText: "Upload",
  //         onConfirm: () {
  //           imageFiles.addAll(pickedFile);
  //           fileNames.addAll(pickedFile.map((e) => e.path.split('/').last));
  //           selectedFileName.value = pickedFile.first.path.split('/').last;
  //           print("Selected File: -----------------${selectedFileName.value}");
  //         },
  //       ),
  //       isScrollControlled: true,
  //     );
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
  }
  // Future<void> reconReconciliation({required String query, required String SafetyReport, required List<String> checkbox, required String narrative}) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final request = {
  //       {
  //         "user_name": "Sandesh Singhal",
  //         "source_csv": "patientid,name,age,gender\n1,Aqlice,30,F\n2,Bob,25,M\n3,Charlie,40,M",
  //         "target_csv": "patientid,name,age\n1,Alice,31\n2,Bob,25\n4,Daisy,22",
  //         "metadata_csv": "source_column,target_column,relationship\npatientid,patientid,primary key\nname,name,\nage,age,"
  //       }
  //     };
  //
  //     final response = await ReconServiceApi.reconReconciliation(request: request);
  //     // ReconRes.value = response;
  //   } catch (e) {
  //     print('Error fetching Additional Narrative: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<String> readExcelAsString() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final bytes = File(result.files.single.path!).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      final buffer = StringBuffer();
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          buffer.writeln(row.map((cell) => cell?.value ?? '').join('|'));

        }
      }

      return buffer.toString();
    }

    return '';
  }
  void onSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      String fileName = imageSource.path.split('/').last;

      if (fileNames.contains(fileName)) {
        toast("File '$fileName' already selected.");
        return;
      }

      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.add(imageSource);
            fileNames.add(fileName);
          },
        ),
        isScrollControlled: true,
      );
    }
  }

  void onTargetSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      String fileName = imageSource.path.split('/').last;
      bool isDuplicate = targetFileNames.contains(fileName);

      if (isDuplicate) {
        toast("File already added");
        return;
      }

      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            targetImageFiles.add(imageSource);
            targetFileNames.add(fileName);
          },
        ),
        isScrollControlled: true,
      );
    }
  }

  void onMetaSourceSelected(dynamic imageSource) async {
    if (imageSource is File) {
      String fileName = imageSource.path.split('/').last;
      bool isDuplicate = metaFileNames.contains(fileName);

      if (isDuplicate) {
        toast("File already added");
        return;
      }

      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            metaImageFiles.add(imageSource);
            metaFileNames.add(fileName);
          },
        ),
        isScrollControlled: true,
      );
    }
  }
}
