class NewPromptResponse {
  final bool status;
  final String message;
  final PromptData? data;

  NewPromptResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory NewPromptResponse.fromJson(Map<String, dynamic> json) {
    return NewPromptResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? PromptData.fromJson(json['data']) : null,
    );
  }
}

class PromptData {
  final int? id;
  final String? promptName;
  final Role? role;
  final String? group;
  final List<String>? source;
  final Map<String, dynamic>? metadata;
  final String? task;
  final String? createdAt;

  PromptData({
    this.id,
    this.promptName,
    this.role,
    this.group,
    this.source,
    this.metadata,
    this.task,
    this.createdAt,
  });

  factory PromptData.fromJson(Map<String, dynamic> json) {
    return PromptData(
      id: json['id'],
      promptName: json['prompt_name'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      group: json['group'],
      source: List<String>.from(json['source'] ?? []),
      metadata: json['metadata'] ?? {},
      task: json['task'],
      createdAt: json['created_at'],
    );
  }
}

class Role {
  final String? userRole;

  Role({this.userRole});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      userRole: json['user_role'],
    );
  }
}
