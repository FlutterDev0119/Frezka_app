import 'package:apps/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:apps/modules/dashboard/views/dashboard_view.dart';
import 'package:apps/modules/my_agent/view/my_agent_view.dart';
import '../modules/genAI_clinical/bindings/genAI_clinical_binding.dart';
import '../modules/genAI_clinical/view/genAI_clinical_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_agent/bindings/my_agent_binding.dart';
import '../utils/library.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.LOGIN;
  static const initialHome = Routes.DASHBOARD;
  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.GENAICLINICAL,
      page: () => GenAIClinicalScreen(),
      binding: GenAIClinicalBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.MYAGENT,
      page: () => MyAgentScreen(),
      binding: MyAgentBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
