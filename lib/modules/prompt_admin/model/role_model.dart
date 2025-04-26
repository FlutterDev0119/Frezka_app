// models/role_response_model.dart
class RoleResponse {
  final String output;

  RoleResponse({required this.output});

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(output: json['output'] ?? '');
  }
}
