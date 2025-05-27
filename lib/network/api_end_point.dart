class APIEndPoints {
  ///Auth & User
  static const String login = 'login/';
  static const String forgotPassword = 'password-reset-request/';
  static const String socialLogin = 'google/';

  ///Prompt Admin
  static const String fetchDoc = 'fetch_docs';
  static const String rolePromptResponse = 'role_select';
  static const String newPrompt = 'new_prompt';

  ///GenAI PV
  static const String fetchLastQueries = 'last_5_queries';
  static const String fetchGenAIDocs = 'fetch_docs';
  static const String fetchGenerateSQL = 'generate_sql';
  static const String fetchDocsLanguage = 'fetch_docs_language';

  ///GenAI Clinical
  static const String fetchDocClinical = 'fetch_docs_clinical';
  static const String fetchClinicalData = 'fetch_clinical_data';
  static const String fetchAdditionalNarrative = 'additional_narrative';
  static const String fetchNarrativeGeneration = 'narrative_generation';
  static const String executePrompt = 'execute_prompt';

  ///Meta Phrase Pv
  static const String openWorklist = 'open_worklist';
  static const String reverseTranslate = 'reverse_translate';

  ///GovernAI
  static const String countTraces = 'count_traces';
  static const String fetchTrace = 'fetch_trace';

  /// Engage AI
  static const String chat = 'chat';

  /// Translation Memory
  static const String translationMemory = 'translation-memory';
  static const String stagingTranslationMemory = 'staging-translation-memory';
  static const String aiTranslationMemory = 'ai-translation-memory';
  static const String saveAnnotation = 'save_annotation';

  /// Recon AI
  static const String reconciliation = 'reconciliation';
}
