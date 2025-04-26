class CountTracesModel {
  final String date;
  final Map<String, int> values;

  CountTracesModel({required this.date, required this.values});

  factory CountTracesModel.fromMap(String date, Map<String, dynamic> json) {
    return CountTracesModel(
      date: date,
      values: json.map((key, value) => MapEntry(key, value as int)),
    );
  }
}
