import 'package:get/get.dart';

import '../controllers/engageAI_controller.dart';

class EngageAIBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EngageAIController>(() => EngageAIController());
  }
}
