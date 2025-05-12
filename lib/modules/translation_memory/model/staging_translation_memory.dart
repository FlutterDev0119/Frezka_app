// [
// {
// "id": 1,
// "es": "Médico inició medidas inmediatas",
// "en": "Doctor initiated immediate measures",
// "lang": "Spanish->English",
// "name": "Varun Dua"
// },
// {
// "id": 2,
// "es": "Personal sanitario recopiló datos",
// "en": "Healthcare professional collected data",
// "lang": "Italian->English",
// "name": "Varun Dua"
// },
// {
// "id": 3,
// "es": "Deutliche Atemnot bemerkt",
// "en": "Noticed significant shortness of breath",
// "lang": "German->English",
// "name": "Varun Dua"
// },
// {
// "id": 4,
// "es": "Starker allergischer Schock",
// "en": "Severe allergic shock",
// "lang": "German->English",
// "name": "Varun Dua"
// },
// {
// "id": 5,
// "es": "Reporter kontaktierte behandelnden Arzt",
// "en": "Reporter contacted treating physician",
// "lang": "German->English",
// "name": "Varun Dua"
// },
// {
// "id": 6,
// "es": "Arzt leitete Sofortmaßnahmen ein",
// "en": "Doctor initiated immediate measures",
// "lang": "German->English",
// "name": "Varun Dua"
// },
// {
// "id": 7,
// "es": "HCP sammelte Informationen",
// "en": "HCP collected information",
// "lang": "Danish->English",
// "name": "Varun Dua"
// }
// ]

class StagingTranslationRes {
  final int id;
  final String es;
  final String en;
  final String lang;
  final String name;

  StagingTranslationRes({
    required this.id,
    required this.es,
    required this.en,
    required this.lang,
    required this.name,
  });

  factory StagingTranslationRes.fromJson(Map<String, dynamic> json) {
    return StagingTranslationRes(
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

  static List<StagingTranslationRes> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => StagingTranslationRes.fromJson(json))
        .toList();
  }
}
