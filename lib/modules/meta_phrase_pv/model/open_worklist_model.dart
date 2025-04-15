class TranslationWork {
  final String id;
  final String sourceLanguage;
  final int translatedCount;
  final int originalCount;
  final int score;
  final String fileName;

  TranslationWork({
    required this.id,
    required this.sourceLanguage,
    required this.translatedCount,
    required this.originalCount,
    required this.score,
    required this.fileName,
  });

  // Factory constructor to create an instance from a Map (for JSON decoding)
  factory TranslationWork.fromMap(Map<String, dynamic> map) {
    return TranslationWork(
      id: map['_id'],
      sourceLanguage: map['source_language'],
      translatedCount: map['translated_count'],
      originalCount: map['original_count'],
      score: map['score'],
      fileName: map['file_name'],
    );
  }

  // Method to convert the instance to a Map (for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'source_language': sourceLanguage,
      'translated_count': translatedCount,
      'original_count': originalCount,
      'score': score,
      'file_name': fileName,
    };
  }
}