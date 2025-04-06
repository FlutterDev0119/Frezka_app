part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const FORGOTPASSWORD = _Paths.FORGOTPASSWORD;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const GENAICLINICAL = _Paths.GENAICLINICAL;
  static const MYAGENT = _Paths.MYAGENT;
  static const PROMPTADMIN = _Paths.PROMPTADMIN;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const FORGOTPASSWORD = '/forgot_password';
  static const DASHBOARD = '/dashboard';
  static const GENAICLINICAL = '/GenAI_Clinical';
  static const MYAGENT = '/my_agent';
  static const PROMPTADMIN = '/prompt_admin';

}
