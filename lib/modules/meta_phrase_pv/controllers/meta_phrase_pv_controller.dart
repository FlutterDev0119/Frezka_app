import 'dart:convert';
import 'dart:io';

import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_dialogue_component.dart';
import '../../../utils/shared_prefences.dart';
import '../model/open_worklist_model.dart';
import '../model/transalted_model.dart';

enum SortColumn {
  id,
  sourceLanguage,
  originalCount,
  translatedCount,
  score,
}

class MetaPhraseController extends BaseController {
  final allFiles = <TranslationWork>[].obs;
  final filteredFiles = <TranslationWork>[].obs;
  final selectedTranslationReport = Rxn<TranslationReport>();

  final sortColumn = SortColumn.id.obs;
  final isAscending = true.obs;
  final selectedLanguage = ''.obs;

  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isReverse = false.obs;
  final RxBool isCredentialsConfirm = false.obs;

  var selectedMode = 'Review'.obs;
  RxBool isCardSelected = false.obs;
  final hasShownPeerReviewDialog = false.obs;

  late ScrollController translatedScrollController = ScrollController();
  late ScrollController translatedScrollController1 = ScrollController();
  final List<String> modes = ['Review', 'Edit', 'Peer Review', 'Finalize'];

  RxString reverseTranslatedText = ''.obs;
  var isEditing = false.obs;
  var isReject = false.obs;
  late TextEditingController translatedTextController;

  RxBool isPersonalSelected = false.obs;
  RxBool isWorkGroupSelected = false.obs;
  RxList<File> imageFiles = <File>[].obs;
  var isScoreHighlightMode = false.obs;
  var selected = 'Review'.obs;
  RxBool isShowDowanlaodButton = false.obs;
  RxBool isFinalizeDownloadshow= false.obs;

  ///Return
  var returnReson = [
    'Missing or untranslated sections',
    'Incorrect or inconsistent term usage',
    'Invalid TM Updates',
    'Sentence Structure needs improvement',
    'Other',
  ].obs;

  /// reject
  var reasons = [
    'Major structural or grammatical issues',
    'Translation inappropriate for target culture',
    'Literal translation altering the meaning',
    'Other',
  ].obs;

  var filteredReasons = <String>[].obs;
  var selectedReason = ''.obs;
  var isRejectSelected = false.obs;
  var selectedReturnReason = ''.obs;
  var filteredReturnReasons = <String>[].obs;

  final TextEditingController textSearchController = TextEditingController();
  final TextEditingController textReturnSearchController = TextEditingController();
  final TextEditingController rejectTextController = TextEditingController();
  final TextEditingController returnTextController = TextEditingController();
  RxBool isReturnSelected = false.obs;
  RxBool isHideReturnCard = false.obs;
  RxString changedData = ''.obs;
  String Fullname = '';
  String id = '';

  @override
  void onInit() {
    super.onInit();
    translatedScrollController = ScrollController();
    translatedScrollController1 = ScrollController();
    translatedTextController = TextEditingController();
    fetchData();
    isCredentialsConfirm.value = false;
    isFinalizeDownloadshow.value = false;
    hasShownPeerReviewDialog.value = false;
    filteredReasons.assignAll(reasons);
    filteredReturnReasons.assignAll(returnReson);
    isEditing.value = false;
    isShowDowanlaodButton.value = false;
    String? userJson = getStringAsync(AppSharedPreferenceKeys.userModel);

    if (userJson.isNotEmpty) {
      var userMap = jsonDecode(userJson);
      var userModel = UserModel.fromJson(userMap); // Replace with your actual model
      Fullname = "${userModel.firstName} ${userModel.lastName}";
      id = userModel.id.toString();
    }
    isHideReturnCard.value = false;
  }

  void onSearchTextChanged(String text) {
    if (text.isEmpty) {
      filteredReasons.assignAll(reasons);
    } else {
      filteredReasons.assignAll(
        reasons.where((reason) => reason.toLowerCase().contains(text.toLowerCase())),
      );
    }
    selectedReason.value = text;
  }

  void onReasonSelected(String? value) {
    if (value != null) {
      selectedReason.value = value;
      textSearchController.text = value;
    }
  }

  void onReturnReasonSelected(String? value) {
    if (value != null) {
      selectedReturnReason.value = value;
      textReturnSearchController.text = value;
    }
  }

  // void startEditing() {
  //   // Set the text in the controller based on the `translatedFile`
  //   translatedTextController.text = selectedTranslationReport.value?.translatedFile ?? '';
  //   isEditing.value = true; // Mark the edit mode as active
  // }

