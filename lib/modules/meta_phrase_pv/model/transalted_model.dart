class SentenceScore {
  final String sentence;
  final int score;

  SentenceScore({required this.sentence, required this.score});

  factory SentenceScore.fromJson(List<dynamic> json) {
    return SentenceScore(
      sentence: json[0] as String,
      score: json[1] as int,
    );
  }

  List<dynamic> toJson() => [sentence, score];
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

  factory TranslationReport.fromJson(Map<String, dynamic> json) {
    return TranslationReport(
      id: json['_id'] as String,
      translatedFile: json['translated_file'] as String,
      originalFile: json['original_file'] as String,
      sourceLanguage: json['source_language'] as String,
      translatedCount: json['translated_count'] as int,
      originalCount: json['original_count'] as int,
      score: json['score'] as int,
      fileName: json['file_name'] as String,
      sentenceScore: (json['sentence_score'] as List)
          .map((item) => SentenceScore.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
