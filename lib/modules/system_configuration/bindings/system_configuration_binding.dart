import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controllers/system_configuration_controller.dart';

class SystemConfigurationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystemConfigurationController>(() =>SystemConfigurationController());
  }
}
