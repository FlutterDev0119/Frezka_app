// [
// {
// "id": 1,
// "es": "Anhything",
// "en": "anhything",
// "lang": "Vietnamese->Welsh",
// "name": "Metaphrase pv"
// },
// {
// "id": 2,
// "es": "Reparieren",
// "en": "repjgjort",
// "lang": "Romanian->Norwegian",
// "name": "Metaphrase pv"
// },
// {
// "id": 3,
// "es": "Reporter teilen Details",
// "en": "Reporter shared details\n",
// "lang": "Norwegian->English",
// "name": "Metaphrase pv"
// },
// {
// "id": 4,
// "es": "Pharmazeutische verifizierte Kontraindikationen",
// "en": "Farmacéutico verificó contraindicaciones\n\n\n",
// "lang": "German->Spanish",
// "name": "Metaphrase pv"
// },
// {
// "id": 5,
// "es": "KKK",
// "en": "kkk",
// "lang": "Swahili->Finnish",
// "name": "Metaphrase pv"
// },
// {
// "id": 6,
// "es": "bearbeiten",
// "en": "edit ",
// "lang": "German->Albanian",
// "name": "Metaphrase pv"
// },
// {
// "id": 7,
// "es": "Patientenzimmer",
// "en": "Patient Room",
// "lang": "German->Dutch",
// "name": "Metaphrase pv"
// },
// {
// "id": 8,
// "es": "Änderungen",
// "en": "edits",
// "lang": "German->Afrikaans",
// "name": "Metaphrase pv"
// }
// ]
class AiTranslationMemoryRes {
  final int id;
  final String es;
  final String en;
  final String lang;
  final String name;

  AiTranslationMemoryRes({
    required this.id,
    required this.es,
    required this.en,
    required this.lang,
    required this.name,
  });

  factory AiTranslationMemoryRes.fromJson(Map<String, dynamic> json) {
    return AiTranslationMemoryRes(
      id: json['id'],
      es: json['es'],
      en: json['en'],
      lang: json['lang'],
      name: json['name'],
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
