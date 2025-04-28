import 'package:get/get.dart';

import '../controllers/genAI_pv_controller.dart';

class GenAIPVBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenAIPVController>(() => GenAIPVController());
  }
}
