import 'package:get/get.dart';
import '../controllers/meta_phrase_pv_controller.dart';

class MetaPhraseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MetaPhraseController>(() => MetaPhraseController());
  }
}
