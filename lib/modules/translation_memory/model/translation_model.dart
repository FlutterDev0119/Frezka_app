class TranslationItem {
  final int id;
  final String? es;
  final String? en;
  final String? lang;
  final String? name;

  TranslationItem({
    required this.id,
    this.es,
    this.en,
    this.lang,
    this.name,
  });

  factory TranslationItem.fromMap(Map<String, dynamic> map) {
    return TranslationItem(
      id: map['_id'],
      es: map['es'],
      en: map['en'],
      lang: map['lang'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'es': es,
      'en': en,
      'lang': lang,
      'name': name,
    };
  }
}
