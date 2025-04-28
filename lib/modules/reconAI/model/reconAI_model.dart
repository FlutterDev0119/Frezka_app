class TranslationMemory {
  final int id;
   String es;
   String en;
   String lang;
   String name;

  TranslationMemory({
    required this.id,
    required this.es,
    required this.en,
    required this.lang,
    required this.name,
  });

  factory TranslationMemory.fromJson(Map<String, dynamic> json) {
    return TranslationMemory(
      id: json['id'] ?? 0,
      es: json['es'] ?? '',
      en: json['en'] ?? '',
      lang: json['lang'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'es': es,
      'en': en,
      'lang': lang,
      'name': name,
    };
  }
}
