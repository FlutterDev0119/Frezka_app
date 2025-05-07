import 'dart:io';

import 'package:apps/modules/translation_memory/model/translation_model.dart';
import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';

class ReconAIController extends BaseController {
  RxList<File> imageFiles = <File>[].obs;
  RxList<String> fileNames = <String>[].obs;
  var sourceDropdownValue = 'Upload File'.obs;
  var targetDropdownValue = 'Upload File'.obs;
  RxString selectedFileName = ''.obs;
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
      // ✅ Use the file passed from the UI
      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.add(imageSource);
            fileNames.add(imageSource.path.split('/').last);
            selectedFileName.value = imageSource.path.split('/').last;
            print("Selected File: -----------------${selectedFileName.value}");
          },
        ),
        isScrollControlled: true,
      );
    // } else if (imageSource is ImageSource) {
    //   // Optional: if you want to support gallery/camera later
    //   final pickedFile = await pickImageFromSource(imageSource);
    //   if (pickedFile != null) {
    //     imageFiles.add(pickedFile);
    //     fileNames.add(pickedFile.path.split('/').last);
    //     selectedFileName.value = pickedFile.path.split('/').last;
    //   }
    }
  }


}
