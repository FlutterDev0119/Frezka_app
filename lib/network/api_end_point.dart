class APIEndPoints {
  ///Auth & User
  static const String login = 'v1/login/';
  static const String forgotPassword = 'v1/password-reset-request/';
  static const String socialLogin = 'google/';

  ///Prompt Admin
  static const String fetchDoc = 'fetch_docs';

  ///Meta Phrase Pv
  static const String openWorklist = 'v1/open_worklist';
  static const String reverseTranslate = 'v1/reverse_translate';

  ///GovernAI
   static const String countTraces = 'v1/count_traces';
   static const String fetchTrace = 'v1/fetch_trace';
}
