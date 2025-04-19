import 'package:get/get.dart';
import '../controllers/governAI_controller.dart';

class GovernAIBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GovernAIController>(() => GovernAIController());
  }
}
