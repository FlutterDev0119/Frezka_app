import 'package:get/get.dart';
import '../controllers/genAI_clinical_controller.dart';

class GenAIClinicalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenAIClinicalController>(() => GenAIClinicalController());
  }
}
