import 'package:get/get.dart';

import '../controllers/reconAI_controller.dart';

class ReconAIBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReconAIController>(() => ReconAIController());
  }
}
