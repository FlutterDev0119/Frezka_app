class SaveJustificationRes {
  final String message;

  SaveJustificationRes({required this.message});

  factory SaveJustificationRes.fromJson(dynamic json) {
    return SaveJustificationRes(
      message: json.toString(), // since response is just a plain string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
