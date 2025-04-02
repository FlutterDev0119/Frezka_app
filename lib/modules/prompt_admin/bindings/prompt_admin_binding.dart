import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controllers/prompt_admin_controller.dart';

class PromptAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromptAdminController>(() => PromptAdminController());
  }
}
