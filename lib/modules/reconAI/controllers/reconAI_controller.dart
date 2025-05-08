import 'dart:io';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/component/app_dialogue_component.dart';

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
