
import '../../../utils/library.dart';

class PromptAdminController extends GetxController {
  var isChecked = false.obs;
  var currentIndex = 0.obs;
  var isSuffixVisible = false.obs;
  TextEditingController inputController = TextEditingController();
  var userInput = [
    "# Adverse Event Reporting",
    "# Sampling",
    "# Aggregate Reporting",
    "# PV Agreements",
    "# Risk Management",
  ].obs;

  void toggleIcon() => isChecked.value = !isChecked.value;

  void userSubmittedData() {
    if (!userInput.contains(inputController.text) && inputController.text.isNotEmpty) {
      userInput.add(inputController.text);
      inputController.clear();
    }
  }

  void setTextFromList(int index) {
    if (index >= 0 && index < userInput.length) {
      inputController.text = userInput[index];
    }
  }

  void changeByUser() => isSuffixVisible.value = inputController.text.isNotEmpty;
}
