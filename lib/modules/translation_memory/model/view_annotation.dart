class ViewAnnotationRes {
  final String id;
  final int translationEditsId;
  final String userId;
  final String username;
  final String comment;
  final String createdAt;

  ViewAnnotationRes({
    required this.id,
    required this.translationEditsId,
    required this.userId,
    required this.username,
    required this.comment,
    required this.createdAt,
  });

  factory ViewAnnotationRes.fromJson(Map<String, dynamic> json) {
    return ViewAnnotationRes(
      id: json['_id'] ?? '',
      translationEditsId: json['translation_edits_id'] ?? 0,
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'translation_edits_id': translationEditsId,
      'user_id': userId,
      'username': username,
      'comment': comment,
      'created_at': createdAt,
    };
  }
}
