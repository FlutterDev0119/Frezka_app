import 'package:get/get.dart';

import '../../../utils/common/base_controller.dart';
import '../../../utils/library.dart';

abstract class ContentItem {}

class NewLineItem extends ContentItem {}

class TextItem extends ContentItem {
  String text;

  TextItem(this.text);
}

class ChipItem extends ContentItem {
  String chipText;

  ChipItem(this.chipText);
}

class MyAgentController extends BaseController {
  RxList<ContentItem> contentItems = <ContentItem>[].obs;
  TextEditingController textController = TextEditingController();
  TextEditingController agentNameController = TextEditingController();
  FocusNode focusNode = FocusNode();
  var selectedItems = <String>[].obs;
  var dropdownItems = <String>["Faers", "Pvanalytica data", "AWS S3", "Datalake"].obs;
  var agentItems = <String>["Metaphrase Lite", "GenAlpv", "Argus Intake", "HITL"].obs;
  var Scheduler = <String>["Work-day 8AM-5PM", "+ custom"].obs;
  var myAgents = <String>["Test", "Test 2", "Test 3"].obs;

  var agentName = ''.obs;

  RxList<String> responseData = <String>[].obs;

  // Update agent name when typing
  void updateAgentName(String value) {
    agentName.value = value.trim();
  }

  // Check if send button should be enabled
  bool get isSendButtonEnabled => contentItems.isNotEmpty && textController.text.isNotEmpty && agentName.isNotEmpty;

  void addItem(String item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }

  void addChipFromCurrentText() {
    String currentText = textController.text.trim();
    if (currentText.isNotEmpty) {
      contentItems.add(ChipItem(currentText));
      textController.clear();
      focusNode.requestFocus();
    }
  }

  void removeChip(int index) {
    contentItems.removeAt(index);
  }

  void updateLastTextItem(String value) {
    if (contentItems.isNotEmpty && contentItems.last is TextItem) {
      (contentItems.last as TextItem).text = value;
      contentItems.refresh();
    } else {
      contentItems.add(TextItem(value));
    }
  }

  void insertChip(String chipText) {
    String currentText = textController.text.trim();

    if (contentItems.isEmpty || contentItems.last is! TextItem) {
      contentItems.add(TextItem(''));
    } else {
      (contentItems.last as TextItem).text = currentText;
    }

    contentItems.add(ChipItem(chipText));

    if (chipText == "HITL") {
      // <<== Only for HITL, insert new line
      contentItems.add(NewLineItem());
    }

    contentItems.add(TextItem(''));
    textController.clear();
    contentItems.refresh();
    focusNode.requestFocus();
  }

  Future<void> hitlSend() async {
    if (contentItems.isEmpty && textController.text.isEmpty) {
      return;
    }

    String response = contentItems
        .map((item) {
          if (item is TextItem) {
            return item.text.trim();
          } else if (item is ChipItem) {
            return item.chipText.trim();
          } else {
            return '';
          }
        })
        .where((element) => element.isNotEmpty)
        .join(' ');

    if (response.contains('HITL')) {
      response = response.split('HITL')[0].trim() + ' HITL';
    }

    responseData.clear();
    responseData.add(response);

    textController.clear();
    contentItems.clear();
  }
}
