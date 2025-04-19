class CountTracesModel {
  final Map<String, TraceData> tracesByDate;

  CountTracesModel({required this.tracesByDate});

  factory CountTracesModel.fromJson(Map<String, dynamic> json) {
    final mapped = json.map((date, data) =>
        MapEntry(date, TraceData.fromJson(Map<String, dynamic>.from(data))));
    return CountTracesModel(tracesByDate: mapped);
  }
}

class TraceData {
  final int genAIPV;
  final int reconAI;
  final int metaPhrasePV;
  final int genAIClinical;
  final int engageAI;

  TraceData({
    required this.genAIPV,
    required this.reconAI,
    required this.metaPhrasePV,
    required this.genAIClinical,
    required this.engageAI,
  });

  factory TraceData.fromJson(Map<String, dynamic> json) {
    return TraceData(
      genAIPV: json["GenAI PV"] ?? 0,
      reconAI: json["ReconAI"] ?? 0,
      metaPhrasePV: json["MetaPhrase PV"] ?? 0,
      genAIClinical: json["GenAI Clinical"] ?? 0,
      engageAI: json["Engage AI"] ?? 0,
    );
  }

  Map<String, int> toMap() {
    return {
      "GenAI PV": genAIPV,
      "ReconAI": reconAI,
      "MetaPhrase PV": metaPhrasePV,
      "GenAI Clinical": genAIClinical,
      "Engage AI": engageAI,
    };
  }
}
