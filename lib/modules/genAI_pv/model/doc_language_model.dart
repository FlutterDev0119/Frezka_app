class DocLanguage {
  final List<String> output;

  DocLanguage({required this.output});

  factory DocLanguage.fromJson(Map<String, dynamic> json) {
    return DocLanguage(
      output: List<String>.from(json['output'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'output': output,
    };
  }
}
