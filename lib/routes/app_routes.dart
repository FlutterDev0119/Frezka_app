part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const GENAICLINICAL = _Paths.GENAICLINICAL;
  static const MYAGENT = _Paths.MYAGENT;
  static const PROMPTADMIN = _Paths.PROMPTADMIN;
}

abstract class _Paths {
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const GENAICLINICAL = '/GenAI_Clinical';
  static const MYAGENT = '/my_agent';
  static const PROMPTADMIN = '/prompt_admin';

}
