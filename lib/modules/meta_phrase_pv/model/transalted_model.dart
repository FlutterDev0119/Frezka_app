class SentenceScore {
  final String sentence;
  final int score;

  SentenceScore({required this.sentence, required this.score});

  // Factory method to create a SentenceScore from JSON
  factory SentenceScore.fromJson(List<dynamic> json) {
    // Ensure the json is a list of length 2, one for sentence and one for score
    return SentenceScore(
      sentence: json[0] as String? ?? '', // Default to empty string if null
      score: json[1] as int? ?? 0, // Default to 0 if null
    );
  }

  // Method to convert SentenceScore to JSON
  Map<String, dynamic> toJson() => {
    'sentence': sentence,
    'score': score,
  };
}
class TranslationReport {
  final String id;
  final String translatedFile;
  final String originalFile;
  final String sourceLanguage;
  final int translatedCount;
  final int originalCount;
  final int score;
  final String fileName;
  final List<SentenceScore> sentenceScore;

  TranslationReport({
    required this.id,
    required this.translatedFile,
    required this.originalFile,
    required this.sourceLanguage,
    required this.translatedCount,
    required this.originalCount,
    required this.score,
    required this.fileName,
    required this.sentenceScore,
  });

  // Factory method to create a TranslationReport from JSON
  factory TranslationReport.fromJson(Map<String, dynamic> json) {
    return TranslationReport(
      id: json['id'] as String? ?? '',
      translatedFile: json['translated_file'] as String? ?? '',
      originalFile: json['original_file'] as String? ?? '',
      sourceLanguage: json['source_language'] as String? ?? '',
      translatedCount: json['translated_count'] as int? ?? 0,
      originalCount: json['original_count'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      fileName: json['file_name'] as String? ?? '',
      sentenceScore: (json['sentence_score'] as List<dynamic>?)
          ?.map((item) => SentenceScore.fromJson(item as List<dynamic>))
          .toList() ?? [],
    );
  }

  // Method to convert TranslationReport to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translated_file': translatedFile,
      'original_file': originalFile,
      'source_language': sourceLanguage,
      'translated_count': translatedCount,
      'original_count': originalCount,
      'score': score,
      'file_name': fileName,
      'sentence_score': sentenceScore.map((s) => s.toJson()).toList(),
    };
  }
}
