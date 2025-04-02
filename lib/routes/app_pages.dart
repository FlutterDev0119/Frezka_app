import '../modules/prompt_admin/bindings/prompt_admin_binding.dart';
import '../modules/prompt_admin/views/prompt_admin_view.dart';
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
    GetPage(
      name: _Paths.PROMPTADMIN,
      page: () => PromptAdminScreen(),
      binding: PromptAdminBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
