import 'package:get/get.dart';
import '../controllers/my_agent_controller.dart';

class MyAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAgentController>(() => MyAgentController());
  }
}
