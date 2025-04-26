class ReverseTranslateResponse {
  final String reverseTranslated;

  ReverseTranslateResponse({required this.reverseTranslated});

  factory ReverseTranslateResponse.fromJson(Map<String, dynamic> json) {
    return ReverseTranslateResponse(
      reverseTranslated: json['translated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translated': reverseTranslated,
    };
  }
}
