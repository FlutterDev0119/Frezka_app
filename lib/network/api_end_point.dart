class APIEndPoints {
  ///Auth & User
  static const String login = 'v1/login/';
  static const String forgotPassword = 'v1/password-reset-request/';
  static const String socialLogin = 'google/';

  ///Prompt Admin
  static const String fetchDoc = 'v1/fetch_docs';
  static const String rolePromptResponse = 'v1/role_select';
  static const String newPrompt = 'v1/new_prompt';

  ///GenAI PV
  static const String fetchGenAIDocs = 'v1/fetch_docs';
  static const String fetchGenerateSQL = 'v1/generate_sql';
  static const String fetchDocsLanguage = 'v1/fetch_docs_language';

  ///GenAI Clinical
  static const String fetchDocClinical = 'v1/fetch_docs_clinical';
  static const String fetchAdditionalNarrative = 'v1/additional_narrative';
  static const String fetchNarrativeGeneration = 'v1/narrative_generation';

  ///Meta Phrase Pv
  static const String openWorklist = 'v1/open_worklist';
  static const String reverseTranslate = 'v1/reverse_translate';

  ///GovernAI
  static const String countTraces = 'v1/count_traces';
  static const String fetchTrace = 'v1/fetch_trace';

  /// Engage AI
  static const String chat = 'v1/chat';

  /// Translation Memory
  static const String translationMemory = 'v1/translation-memory';
  static const String stagingTranslationMemory = 'v1/staging-translation-memory';
  static const String aiTranslationMemory = 'v1/ai-translation-memory';
  /// Recon AI
  static const String reconciliation = 'v1/reconciliation';
}