  void enterEditMode() {
    // Get the current value from wherever necessary
    translatedTextController.text =
        reverseTranslatedText.value.isNotEmpty ? reverseTranslatedText.value : selectedTranslationReport.value?.translatedFile ?? '';
    isEditing.value = true;
  }

  void exitEditMode() {
    isEditing.value = false;
    reverseTranslatedText.value = translatedTextController.text;
  }

  void updateSelectedMode(String mode) {
    selectedMode.value = mode;
  }

  List<Map<String, dynamic>>? getListFromStorage() {
    List<Map<String, dynamic>>? storedItems = getStringListAsync("setid_list")?.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    return storedItems;
  }

  /// Fetch all MetaPhrase work list
  Future<void> fetchData() async {
    if (isLoading.value) return;
    isCredentialsConfirm.value = false;
    isFinalizeDownloadshow.value = false;
    hasShownPeerReviewDialog.value = false;
    setLoading(true);
    try {
      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseList();
      allFiles.assignAll(result);
      _applySortAndFilter();
    } catch (e) {
      print('Error fetching MetaPhrase list: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Fetch details by ID and set selected translation report
  void fetchMetaDataById(String id) async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await MetaPhrasePVServiceApis.fetchMetaPhraseListById(id);

      if (result != null && result.isNotEmpty) {
        var fileData = result.first;

        selectedTranslationReport.value = fileData;
      } else {
        errorMessage.value = 'No data found for this file.';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      print('Fetch error: $e');
    } finally {
      setLoading(false);
      isLoading.value = false;
    }
  }

  /// Reverse translate
  Future<void> fetchReverseTranslation(String translatedText) async {
    try {
      isLoading.value = true;
      final response = await MetaPhrasePVServiceApis.reverseTranslate(
          request: {"text": translatedText, "source_language": selectedTranslationReport.value?.sourceLanguage.toString()});
      isReverse.value = true;
      reverseTranslatedText.value = response.reverseTranslated;
    } catch (e) {
      print('Reverse translation error: $e');
      reverseTranslatedText.value = 'Error occurred during reverse translation.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Put Justification
  Future<void> putJustification() async {
    String setId = getStringAsync("setid");
    try {
      isLoading.value = true;
      final response = await MetaPhrasePVServiceApis.putJustificationData(request: {
        "file_id": setId,
        "dropdown": selectedReturnReason.value.validate(),
        "textbox": returnTextController.text.validate(),
        "user_name": Fullname,
        "userId": id
      });
      log(response);
      if (response.message.isNotEmpty) {
        toast(response.message);
        isHideReturnCard.value = true;

      }
    } catch (e) {
      print('put Justification Data error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sort and filter list together
  void _applySortAndFilter() {
    List<TranslationWork> tempList = [...allFiles];

    // Apply filter if any
    if (selectedLanguage.isNotEmpty) {
      tempList = tempList.where((file) => file.sourceLanguage == selectedLanguage.value).toList();
    }

    // Apply sort
    tempList.sort((a, b) {
      int compare;
      switch (sortColumn.value) {
        case SortColumn.id:
          compare = a.id.compareTo(b.id);
          break;
        case SortColumn.sourceLanguage:
          compare = a.sourceLanguage.toLowerCase().compareTo(b.sourceLanguage.toLowerCase());
          break;
        case SortColumn.originalCount:
          compare = a.originalCount.compareTo(b.originalCount);
          break;
        case SortColumn.translatedCount:
          compare = a.translatedCount.compareTo(b.translatedCount);
          break;
        case SortColumn.score:
          compare = a.score.compareTo(b.score);
          break;
      }
      return isAscending.value ? compare : -compare;
    });

    filteredFiles.assignAll(tempList);
  }

  /// Trigger sorting by a column
  void toggleSort(SortColumn column) {
    if (sortColumn.value == column) {
      isAscending.toggle();
    } else {
      sortColumn.value = column;
      isAscending.value = true;
    }
    _applySortAndFilter();
  }

  /// Filter list by source language
  void filterByLanguage(String language) {
    selectedLanguage.value = language;
    _applySortAndFilter();
  }

  RxList<String> fileNames = <String>[].obs;

  void togglePersonal(bool? value) {
    isPersonalSelected.value = value ?? false;
  }

  void toggleWorkGroup(bool? value) {
    isWorkGroupSelected.value = value ?? false;
  }

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

  @override
  void dispose() {
    translatedScrollController.dispose();
    translatedScrollController1.dispose();
    super.dispose();
  }
}
