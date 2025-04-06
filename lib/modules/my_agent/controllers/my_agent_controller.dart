import 'package:get/get.dart';

import '../../../utils/common/base_controller.dart';

class MyAgentController extends BaseController {
  var selectedItems = <String>[].obs;
  var dropdownItems = <String>["Data 1", "Data 2", "Data 3"].obs;
  var agentItems = <String>["Metaphrase Lite", "GenAIpv", "Argus Intake", "HITL"].obs;
  var additionalDropdown1 = <String>["Option A", "Option B", "Option C"].obs;
  var additionalDropdown2 = <String>["Choice X", "Choice Y", "Choice Z"].obs;

  void addItem(String item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }
}
