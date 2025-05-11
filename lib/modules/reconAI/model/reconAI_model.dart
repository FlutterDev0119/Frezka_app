class ReconRes {
  final List<Message> response;
  final String traceId;

  ReconRes({required this.response, required this.traceId});

  factory ReconRes.fromJson(Map<String, dynamic> json) {
    return ReconRes(
      response: (json['response'] as List<dynamic>)
          .map((e) => Message.fromJson(e))
          .toList(),
      traceId: json['trace_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'response': response.map((e) => e.toJson()).toList(),
    'trace_id': traceId,
  };
}

class Message {
  final String message;

  Message({required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
  };
}
