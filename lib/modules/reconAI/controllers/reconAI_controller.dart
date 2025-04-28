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
  // Handle source selection for image upload
  void onSourceSelected(ImageSource imageSource) async {
    final pickedFile = await pickFilesFromDevice(allowMultipleFiles: true);
    if (pickedFile.isNotEmpty) {
      Get.bottomSheet(
        AppDialogueComponent(
          titleText: "Do you want to upload this attachment?",
          confirmText: "Upload",
          onConfirm: () {
            imageFiles.addAll(pickedFile);
            fileNames.addAll(pickedFile.map((e) => e.path.split('/').last));
          },
        ),
        isScrollControlled: true,
      );
    }
  }
}
