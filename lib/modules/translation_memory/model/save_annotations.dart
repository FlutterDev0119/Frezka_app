class SaveAnnotationRes {
  final String success;

  SaveAnnotationRes({required this.success});

  factory SaveAnnotationRes.fromJson(Map<String, dynamic> json) {
    return SaveAnnotationRes(
      success: json['success'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
    };
  }
}
