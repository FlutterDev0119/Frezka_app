import 'package:get/get.dart';
import '../controllers/translation_memory_controller.dart';

class TranslationMemoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TranslationMemoryController>(
        () => TranslationMemoryController());
  }
}
