part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const LOGOUT = _Paths.LOGOUT;
  static const FORGOTPASSWORD = _Paths.FORGOTPASSWORD;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const GENAICLINICAL = _Paths.GENAICLINICAL;
  static const GENAIPV= _Paths.GENAIPV;
  static const ENGAGEAI= _Paths.ENGAGEAI;
  static const MYAGENT = _Paths.MYAGENT;
  static const PROMPTADMIN = _Paths.PROMPTADMIN;
  static const META_PHRASE_PV = _Paths.META_PHRASE_PV;
  static const GOVERNAI = _Paths.GOVERNAI;
  static const SYSTEMCONFIGURATION = _Paths.SYSTEMCONFIGURATION;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const LOGOUT = '/logout';
  static const FORGOTPASSWORD = '/forgot_password';
  static const DASHBOARD = '/dashboard';
  static const GENAICLINICAL = '/GenAI_Clinical';
  static const GENAIPV = '/GenAI_pv';
  static const MYAGENT = '/my_agent';
  static const PROMPTADMIN = '/prompt_admin';
  static const META_PHRASE_PV = '/meta-phrase-pv';
  static const GOVERNAI = '/governAI';
  static const ENGAGEAI = '/engageAI';
  static const SYSTEMCONFIGURATION = '/system_configuration';
}
