import 'package:apps/modules/governAI/view/governAI_view.dart';
import 'package:apps/modules/splash/views/splash_screen.dart';
import 'package:apps/modules/translation_memory/bindings/translation_memory_binding.dart';
import 'package:apps/modules/translation_memory/controllers/translation_memory_controller.dart';
import 'package:apps/modules/translation_memory/view/translation_memory_view.dart';

import '../modules/engageAI/bindings/engageAI_binding.dart';
import '../modules/engageAI/view/engageAI_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/genAI_pv/bindings/genAI_pv_binding.dart';
import '../modules/genAI_pv/view/genAI_pv_view.dart';
import '../modules/governAI/bindings/governAI_binding.dart';
import '../modules/logout/bindings/logout_binding.dart';
import '../modules/logout/views/logout_view.dart';
import '../modules/meta_phrase_pv/bindings/meta_phrase_pv_binding.dart';
import '../modules/meta_phrase_pv/view/meta_phrase_pv_view.dart';
import '../modules/prompt_admin/bindings/prompt_admin_binding.dart';
import '../modules/prompt_admin/views/prompt_admin_view.dart';
import '../modules/reconAI/bindings/reconAI_binding.dart';
import '../modules/reconAI/view/reconAI_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/system_configuration/bindings/system_configuration_binding.dart';
import '../modules/system_configuration/views/system_configuration_view.dart';
import '../utils/library.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;
  static const initialLogin = Routes.LOGIN;
  static const initialHome = Routes.DASHBOARD;
  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.LOGOUT,
      page: () => LogoutScreen(),
      binding: LogoutBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
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
      name: _Paths.GENAIPV,
      page: () => GenAIPVScreen(),
      binding: GenAIPVBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.ENGAGEAI,
      page: () => EngageAIScreen(),
      binding: EngageAIBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.GOVERNAI,
      page: () => GovernAIScreen(),
      binding: GovernAIBinding(),
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
    GetPage(
      name: _Paths.META_PHRASE_PV,
      page: () => MetaPhraseScreen(),
      binding: MetaPhraseBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.TRANSLATIONMEMORY,
      page: () => TranslationMemoryScreen(),
      binding: TranslationMemoryBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.SYSTEMCONFIGURATION,
      page: () => SystemConfigurationScreen(),
      binding: SystemConfigurationBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.RECONAI,
      page: () => ReconAIScreen(),
      binding: ReconAIBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
