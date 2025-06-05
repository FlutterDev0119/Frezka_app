class FetchTracesModel {
  final List<TraceData> data;
  final int page;

  FetchTracesModel({
    required this.data,
    required this.page,
  });

  factory FetchTracesModel.fromJson(Map<String, dynamic> json) {
    return FetchTracesModel(
      data: List<TraceData>.from(json['data'].map((item) => TraceData.fromJson(item))),
      page: json['page'],
    );
  }
}

class TraceData {
  final String id;
  final String name;
  final String executionTime;
  final double totalCost;
  final double latency;
  final int tokens;
  final String user;
  final String recommendedAction;
  final String hitl;

  TraceData({
    required this.id,
    required this.name,
    required this.executionTime,
    required this.totalCost,
    required this.latency,
    required this.tokens,
    required this.user,
    required this.recommendedAction,
    required this.hitl,
  });

  factory TraceData.fromJson(Map<String, dynamic> json) {
    return TraceData(
      id: json['id'],
      name: json['name'],
      executionTime: json['Execution_time'],
      totalCost: (json['Total_Cost'] ?? 0).toDouble(),
      latency: (json['Latency'] ?? 0).toDouble(),
      tokens: json['Tokens'] ?? 0,
      user: json['User'] ?? 'Unknown',
      recommendedAction: json['Recommended_Action'] ?? '',
      hitl: json['hitl'] ?? '',
    );
  }

  // ✅ Override equality and hashCode based on `id` (unique identifier)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TraceData &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

