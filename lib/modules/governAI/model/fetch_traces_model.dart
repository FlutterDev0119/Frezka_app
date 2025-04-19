class Trace {
  final String id;
  final String name;
  final String executionTime;
  final double totalCost;
  final double? latency;
  final int? tokens;
  final String user;
  final String recommendedAction;

  Trace({
    required this.id,
    required this.name,
    required this.executionTime,
    required this.totalCost,
    required this.latency,
    required this.tokens,
    required this.user,
    required this.recommendedAction,
  });

  factory Trace.fromJson(Map<String, dynamic> json) {
    return Trace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      executionTime: json['Execution_time'] ?? '',
      totalCost: (json['Total_Cost'] ?? 0).toDouble(),
      latency: json['Latency'] != null ? double.tryParse(json['Latency'].toString()) : null,
      tokens: json['Tokens'] != null && json['Tokens'] != "NA"
          ? int.tryParse(json['Tokens'].toString())
          : null,
      user: json['User'] ?? 'Unknown User',
      recommendedAction: json['Recommended_Action'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Execution_time': executionTime,
      'Total_Cost': totalCost,
      'Latency': latency,
      'Tokens': tokens ?? 'NA',
      'User': user,
      'Recommended_Action': recommendedAction,
    };
  }
}
