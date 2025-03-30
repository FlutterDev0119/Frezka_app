import 'package:apps/utils/library.dart';

class MyAgentController extends GetxController {
  var selectedItems = <String>[].obs; // Fix: Use RxList<String>
  var dropdownItems = <String>["Dataasdas 1", "Dataasdad 2", "Dataasd 3"].obs;
  var agentItems = <String>["Metaphrase Lite", "GenAIpv", "Argus Intake", "HITL adfa"].obs;
  var additionalDropdown1 = <String>["Option ff A", "Optionff B", "Optionff C"].obs;
  var additionalDropdown2 = <String>["Choice ffX", "Choiceff Y", "Choiceff Z"].obs;

  void addItem(String item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }
}
